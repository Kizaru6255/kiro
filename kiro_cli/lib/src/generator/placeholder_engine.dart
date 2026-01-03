/// Placeholder replacement engine.
library;

/// Engine for replacing placeholders in templates.
class PlaceholderEngine {
  /// Placeholder pattern: {{PLACEHOLDER_NAME}}
  static final _placeholderPattern = RegExp(r'\{\{(\w+)\}\}');

  /// Conditional pattern: {{#if CONDITION}}...{{/if}}
  static final _conditionalPattern = RegExp(
    r'\{\{#if\s+(\w+)\}\}([\s\S]*?)\{\{/if\}\}',
    multiLine: true,
  );

  /// Loop pattern: {{#each ARRAY}}...{{/each}}
  static final _loopPattern = RegExp(
    r'\{\{#each\s+(\w+)\}\}([\s\S]*?)\{\{/each\}\}',
    multiLine: true,
  );

  /// Process template with values.
  static String process(String template, Map<String, dynamic> values) {
    var result = template;

    // Process conditionals first
    result = _processConditionals(result, values);

    // Process loops
    result = _processLoops(result, values);

    // Replace placeholders
    result = _replacePlaceholders(result, values);

    return result;
  }

  static String _processConditionals(String template, Map<String, dynamic> values) {
    return template.replaceAllMapped(_conditionalPattern, (match) {
      final condition = match.group(1)!;
      final content = match.group(2)!;

      final value = values[condition];
      final isTrue = _isTruthy(value);

      return isTrue ? content : '';
    });
  }

  static String _processLoops(String template, Map<String, dynamic> values) {
    return template.replaceAllMapped(_loopPattern, (match) {
      final arrayName = match.group(1)!;
      final content = match.group(2)!;

      final array = values[arrayName];
      if (array is! List) return '';

      final buffer = StringBuffer();
      for (var i = 0; i < array.length; i++) {
        var itemContent = content;
        final item = array[i];

        if (item is Map<String, dynamic>) {
          // Replace {{item.property}} with actual values
          for (final entry in item.entries) {
            itemContent = itemContent.replaceAll(
              '{{item.${entry.key}}}',
              entry.value.toString(),
            );
          }
        } else {
          // Replace {{item}} with the value
          itemContent = itemContent.replaceAll('{{item}}', item.toString());
        }

        // Replace {{index}} with current index
        itemContent = itemContent.replaceAll('{{index}}', i.toString());

        buffer.write(itemContent);
      }

      return buffer.toString();
    });
  }

  static String _replacePlaceholders(String template, Map<String, dynamic> values) {
    return template.replaceAllMapped(_placeholderPattern, (match) {
      final placeholder = match.group(1)!;
      final value = values[placeholder];

      if (value == null) {
        // Keep original if no value found
        return match.group(0)!;
      }

      return value.toString();
    });
  }

  static bool _isTruthy(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.isNotEmpty && value.toLowerCase() != 'false';
    if (value is num) return value != 0;
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    return true;
  }

  /// Simple placeholder replacement (for __PLACEHOLDER__ style).
  static String replacePlaceholders(
    String content,
    Map<String, String> replacements,
  ) {
    var result = content;
    for (final entry in replacements.entries) {
      result = result.replaceAll('__${entry.key}__', entry.value);
    }
    return result;
  }

  /// Extract all placeholders from template.
  static Set<String> extractPlaceholders(String template) {
    final placeholders = <String>{};

    for (final match in _placeholderPattern.allMatches(template)) {
      placeholders.add(match.group(1)!);
    }

    return placeholders;
  }

  /// Validate that all required placeholders have values.
  static List<String> getMissingPlaceholders(
    String template,
    Map<String, dynamic> values,
  ) {
    final placeholders = extractPlaceholders(template);
    return placeholders.where((p) => !values.containsKey(p)).toList();
  }
}

