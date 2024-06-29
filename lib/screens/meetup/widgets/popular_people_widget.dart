import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promilo_project/models/popular_people_model.dart';
import 'package:promilo_project/providers/home_provider.dart';
import 'package:promilo_project/utils/constants.dart';
import 'package:promilo_project/utils/toast_message.dart';
import 'package:provider/provider.dart';

class PopularPeopleWidget extends StatelessWidget {
  const PopularPeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.25;
    final width = MediaQuery.of(context).size.width;
    return Selector<HomeProvider, bool>(
        selector: (c, p) => p.isPeopleLoading,
        builder: (context, isLoading, child) {
          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : Selector<HomeProvider, List<PopularPeopleModel>>(
                  selector: (c, p) => p.popularPeopleList,
                  builder: (context, popularPeopleList, child) {
                    return SizedBox(
                      height: height,
                      child: ListView.builder(
                          itemCount: popularPeopleList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final people = popularPeopleList.elementAt(index);
                            return Container(
                              width: width * 0.8,
                              padding: EdgeInsets.all(height * 0.07),
                              margin: EdgeInsets.only(right: height * 0.07),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration:
                                              BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xff0f1646))),
                                          child: Image.asset(people.image, width: height * 0.2, height: height * 0.2)),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              people.title,
                                              style: const TextStyle(color: Color(0xff0f1646), fontSize: 18, fontWeight: FontWeight.w600),
                                            ),
                                            Text('${NumberFormat.decimalPattern('hi').format(people.meetups)} Meetups',
                                                style: TextStyle(color: Colors.grey.shade800)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      height: height * 0.3,
                                      width: double.infinity,
                                      child: Stack(
                                        children: people.images
                                            .map((e) => Positioned(
                                                  left: people.images.indexOf(e) * 40,
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: Image.network(e, height: 60, width: 60, fit: BoxFit.cover)),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          ToastMessage.showMessage('Button Pressed.', kToastInfoColor);
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                                        child: const Text('See more')),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  });
        });
  }
}
