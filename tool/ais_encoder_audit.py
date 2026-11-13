"""Cross-checks the AIS messages produced by tool/ais_encoder_audit.dart.

pyais 3.x is the oracle: every message is decoded independently and its fields
are compared with what the Dart encoder was asked to produce. Two caveats are
handled explicitly:

* pyais scales the Type 22/23 zone corners by 10 instead of 600 (libais uses
  ``divisor = 600.0`` for the 18/17-bit point, which matches ITU-R M.1371
  "1/10 min"), so those two types are checked on the raw integer values.
* pyais does not enforce the 82-character NMEA limit nor the 62-character
  payload limit; those checks live in the Dart audit.

Usage: python tool/ais_encoder_audit.py [build/encoder_audit.jsonl]
"""

import json
import sys

import pyais

ALIASES = {
    "name": ("shipname", "name"),
    "ship_type": ("ship_type",),
    "station_type": ("station_type",),
    "text": ("text",),
    "quiet": ("quiet",),
    "interval": ("interval",),
    "partno": ("partno",),
}


def payload_bits(line):
    _, _, _, _, _, payload, fill = line.split(",")
    fill = int(fill.split("*")[0])
    bits = []
    for char in payload:
        value = ord(char) - 48
        if value > 40:
            value -= 8
        bits.append(format(value, "06b"))
    return "".join(bits), fill


def signed(bits):
    value = int(bits, 2)
    return value - (1 << len(bits)) if bits and bits[0] == "1" else value


def plain(value):
    return value.value if hasattr(value, "value") else value


def compare(label, expected, decoded, raw_bits):
    problems = []
    skip = set()
    if expected.get("_raw_type23"):
        skip = {"ship_type", "station_type", "quiet", "ne_lon", "ne_lat",
                "sw_lon", "sw_lat"}
    for key, want in expected.items():
        if key in skip or key.startswith("_"):
            continue
        name = next((n for n in ALIASES.get(key, (key,)) if n in decoded), None)
        if name is None:
            problems.append(f"{key}: absent from pyais output")
            continue
        got = plain(decoded[name])
        if key in ("text", "name"):
            if str(got).strip().strip("@") != str(want).strip().strip("@"):
                problems.append(f"{key}: {got!r} != {want!r}")
        elif key in ("lat", "lon", "sog", "cog", "heading"):
            if abs(float(got) - float(want)) > 0.01:
                problems.append(f"{key}: {got} != {want}")
        elif got != want:
            problems.append(f"{key}: {got} != {want}")
    return problems


def check_zone(type_no, expected, raw_bits):
    """Type 22/23 corners use 1/10 min (raw / 600); pyais divides by 10."""
    if type_no == 23:
        spans = {"ne_lon": (40, 58), "ne_lat": (58, 75),
                 "sw_lon": (75, 93), "sw_lat": (93, 110)}
    else:
        spans = {"ne_lon": (69, 87), "ne_lat": (87, 104),
                 "sw_lon": (104, 122), "sw_lat": (122, 139)}
    problems = []
    for key, (start, end) in spans.items():
        if key not in expected:
            continue
        want = round(expected[key] * 600)
        got = signed(raw_bits[start:end])
        if got != want:
            problems.append(f"{key}: raw {got} != {want} ({expected[key]} deg)")
    if type_no == 23:
        # pyais resolves the ship type through its ShipType enum and returns 0
        # for values it does not know (e.g. 200), so read the wire bits.
        fields = {"station_type": (110, 114), "ship_type": (114, 122),
                  "quiet": (150, 154)}
        for key, (start, end) in fields.items():
            if key not in expected:
                continue
            got = int(raw_bits[start:end], 2)
            if got != expected[key]:
                problems.append(f"{key}: raw {got} != {expected[key]}")
    return problems


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "build/encoder_audit.jsonl"
    total = failed = 0
    for line in open(path, encoding="utf-8"):
        case = json.loads(line)
        total += 1
        lines = case["lines"]
        problems = list(case["issues"])
        bits, _ = payload_bits(lines[-1])
        try:
            decoded = pyais.decode(*lines).asdict()
        except Exception as exc:  # noqa: BLE001 - report whatever pyais says
            problems.append(f"pyais rejected the message: {type(exc).__name__}: {exc}")
            decoded = None
        if decoded is not None:
            problems += compare(case["label"], case["expect"], decoded, bits)
            if case["type"] in (22, 23):
                problems += check_zone(case["type"], case["expect"], bits)
        status = "ok  " if not problems else "FAIL"
        if problems:
            failed += 1
        print(f"{status} type {case['type']:>2} {case['label']}")
        for problem in problems:
            print(f"       -> {problem}")
    print(f"\n{total} cases, {failed} with problems")


if __name__ == "__main__":
    main()
