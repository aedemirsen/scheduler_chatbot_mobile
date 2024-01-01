import 'dart:io';

import 'package:dio/dio.dart';
import 'package:scheduler_chatbot/model/request.dart';
import 'package:scheduler_chatbot/model/response.dart' as r;
import 'package:scheduler_chatbot/service/IService.dart';

class Service extends IService {
  Service(super.dio);

  @override
  Future<r.Response?> getWelcomeMessage() async {
    try {
      final response = await dio.get(
        welcomeEndpoint,
      );
      if (response.statusCode == 200) {
        return r.Response.fromJson((response.data));
      }
    } on Exception {
      return null;
    }
    return null;
  }

  @override
  Future<r.Response?> sendMessage(Request request) async {
    final response = await dio.post(
      requestEndpoint,
      data: request,
      options: Options(contentType: Headers.jsonContentType),
    );
    if (response.statusCode == HttpStatus.ok) {
      return r.Response.fromJson(response.data);
    }
    return null;
  }
}
