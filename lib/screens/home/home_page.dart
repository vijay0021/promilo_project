import 'package:flutter/material.dart';
import 'package:promilo_project/providers/home_provider.dart';
import 'package:promilo_project/screens/meetup/meetup_page.dart';
import 'package:promilo_project/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = const [
    SizedBox(),
    SizedBox(),
    MeetupPage(),
    SizedBox(),
    SizedBox(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Selector<HomeProvider, String>(selector: (c, p) => p.title, builder: (context, title, child) => Text(title)),
        elevation: 5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        shadowColor: Colors.white,
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Selector<HomeProvider, int>(selector: (c, p) => p.currentIndex, builder: (context, currentIndex, child) => _pages.elementAt(currentIndex)),
      ),
    );
  }
}
