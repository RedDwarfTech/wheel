class RestLogModel {
  RestLogModel({required this.message,this.stackTrace,this.error});

  String message;

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
