import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'constant.dart';

class Review extends StatefulWidget {
  final String? rating;
  final int? total;
  final int? five;
  final int? four;
  final int? three;
  final int? two;
  final int? one;

  const Review({
    Key? key,
    this.rating = '4.9',
    this.total = 100,
    this.five = 90,
    this.four = 9,
    this.three = 2,
    this.two = 1,
    this.one = 0,
  }) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      border: Border.all(width: 2, color: kPrimaryColor),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.rating}',
                        style: kTextStyle.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total ${widget.total} reviews',
                    style: kTextStyle.copyWith(
                      color: kNeutralColor,
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        LinearPercentIndicator(
                          width: 130,
                          lineHeight: 8.0,
                          percent: widget.five! / (widget.total! + 0.1),
                          progressColor: kPrimaryColor,
                          backgroundColor: kDarkWhite,
                          barRadius: const Radius.circular(15),
                        ),
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text('${widget.five}'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        LinearPercentIndicator(
                          width: 130,
                          lineHeight: 8.0,
                          percent: widget.four! / (widget.total! + 0.1),
                          progressColor: kPrimaryColor,
                          backgroundColor: kDarkWhite,
                          barRadius: const Radius.circular(15),
                        ),
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text('${widget.four}'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        LinearPercentIndicator(
                          width: 130,
                          lineHeight: 8.0,
                          percent: widget.three! / (widget.total! + 0.1),
                          progressColor: kPrimaryColor,
                          backgroundColor: kDarkWhite,
                          barRadius: const Radius.circular(15),
                        ),
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text('${widget.three}'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        LinearPercentIndicator(
                          width: 130,
                          lineHeight: 8.0,
                          percent: widget.two! / (widget.total! + 0.1),
                          progressColor: kPrimaryColor,
                          backgroundColor: kDarkWhite,
                          barRadius: const Radius.circular(15),
                        ),
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text('${widget.two}'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: ratingBarColor),
                        LinearPercentIndicator(
                          width: 130,
                          lineHeight: 8.0,
                          percent: widget.one! / (widget.total! + 0.1),
                          progressColor: kPrimaryColor,
                          backgroundColor: kDarkWhite,
                          barRadius: const Radius.circular(15),
                        ),
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: Text('${widget.one}'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewDetails extends StatelessWidget {
  final String? avatar;
  final String? name;
  final int? star;
  final String? date;
  final String? comment;

  const ReviewDetails({
    Key? key,
    this.avatar =
        'https://firebasestorage.googleapis.com/v0/b/drawing-on-demand.appspot.com/o/images%2Fdrawing_on_demand.jpg?alt=media&token=c1801df1-f2d7-485d-8715-9e7aed83c3cf',
    this.name = 'Truc Nhu',
    this.star = 5,
    this.date = '03-11-2023',
    this.comment =
        'Nibh nibh quis dolor in. Etiam cras nisi, turpis quisque diam',
  }) : super(key: key);

  ListView getStars() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: star,
      itemBuilder: (context, index) {
        return const Icon(
          Icons.star,
          size: 18.0,
          color: ratingBarColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: context.width(),
      decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: kBorderColorTextField),
          boxShadow: const [
            BoxShadow(
                color: kBorderColorTextField,
                spreadRadius: 1.0,
                blurRadius: 5.0,
                offset: Offset(0, 3))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(avatar!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    style: kTextStyle.copyWith(
                        color: kNeutralColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  SizedBox(
                    height: 18.0,
                    width: 100.0,
                    child: getStars(),
                  )
                ],
              ),
              const Spacer(),
              Text(
                date!,
                style: kTextStyle.copyWith(color: kLightNeutralColor),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            comment!,
            style: kTextStyle.copyWith(color: kSubTitleColor),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Review',
            style: kTextStyle.copyWith(color: kLightNeutralColor),
          ),
        ],
      ),
    );
  }
}

class ReviewDetails2 extends StatelessWidget {
  const ReviewDetails2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: context.width(),
      decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: kBorderColorTextField),
          boxShadow: const [
            BoxShadow(
                color: kBorderColorTextField,
                spreadRadius: 1.0,
                blurRadius: 5.0,
                offset: Offset(0, 3))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40.0,
                width: 40.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('images/profilepic.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abdul Korim',
                    style: kTextStyle.copyWith(
                        color: kNeutralColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        IconlyBold.star,
                        color: ratingBarColor,
                        size: 18.0,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        '4.9',
                        style: kTextStyle.copyWith(color: kNeutralColor),
                      ),
                      const SizedBox(width: 120),
                      Text(
                        '5, June 2023',
                        style: kTextStyle.copyWith(color: kLightNeutralColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            'Nibh nibh quis dolor in. Etiam cras nisi, turpis quisque diam',
            style: kTextStyle.copyWith(color: kSubTitleColor),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: kBorderColorTextField),
                  image: const DecorationImage(
                      image: AssetImage('images/pic2.png'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10.0),
              Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: kBorderColorTextField),
                  image: const DecorationImage(
                      image: AssetImage('images/pic2.png'), fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            'Review',
            style: kTextStyle.copyWith(color: kLightNeutralColor),
          ),
        ],
      ),
    );
  }
}
