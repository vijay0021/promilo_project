import 'package:flutter/material.dart';
import 'package:promilo_project/models/popular_people_model.dart';
import 'package:promilo_project/models/top_trending_model.dart';
import 'package:promilo_project/utils/locator.dart';
import 'package:promilo_project/utils/session_manager.dart';

class HomeProvider with ChangeNotifier {
  bool isTrendLoading = false, isPeopleLoading = false;
  List<PopularPeopleModel> _list = [];
  List<TopTrendingModel> _topTrendingList = [];
  final List<String> _titles = ['Home', 'Prolet', 'Individual Meetup', 'Explore', 'Account'];
  String title = 'Individual Meetup';
  int currentIndex = 2;
  final List<String> _images = [
    'https://www.sessionlab.com/wp-content/uploads/productive-team-meetings-cover.jpg',
    'https://2456764.fs1.hubspotusercontent-eu1.net/hubfs/2456764/YoungPeopleBusinessMeeting_1200x627.jpg',
    'https://imageio.forbes.com/blogs-images/chuckcohn/files/2017/05/Internal-business-meeting.jpg?format=jpg&height=600&width=1200&fit=bounds',
    'https://static9.depositphotos.com/1037987/1188/i/450/depositphotos_11886437-stock-photo-mixed-group-in-business-meeting.jpg',
    'https://website2021-live-e3e78fbbd3cc41f2847799-7c49c59.divio-media.com/filer_public/73/52/7352020b-b331-47f5-8405-3d114bf0f28a/types-of-meetings.png',
    'https://st.depositphotos.com/1010613/1533/i/450/depositphotos_15334721-stock-photo-business-in-a-meeting.jpg',
  ];

  void setTrendLoading(bool val) {
    isTrendLoading = val;
    notifyListeners();
  }

  void setPeopleLoading(bool val) {
    isPeopleLoading = val;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
    title = _titles.elementAt(index);
    notifyListeners();
  }

  List<PopularPeopleModel> get popularPeopleList => _list;
  List<TopTrendingModel> get topTrendingList => _topTrendingList;

  void getData() async {
    setPeopleLoading(true);
    _list = [];
    await Future.delayed(const Duration(seconds: 2));
    _list.add(PopularPeopleModel(title: 'Author', meetups: 1024, image: 'assets/icon_google.png', images: _images));
    _list.add(PopularPeopleModel(title: 'Member', meetups: 103, image: 'assets/icon_fb.png', images: _images));
    _list.add(PopularPeopleModel(title: 'User 1', meetups: 1084, image: 'assets/icon_linkedin.png', images: _images));
    _list.add(PopularPeopleModel(title: 'User 2', meetups: 4024, image: 'assets/icon_whatsapp.png', images: _images));
    _list.add(PopularPeopleModel(title: 'User 3', meetups: 1624, image: 'assets/icon_insta.png', images: _images));
    setPeopleLoading(false);
  }

  void getTrendingData() async {
    setTrendLoading(true);

    _topTrendingList = [];
    await Future.delayed(const Duration(seconds: 1));
    _topTrendingList.add(TopTrendingModel(name: 'Indian Actress', fees: 999.0, images: _images..shuffle(), likes: 1025, share: 2365, rating: 3.2, duration: '20 Mins', about: ''));
    _topTrendingList.add(TopTrendingModel(name: 'Indian Actor', fees: 99.0, images: _images..shuffle(), likes: 1026, share: 365, rating: 4.8, duration: '55 Mins', about: ''));
    _topTrendingList.add(TopTrendingModel(name: 'Indian Actress', fees: 85.0, images: _images..shuffle(), likes: 102, share: 236, rating: 5.0, duration: '20 Mins', about: ''));
    _topTrendingList.add(TopTrendingModel(name: 'Indian Actress', fees: 599.0, images: _images..shuffle(), likes: 102, share: 265, rating: 5.0, duration: '20 Mins', about: ''));
    _topTrendingList.add(TopTrendingModel(name: 'Indian Actress', fees: 29.0, images: _images..shuffle(), likes: 105, share: 235, rating: 4.1, duration: '20 Mins', about: ''));
    _topTrendingList.add(TopTrendingModel(name: 'Indian Actress', fees: 24.0, images: _images..shuffle(), likes: 125, share: 365, rating: 3.0, duration: '20 Mins', about: ''));
    setTrendLoading(false);
  }


}
