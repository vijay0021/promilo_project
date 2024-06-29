import 'package:flutter/material.dart';
import 'package:promilo_project/models/top_trending_model.dart';
import 'package:promilo_project/providers/home_provider.dart';
import 'package:promilo_project/screens/details/description_page.dart';
import 'package:provider/provider.dart';

class TopTrendingWidget extends StatelessWidget {
  const TopTrendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Selector<HomeProvider, bool>(
        selector: (c, p) => p.isTrendLoading,
        builder: (context, isLoading, child) {
          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : Selector<HomeProvider, List<TopTrendingModel>>(
                  selector: (c, p) => p.topTrendingList,
                  builder: (context, topTrendingList, child) {
                    return SizedBox(
                      height: width * 0.5,
                      child: ListView.builder(
                          itemCount: topTrendingList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final trend = topTrendingList.elementAt(index);
                            return Container(
                              height: width * 0.5,
                              width: width * 0.5,
                              margin: const EdgeInsets.only(right: 15.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, DescriptionPage.routeName, arguments: trend);
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: Stack(
                                    children: [
                                      SizedBox(width: double.infinity, height: double.infinity, child: Image.network(trend.images.first, fit: BoxFit.cover)),
                                      CustomPaint(
                                        painter: _Paint(),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                bottom: 5,
                                                right: 5,
                                                child: Text(
                                                  (index + 1).toString().padLeft(2, '0'),
                                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(),
                                                  textAlign: TextAlign.end,
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  });
        });
  }
}

class _Paint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {


    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width, size.height * 0.60);
    path.quadraticBezierTo(size.width, size.height * 0.8, size.width * 0.85, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.75, size.width * 0.75, size.height * 0.85);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
