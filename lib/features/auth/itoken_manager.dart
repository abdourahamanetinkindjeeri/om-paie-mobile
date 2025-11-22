abstract class ITokenManager {
  String? get accessToken;
  String? get refreshToken;
  DateTime? get accessTokenExpiry;
  bool get isAccessTokenExpired;

  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? accessTokenExpiry,
  });

  Future<void> clearTokens();
  Future<void> loadTokens();
}