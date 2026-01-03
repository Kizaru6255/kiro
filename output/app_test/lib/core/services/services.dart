/// App-specific services.
/// 
/// Note: Core infrastructure services (network, storage, permissions, etc.)
/// are provided by the kiro_core package. Import them directly:
/// 
/// ```dart
/// import 'package:kiro_core/kiro_core.dart';
/// 
/// // Use DioClient for network requests
/// final response = await DioClient.instance.get('/api/users');
/// 
/// // Use PrefStorage for local storage
/// final storage = PrefStorage();
/// await storage.init();
/// await storage.setString('key', 'value');
/// ```
library;

// Export app-specific services here if needed
// Example: export 'custom_api_service.dart';
