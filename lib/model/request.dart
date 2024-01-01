class Request {
  String? prompt;

  Request({required this.prompt});

  Request.fromJson(Map<String, dynamic> json) {
    prompt = json['prompt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prompt'] = prompt;
    return data;
  }
}
