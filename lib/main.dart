import 'package:flutter/material.dart';
import 'package:promilo_project/providers/authentication_provider.dart';
import 'package:promilo_project/providers/home_provider.dart';
import 'package:promilo_project/routes/routes.dart';
import 'package:promilo_project/screens/login/login_page.dart';
import 'package:promilo_project/utils/constants.dart';
import 'package:promilo_project/utils/locator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()..init()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        onGenerateRoute: Routes.generateRoute,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(foregroundColor: Color(0xff0c1b67)),
          textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: kPrimaryColor)),
          textTheme: const TextTheme(bodyLarge: TextStyle(color: Color(0xff0c1b67)), bodyMedium: TextStyle(color: Color(0xff0c1b67))),
          elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
