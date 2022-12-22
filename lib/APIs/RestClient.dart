import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../Helper/Constants.dart';

class RestClient {
// Get:-----------------------------------------------------------------------
  Future<Response> get(
    String url, {
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) //Encoding encoding
  async {
    printFullLink(url,body);
    final bool isConnected = await Helper.isInternetAvailble();
    if (isConnected) {
      final response = await Dio().get(url, queryParameters: body).catchError((error) {
        throw error;
      });
      return response;
    } else {
      throw Constants.noInternetConnection;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(
    String url, {
    required Map<String, String> headers,
    required Map<String, dynamic> body,
     FormData? data,
  }) async {

    printFullLink(url,body);
    final bool isConnected = await Helper.isInternetAvailble();
    if (isConnected) {
      final response = await Dio()
          .post(url, queryParameters: body, data: data)//headers was no data para, value
          .catchError((error) {
        throw error;
      });
      return response;
    } else {
      throw Constants.noInternetConnection;
    }
  }

  // Put:----------------------------------------------------------------------
  Future<dynamic> put(
    String url, {
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) async {
    final bool isConnected = await Helper.isInternetAvailble();
    if (isConnected) {
      final response =
          await Dio().put(url, queryParameters: body).catchError((error) {
        throw error;
      });
      return response;
    } else {
      throw Constants.noInternetConnection;
    }
  }

  // Patch:----------------------------------------------------------------------
  Future<dynamic> patch(
    String url, {
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) async {
    final bool isConnected = await Helper.isInternetAvailble();
    if (isConnected) {
      final response =
          await Dio().patch(url, queryParameters: body).catchError((error) {
        throw error;
      });
      return response;
    } else {
      throw Constants.noInternetConnection;
    }
  }

  // Delete:----------------------------------------------------------------------
  Future<dynamic> delete(String url,
      {required Map<String, String> headers}) async {
    final bool isConnected = await Helper.isInternetAvailble();
    if (isConnected) {
      final response = await Dio().delete(url).catchError((error) {
        throw error;
      });
      return response;
    } else {
      throw Constants.noInternetConnection;
    }
  }

  void printFullLink(String urll,Map<String, dynamic> param) {
    // var str = Constants.BASE_URL + '?';
    var str = urll + '?';
    param.entries.forEach((element) {
      str = str + element.key + '=' + element.value.toString() + '&';
    });
    str = str.substring(0, str.length - 1);
    final url = Uri.parse(str);
    print('URL Called ::::: $url');
  }
}
