import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:promilo_project/repository/internet_connection_service.dart';
import 'package:promilo_project/utils/constants.dart';
import 'package:promilo_project/utils/log_util.dart';
import 'package:promilo_project/utils/toast_message.dart';

enum RequestType { post, get, put, patch, delete, multiPart }

class CustomRequest {
  String url;
  String urlName;
  Map<String, String>? params;
  Map<String, String>? headers;
  dynamic body;
  Map<String, dynamic>? multiPart;

  CustomRequest({required this.url, required this.urlName, this.params, this.headers, this.body, this.multiPart});

  @override
  String toString() {
    return 'CustomRequest{url: $url, urlName: $urlName, params: $params, headers: headers, body: $body, fields: $multiPart}';
  }
}

class CustomResponse {
  int statusCode;
  String message;
  dynamic result;

  CustomResponse({required this.statusCode, required this.message, required this.result});

  @override
  String toString() {
    return 'CustomResponse{statusCode: $statusCode, message: $message, result: $result}';
  }
}

abstract class BaseHttpService {
  Future<dynamic> onGetRequest(CustomRequest request);

  Future<dynamic> onPostRequest(CustomRequest request);

  Future<dynamic> onPutRequest(CustomRequest request);

  Future<dynamic> onPatchRequest(CustomRequest request);

  Future<dynamic> onDeleteRequest(CustomRequest request);

  /// Please maintain the key name for multiPart CustomRequest
  ///  1. filePaths
  ///  2. fileTypes
  ///  3. multiPartFieldKeys
  ///
  /// Example :-
  ///  Use  [multiPart]  parameter in  [CustomRequest]  for sending multiPartRequest to Server.
  ///     List<String> filePaths = [];
  ///     List<String> fileTypes = [];
  ///     Map<String, dynamic> multiPart = {
  ///         'filePaths': filePaths,
  ///         'fileTypes': fileTypes,
  ///         'input': jsonEncode(model.toJson())
  ///     };
  ///     CustomRequest(multiPart: multiPart);
  Future<dynamic> onMultiPartRequest(CustomRequest request);
}

class HttpServiceImpl implements BaseHttpService {
  final InternetConnectionService internetConnection;

  HttpServiceImpl({required this.internetConnection});

  @override
  Future onGetRequest(CustomRequest request) {
    return _responseService(request, RequestType.get);
  }

  @override
  Future onPostRequest(CustomRequest request) {
    return _responseService(request, RequestType.post);
  }

  @override
  Future onPutRequest(CustomRequest request) {
    return _responseService(request, RequestType.put);
  }

  @override
  Future onPatchRequest(CustomRequest request) {
    return _responseService(request, RequestType.patch);
  }

  @override
  Future onDeleteRequest(CustomRequest request) {
    return _responseService(request, RequestType.delete);
  }

  @override
  Future onMultiPartRequest(CustomRequest request) {
    return _responseService(request, RequestType.multiPart);
  }

