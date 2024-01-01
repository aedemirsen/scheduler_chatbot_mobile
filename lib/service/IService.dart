import 'package:dio/dio.dart';
import 'package:scheduler_chatbot/model/request.dart';
import 'package:scheduler_chatbot/model/response.dart' as r;

abstract class IService {
  final Dio dio;

  final String requestEndpoint = '/request';
  final String welcomeEndpoint = '/welcome';

  IService(this.dio);

  Future<r.Response?> sendMessage(Request request);

  Future<r.Response?> getWelcomeMessage();
}
