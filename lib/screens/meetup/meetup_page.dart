import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:promilo_project/models/top_model.dart';
import 'package:promilo_project/providers/home_provider.dart';
import 'package:promilo_project/screens/meetup/widgets/popular_people_widget.dart';
import 'package:promilo_project/screens/meetup/widgets/top_trending_widget.dart';
import 'package:provider/provider.dart';

class MeetupPage extends StatefulWidget {
  const MeetupPage({super.key});

  @override
  State<MeetupPage> createState() => _MeetupPageState();
}

class _MeetupPageState extends State<MeetupPage> {
  int _activeIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _searchController = TextEditingController();
  final List<TopModel> _pages = [
    TopModel(
        title: 'Popular Meetups in India',
        image: 'https://imageio.forbes.com/blogs-images/chuckcohn/files/2017/05/Internal-business-meeting.jpg?format=jpg&height=600&width=1200&fit=bounds'),
    TopModel(title: 'Trending Meetups in India', image: 'https://www.sessionlab.com/wp-content/uploads/productive-team-meetings-cover.jpg'),
    TopModel(title: 'Top Trending in India', image: 'https://2456764.fs1.hubspotusercontent-eu1.net/hubfs/2456764/YoungPeopleBusinessMeeting_1200x627.jpg')
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      context.read<HomeProvider>().getData();
      context.read<HomeProvider>().getTrendingData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15.0),
          _SearchWidget(controller: _searchController),
          const SizedBox(height: 10.0),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _activeIndex = index),
                itemBuilder: (context, index) => AnimatedSwitcher(
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    duration: const Duration(milliseconds: 600),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Stack(
                        children: [
                          SizedBox(width: double.infinity, child: Image.network(_pages.elementAt(index).image, fit: BoxFit.cover)),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.black45, Colors.black26, Colors.transparent, Colors.transparent]),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          Positioned(
                              left: 10,
                              bottom: 10,
                              child: Text(_pages.elementAt(index).title,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w500)))
                        ],
                      ),
                    ))),
          ),
          DotsIndicator(
            dotsCount: _pages.length,
            position: _activeIndex.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(9.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
          const SizedBox(height: 15.0),
          Text('Trending Popular People', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10.0),
          const PopularPeopleWidget(),
          const SizedBox(height: 15.0),
          Text('Top Trending Meetups', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10.0),
          const TopTrendingWidget(),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.mic),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
      ),
    );
  }
}


