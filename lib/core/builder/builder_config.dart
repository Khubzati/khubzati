// Builder.io Configuration
// This file contains the configuration for Builder.io integration

class BuilderConfig {
  // Builder.io Space ID
  static const String spaceId = '7c70fe005a624415a1a2934dd45adb0a';

  // Builder.io API Key (should be stored securely in production)
  static const String apiKey = 'YOUR_BUILDER_API_KEY';

  // Builder.io Model Name for content
  static const String modelName = 'page';

  // Base URL for Builder.io API
  static const String baseUrl = 'https://cdn.builder.io/api/v1';

  // Content URL for fetching content
  static String get contentUrl => '$baseUrl/content/$modelName';

  // Headers for API requests
  static Map<String, String> get headers => {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

  // Query parameters for content
  static Map<String, String> get queryParams => {
        'apiKey': apiKey,
        'spaceId': spaceId,
      };
}

// Builder.io Content Model
class BuilderContent {
  final String id;
  final String name;
  final Map<String, dynamic> data;
  final DateTime lastUpdated;

  BuilderContent({
    required this.id,
    required this.name,
    required this.data,
    required this.lastUpdated,
  });

  factory BuilderContent.fromJson(Map<String, dynamic> json) {
    return BuilderContent(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      data: json['data'] ?? {},
      lastUpdated: DateTime.parse(
          json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }
}

// Builder.io Service for fetching content
class BuilderService {
  static Future<List<BuilderContent>> fetchContent({
    String? url,
    Map<String, String>? queryParams,
  }) async {
    try {
      // This is a placeholder implementation
      // In a real implementation, you would make HTTP requests to Builder.io API
      print('Builder.io: Fetching content from Builder.io API');
      print('Space ID: ${BuilderConfig.spaceId}');
      print('URL: $url');
      print('Query Params: $queryParams');

      // Return mock data for now
      return [
        BuilderContent(
          id: '1',
          name: 'Sample Content',
          data: {
            'title': 'Welcome to Builder.io',
            'description': 'This is sample content from Builder.io',
          },
          lastUpdated: DateTime.now(),
        ),
      ];
    } catch (e) {
      print('Error fetching Builder.io content: $e');
      return [];
    }
  }
}
