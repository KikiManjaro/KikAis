import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/forwarder_service.dart';
import 'package:kik_ais/target_config.dart';

void main() {
  group('shouldForwardToTarget', () {
    final base = TargetConfig(id: 't1', name: 'Test', protocol: ForwardProtocol.udpServer, host: '127.0.0.1', port: 10110);
    test('empty filter allows all', () {
      expect(shouldForwardToTarget('!AIVDM,1,1,,A,15Mv6J002GO?;H<A>0Mv:2wv0D0p,0*0A', base), isTrue);
    });
    test('filter allows matching type', () {
      // payload starting with '1' -> type 1
      final filtered = base.copyWith(allowedTypes: {1});
      expect(shouldForwardToTarget('!AIVDM,1,1,,A,15Mv6J002GO?;H<A>0Mv:2wv0D0p,0*0A', filtered), isTrue);
    });
    test('filter blocks non-matching type', () {
      final filtered = base.copyWith(allowedTypes: {5});
      expect(shouldForwardToTarget('!AIVDM,1,1,,A,15Mv6J002GO?;H<A>0Mv:2wv0D0p,0*0A', filtered), isFalse);
    });
    test('non-AIS lines pass through', () {
      final filtered = base.copyWith(allowedTypes: {1});
      expect(shouldForwardToTarget('hello world', filtered), isTrue);
    });
    test('toJson/fromJson round-trip preserves allowedTypes', () {
      final c = base.copyWith(allowedTypes: {1,5,18});
      final restored = TargetConfig.fromJson(c.toJson());
      expect(restored.allowedTypes, {1,5,18});
    });
    test('tryExtractAisMessageType parses payload', () {
      expect(tryExtractAisMessageType('!AIVDM,1,1,,A,15Mv6J0P00G?35R0`J`v0w`2D0p,0*00'), 1);
      // 5 -> vessel static
      expect(tryExtractAisMessageType('!AIVDM,1,1,,A,55Mv6J002GO?;H<A>0Mv:2wv0D0p,0*00'), 5);
    });
  });
}
