import 'package:promilo_project/api_client/api_client.dart';
import 'package:promilo_project/models/login_model.dart';

abstract class LoginRepository {
  Future<LoginModel> doLogin(CustomRequest request);
}

class LoginRepoImpl extends LoginRepository {
  final BaseHttpService _service;

  LoginRepoImpl(this._service);

  @override
  Future<LoginModel> doLogin(CustomRequest request) async {
    CustomResponse response = await _service.onPostRequest(request);
    return LoginModel.fromJson(response.result);
  }
}