  Future<dynamic> _responseService(CustomRequest request, RequestType requestType) async {
    return internetConnection.isInternetConnected().then((isConnected) async {
      final Map<String, String> jsonHeaders = {'content-type': 'application/json'};
      if (isConnected) {
        try {
          Uri uri = Uri.parse(request.url);
          dynamic body = request.body;
          LogUtil.logPrint('URL DETAILS', '========================================================');
          LogUtil.logPrint('Request Body', body);
          LogUtil.logPrint('Request Param', request.params);
          Uri url = uri.replace(queryParameters: request.params);
          Map<String, String>? headers = request.headers ?? jsonHeaders;
          switch (requestType) {
            case RequestType.get:
              Response response = await get(url, headers: headers);
              return _checkResponseStatus(response, request.urlName);
            case RequestType.post:
              Response response = await post(url, headers: headers, body: body);
              return _checkResponseStatus(response, request.urlName);
            case RequestType.put:
              Response response = await put(url, headers: headers, body: body);
              return _checkResponseStatus(response, request.urlName);
            case RequestType.patch:
              Response response = await patch(url, headers: headers, body: body);
              return _checkResponseStatus(response, request.urlName);
            case RequestType.delete:
              Response response = await delete(url, headers: headers, body: body);
              return _checkResponseStatus(response, request.urlName);
            case RequestType.multiPart:
              MultipartRequest multipartRequest = MultipartRequest('POST', uri);
              LogUtil.logPrint('multiPart', request.multiPart);
              if (request.multiPart != null) {
                headers.forEach((key, value) => multipartRequest.headers[key] = value);
                multipartRequest.fields.addAll(request.multiPart!['fields']);
                Map<String, File?> files = request.multiPart!['files'];
                files.forEach((key, value) {
                  if (value != null) {
                    multipartRequest.files.add(MultipartFile(key, value.readAsBytes().asStream(), value.lengthSync(),
                        contentType: MediaType('application', value.path.split(".").last), filename: value.path.split("/").last));
                  }
                });
              }
              Response response = await Response.fromStream(await multipartRequest.send());
              return _checkResponseStatus(response, request.urlName);
            default:
              return CustomResponse(statusCode: 000, message: "${request.urlName}Exception", result: null);
          }
        } on SocketException {
          ToastMessage.showMessage('Connection time out', kToastErrorColor);
          return CustomResponse(statusCode: 000, message: 'Connection time out', result: null);
        } catch (e) {
          LogUtil.logPrint('responseServiceException', e.toString());
          return CustomResponse(statusCode: 000, message: '${request.urlName}Exception', result: e.toString());
        }
      } else {
        ToastMessage.showMessage(Constants.checkInternetConnection, kToastErrorColor);
        return CustomResponse(statusCode: 499, message: Constants.checkInternetConnection, result: null);
      }
    });
  }

  Future _checkResponseStatus(Response response, String urlName) async {
    LogUtil.logPrint('Request Method', response.request?.method);
    LogUtil.logPrint('${urlName}Url', response.request?.url);
    LogUtil.logPrint('${urlName}Response', response.statusCode);
    LogUtil.logPrint('URL DETAILS', '========================================================');
    LogUtil.logPrint('${urlName}Response', response.body);
    try {
      switch (response.statusCode) {
        case successResponseCode:
          return CustomResponse(statusCode: successResponseCode, message: "OK", result: jsonDecode(utf8.decode(response.bodyBytes)));
        case 400:
          return CustomResponse(statusCode: 400, message: "Bad request", result: jsonDecode(response.body));
        case 401:
          ToastMessage.showMessage("Unauthorized", kToastErrorColor);

          return CustomResponse(statusCode: 401, message: "Unauthorized", result: jsonDecode(response.body));
        case 403:
          ToastMessage.showMessage("You do not have access right for this operation.", kToastErrorColor);
          return CustomResponse(statusCode: 403, message: "Forbidden request", result: jsonDecode(response.body));
        case 404:
          ToastMessage.showMessage("Not found", kToastErrorColor);
          return CustomResponse(statusCode: 404, message: "Not found", result: jsonDecode(response.body));
        case 405:
          ToastMessage.showMessage("Method not allowed", kToastErrorColor);
          return CustomResponse(statusCode: 405, message: "Method not allowed", result: jsonDecode(response.body));
        case 415:
          ToastMessage.showMessage("Media type not supported.", kToastErrorColor);
          return CustomResponse(statusCode: 415, message: "Media type not supported.", result: jsonDecode(response.body));
        case 423:
          ToastMessage.showMessage("Access denied.", kToastErrorColor);
          return CustomResponse(statusCode: 423, message: "Access denied.", result: jsonDecode(response.body));
        case 500:
          ToastMessage.showMessage("Internal server error", kToastErrorColor);
          return CustomResponse(statusCode: 500, message: "Internal server error", result: jsonDecode(response.body));
        case 503:
          ToastMessage.showMessage("Service unavailable", kToastErrorColor);
          return CustomResponse(statusCode: 503, message: "Service unavailable", result: jsonDecode(response.body));
        default:
          ToastMessage.showMessage("Unknown request", kToastErrorColor);
          return CustomResponse(statusCode: response.statusCode, message: "Unknown request", result: jsonDecode(response.body));
      }
    } on FormatException catch (fc) {
      LogUtil.logPrint('formatException', fc.toString());
      return CustomResponse(statusCode: response.statusCode, message: "OK", result: response.body);
    } catch (e) {
      LogUtil.logPrint('formatException', e.toString());
      return CustomResponse(statusCode: response.statusCode, message: "OK", result: response.body);
    }
  }
}
