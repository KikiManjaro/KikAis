# RTL-SDR Blog drivers (Windows)

This folder holds the **RTL-SDR Blog** Windows DLLs (the "drivers" the V4
dongles require) that KikAis loads at runtime through `lib/sdr/rtlsdr_ffi.dart`:

- `rtlsdr.dll` — the V4-compatible librtlsdr build (also works with V3 and
  generic RTL2832U dongles). The rtlsdr-blog build talks to the dongle through
  the Windows **WinUSB** driver directly, so no libusb is required.
- `pthreadVC2.dll`, `msvcr100.dll` — runtime dependencies of rtlsdr.dll

They are copied next to `KikAis.exe` by the Windows build (see
`windows/runner/CMakeLists.txt`), so the zip, portable and installer artifacts
all ship them automatically.

## Source & integrity

Downloaded from the official release
`https://github.com/rtlsdrblog/rtl-sdr-blog/releases` — tag **V1.4.0**,
asset **Release.zip**:

    sha256: 7ef33f1304647f65e5e0fde43637a73d54f076e91e651a3cecc4f55a17fd9815

Only the 64-bit DLLs from the `x64/` folder are used (KikAis is a 64-bit app).
Use `scripts/fetch_rtlsdr_drivers.ps1` to (re)download and extract them.

## Notes

- **Windows USB driver**: the DLLs above make the *software* talk to the
  dongle; Windows itself must expose the dongle through a WinUSB driver first.
  Install it with **Zadig** (select "Bulk-In, Interface (Interface 0)", USB ID
  `0BDA 2838`) or the signed driver installer from the same release.
- **Linux**: no bundling needed — install the system `librtlsdr` package (e.g.
  `apt install librtlsdr-dev`) plus the udev rules; the app loads
  `librtlsdr.so.0` at runtime.
- **License**: these binaries are GPLv2, distributed as a separate dynamically
  loaded DLL (standard practice across the whole RTL-SDR ecosystem). The app's
  own source remains under its custom license.
