class AppConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  const AppConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
    this.sendTimeout = const Duration(seconds: 10),
  });

  static const development = AppConfig(
    baseUrl: 'http://localhost:3000',
  );

  static const production = AppConfig(
    baseUrl: 'https://api.yourdomain.com',
  );
}
