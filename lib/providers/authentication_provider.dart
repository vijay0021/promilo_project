import 'package:flutter/material.dart';
import 'package:promilo_project/api_client/api_client.dart';
import 'package:promilo_project/models/login_req_model.dart';
import 'package:promilo_project/repository/login_repository.dart';
import 'package:promilo_project/utils/locator.dart';
import 'package:promilo_project/utils/session_manager.dart';
import 'package:promilo_project/utils/urls.dart';

class AuthenticationProvider with ChangeNotifier {
  final _service = locator.get<LoginRepository>();
  final _session = locator.get<SessionManager>();
  bool isLoading = false, isRemember = false;

  void init() {
      isRemember = _session.isRemember();
  }

  void setRemember(bool val) {
    isRemember = val;
    _session.setRemember(val);
    notifyListeners();
  }

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  Future<bool> login(BuildContext context, LoginReqModel data) async {
    setLoading(true);
    final headers = {'Content-type': 'application/json', 'Accept': 'application/json', 'Authorization' : 'Basic UHJvbWlsbzpxNCE1NkBaeSN4MiRHQg=='};
    final request = CustomRequest(url: Urls.loginUrl, urlName: 'login', headers: headers, params: data.toJson());
    return _service.doLogin(request).then((response) {
      if (response.status != null && response.status!.code == 200) {
        return true;
      }
      return false;
    }).whenComplete(() => setLoading(false));
  }
}
