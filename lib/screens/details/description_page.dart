import 'dart:math';

import 'package:flutter/material.dart';
import 'package:promilo_project/models/top_trending_model.dart';
import 'package:promilo_project/utils/constants.dart';
import 'package:promilo_project/widgets/bottom_nav.dart';

class DescriptionPage extends StatefulWidget {
  static const String routeName = '/description';

  const DescriptionPage({super.key, required this.data});

  final TopTrendingModel data;

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  late TopTrendingModel model;

  @override
  void initState() {
    model = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Description'), elevation: 5, backgroundColor: Colors.white, automaticallyImplyLeading: true, shadowColor: Colors.white),
      bottomNavigationBar: const BottomNavigationBarWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15.0),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Image.asset('assets/icon_google.png'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.save_as_outlined)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.heart_broken_outlined)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.access_alarm)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  const Icon(Icons.save_as_outlined, color: kPrimaryColor),
                  const SizedBox(width: 5.0),
                  Text(model.share.toString()),
                  const SizedBox(width: 10.0),
                  const Icon(Icons.heart_broken_outlined, color: kPrimaryColor),
                  const SizedBox(width: 5.0),
                  Text(model.likes.toString()),
                  const SizedBox(width: 10.0),
                  _RatingWidget(rating: model.rating),
                  const SizedBox(width: 10.0),
                  Text(model.rating.toString(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kPrimaryColor)),
                ],
              ),
              const SizedBox(height: 15.0),
              const Text('Actor Name', style: TextStyle(color: Color(0xff0f1646), fontSize: 18, fontWeight: FontWeight.w600)),
              Text(model.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
              const SizedBox(height: 15.0),
              _ItemWidget(icon: Icons.wallet, value: 'Duration ${model.duration}'),
              const SizedBox(height: 15.0),
              _ItemWidget(icon: Icons.alarm, value: 'Total Average Fees \u{20B9} ${model.fees.toInt()}'),
              const SizedBox(height: 15.0),
              const Text('About', style: TextStyle(color: Color(0xff0f1646), fontSize: 18, fontWeight: FontWeight.w600)),
              Text(model.about ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
              Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('See More')))
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: List.generate(5, (index) {
          double opacity = 1.0;
          if (rating.floor() == index) {
            opacity = ((rating % 1) * pow(2, 0));
          }
          return Icon(Icons.star, color: index >= rating.ceil() ? Colors.white : Colors.cyan.withOpacity(opacity));
        }),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({super.key, required this.icon, required this.value});

  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
      ],
    );
  }
}
