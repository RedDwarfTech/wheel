class RestLogModel {
  RestLogModel({required this.message,this.requestId,this.stackTrace,this.error});

  String message;

  String? requestId;

  String? stackTrace;

  String? error;

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "stackTrace":stackTrace,
      "error": error
    };
  }
}
