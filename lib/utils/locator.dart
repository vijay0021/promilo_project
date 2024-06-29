import 'package:promilo_project/api_client/api_client.dart';
import 'package:promilo_project/repository/internet_connection_service.dart';
import 'package:promilo_project/repository/login_repository.dart';
import 'package:promilo_project/utils/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());
  locator.registerLazySingleton<SessionManager>(() => SessionManager(locator.get<SharedPreferences>()));

  locator.registerSingleton<InternetConnectionService>(InternetConnectionImpl());
  locator.registerSingleton<BaseHttpService>(HttpServiceImpl(internetConnection: locator<InternetConnectionService>()));

  locator.registerLazySingleton<LoginRepository>(() => LoginRepoImpl(locator.get<BaseHttpService>()));

}