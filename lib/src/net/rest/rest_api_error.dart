class RestApiError extends Error {
  final String message;

  RestApiError(this.message);
}