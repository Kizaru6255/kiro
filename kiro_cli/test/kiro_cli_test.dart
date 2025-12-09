import 'package:kiro_cli/kiro_cli.dart';
import 'package:test/test.dart';

void main() {
  test('CLI exports are available', () {
    // Test that main exports are accessible
    expect(runKiroCli, isNotNull);
  });
}
