/// why define the local cache element seperate?
/// https://stackoverflow.com/questions/74624500/what-should-i-do-to-solve-the-altstore-cache-key-conflict-issue
/// the cached key will conflict when using altstore to install multiple apps
class LocalCacheElement {
  LocalCacheElement({required this.accessToken, required this.refreshToken, required this.registerTime, required this.username});

  String accessToken;
  String refreshToken;
  String registerTime;
  String username;

  Map<String, dynamic> toMap() {
    return {"accessToken": accessToken, "refreshToken": refreshToken, "registerTime": registerTime, "username": username};
  }
}
