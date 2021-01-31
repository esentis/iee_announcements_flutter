class UserSession {
  String accessToken;
  String refreshToken;
  String userId;

  UserSession({
    this.accessToken,
    this.refreshToken,
    this.userId,
  });

  String get getAccessToken => accessToken;
  String get getRefreshToken => refreshToken;
  String get getUseridToken => userId;

  set setAccessToken(String accessToken) {
    this.accessToken = accessToken;
  }

  set setRefreshToken(String refreshToken) {
    this.refreshToken = refreshToken;
  }

  set setUserId(String userId) {
    this.userId = userId;
  }
}
