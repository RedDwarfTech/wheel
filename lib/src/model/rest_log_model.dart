class RestLogModel {
  RestLogModel({required this.message,this.stackTrace});

  String message;

  String? stackTrace;

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "stackTrace":stackTrace
    };
  }
}
