import 'package:carousel_slider/carousel_slider.dart';
import 'package:drawing_on_demand/core/common/common_features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/utils/pref_utils.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/models/artwork.dart';
import '../../widgets/constant.dart';
import '../../widgets/review.dart';
import 'create_service.dart';

class ServiceDetails extends StatefulWidget {
  static const String tag = '${CreateService.tag}/detail';

  const ServiceDetails({Key? key}) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails>
    with TickerProviderStateMixin {
  late Future<Artwork?> artwork;

  ScrollController? _scrollController;
  TabController? tabController;
  int totalImage = 3;
  int currentIndex = 0;
  bool lastStatus = false;
  double height = 200;

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    artwork = getArtwork();
    _scrollController = ScrollController()..addListener(_scrollListener);
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    PrefUtils().clearTermId();

    super.dispose();
  }

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 0,
                backgroundColor: _isShrink ? kWhite : Colors.transparent,
                pinned: true,
                expandedHeight: 290,
                titleSpacing: 10,
                automaticallyImplyLeading: false,
                forceElevated: innerBoxIsScrolled,
                leading: _isShrink
                    ? GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: kNeutralColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kWhite,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: kNeutralColor,
                            ),
                          ),
                        ),
                      ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: SafeArea(
                    child: FutureBuilder(
                      future: artwork,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CarouselSlider.builder(
                            carouselController: _controller,
                            options: CarouselOptions(
                              height: 300,
                              aspectRatio: 18 / 18,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              reverse: false,
                              autoPlay: !_isShrink,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              scrollDirection: Axis.horizontal,
                            ),
                            itemCount: totalImage,
                            itemBuilder: (
                              BuildContext context,
                              int index,
                              int realIndex,
                            ) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    height: 300,
                                    width: context.width(),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(snapshot.data!.arts!
                                            .elementAt(index)
                                            .image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30.0),
                                ],
                              );
                            },
                          );
                        }

                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                actions: _isShrink
                    ? [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: PopupMenuButton(
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Text(
                                    'Edit',
                                    style: kTextStyle.copyWith(
                                        color: kNeutralColor),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    'Pause',
                                    style: kTextStyle.copyWith(
                                        color: kNeutralColor),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    'Delete',
                                    style: kTextStyle.copyWith(
                                        color: kNeutralColor),
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                              child: const Icon(
                                FeatherIcons.moreVertical,
                                color: kNeutralColor,
                              ),
                            ),
                          ),
                        )
                      ]
                    : [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kWhite,
                            ),
                            child: PopupMenuButton(
                              itemBuilder: (BuildContext bc) => [
                                PopupMenuItem(
                                  child: Text(
                                    'Edit',
                                    style: kTextStyle.copyWith(
                                        color: kNeutralColor),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    'Pause',
                                    style: kTextStyle.copyWith(
                                        color: kNeutralColor),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    'Delete',
                                    style: kTextStyle.copyWith(
                                        color: kNeutralColor),
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                Navigator.pushNamed(context, '$value');
                              },
                              child: const Icon(
                                FeatherIcons.moreVertical,
                                color: kNeutralColor,
                              ),
                            ),
                          ),
                        )
                      ],
                bottom: _isShrink
                    ? null
                    : PreferredSize(
                        preferredSize: const Size.fromHeight(0),
                        child: Column(
                          children: [
                            AnimatedSmoothIndicator(
                              activeIndex: currentIndex,
                              count: totalImage,
                              effect: JumpingDotEffect(
                                dotHeight: 6.0,
                                dotWidth: 6.0,
                                jumpScale: .7,
                                verticalOffset: 15,
                                activeDotColor: kPrimaryColor,
                                dotColor: kPrimaryColor.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                      ),
              ),
            ];
          },
          body: FutureBuilder(
            future: artwork,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: 1,
                        (BuildContext context, int index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15.0),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.title!,
                                      maxLines: 2,
                                      style: kTextStyle.copyWith(
                                        color: kNeutralColor,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18.0,
                                        ),
                                        const SizedBox(width: 4.0),
                                        RichText(
                                          text: TextSpan(
                                            text: getReviewPoint(
                                              snapshot.data!.artworkReviews!,
                                            ),
                                            style: kTextStyle.copyWith(
                                              color: kNeutralColor,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    ' (${snapshot.data!.artworkReviews!.length} reviews)',
                                                style: kTextStyle.copyWith(
                                                    color: kLightNeutralColor),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 18.0,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          '807',
                                          maxLines: 1,
                                          style: kTextStyle.copyWith(
                                            color: kLightNeutralColor,
                                          ),
                                        )
                                      ],
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 10,
                                      leading: CircleAvatar(
                                        radius: 22.0,
                                        backgroundImage: NetworkImage(snapshot
                                            .data!
                                            .createdByNavigation!
                                            .avatar!),
                                      ),
                                      title: Text(
                                        snapshot
                                            .data!.createdByNavigation!.name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kTextStyle.copyWith(
                                            color: kNeutralColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          text:
                                              'Artist Rank - ${snapshot.data!.createdByNavigation!.rank!.name} ',
                                          style: kTextStyle.copyWith(
                                            color: kNeutralColor,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '(View Profile)',
                                              style: kTextStyle.copyWith(
                                                color: kPrimaryColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1.0,
                                      color: kBorderColorTextField,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      'Details',
                                      maxLines: 1,
                                      style: kTextStyle.copyWith(
                                          color: kNeutralColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5.0),
                                    ReadMoreText(
                                      snapshot.data!.description!,
                                      style: kTextStyle.copyWith(
                                          color: kLightNeutralColor),
                                      trimLines: 3,
                                      colorClickableText: kPrimaryColor,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '..read more',
                                      trimExpandedText: ' read less',
                                    ),
                                    const SizedBox(height: 15.0),
                                    Text(
                                      'Price',
                                      maxLines: 1,
                                      style: kTextStyle.copyWith(
                                        color: kNeutralColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: kWhite,
                                        border: Border.all(
                                            color: kBorderColorTextField),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        children: [
                                          TabBar(
                                            unselectedLabelColor: kNeutralColor,
                                            indicatorSize:
                                                TabBarIndicatorSize.tab,
                                            indicator: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(8.0),
                                                  topLeft: Radius.circular(8.0),
                                                ),
                                                color: kPrimaryColor),
                                            controller: tabController,
                                            labelColor: kWhite,
                                            tabs: const [
                                              Tab(
                                                text: 'Category',
                                              ),
                                              Tab(
                                                text: 'Surface',
                                              ),
                                              Tab(
                                                text: 'Material',
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            height: 0,
                                            thickness: 1.0,
                                            color: kBorderColorTextField,
                                          ),
                                          SizedBox(
                                            height: 180,
                                            child: TabBarView(
                                              controller: tabController,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                        snapshot.data!.category!
                                                            .name!,
                                                        style:
                                                            kTextStyle.copyWith(
                                                                color:
                                                                    kNeutralColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      const SizedBox(
                                                          height: 15.0),
                                                      const Divider(
                                                        height: 0,
                                                        thickness: 1.0,
                                                        color:
                                                            kBorderColorTextField,
                                                      ),
                                                      const SizedBox(
                                                          height: 15.0),
                                                      Text(
                                                        snapshot.data!.category!
                                                            .description!,
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kNeutralColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                        snapshot.data!.surface!
                                                            .name!,
                                                        style:
                                                            kTextStyle.copyWith(
                                                                color:
                                                                    kNeutralColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      const SizedBox(
                                                          height: 15.0),
                                                      const Divider(
                                                        height: 0,
                                                        thickness: 1.0,
                                                        color:
                                                            kBorderColorTextField,
                                                      ),
                                                      const SizedBox(
                                                          height: 15.0),
                                                      Text(
                                                        snapshot.data!.surface!
                                                            .description!,
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kNeutralColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                        snapshot.data!.material!
                                                            .name!,
                                                        style:
                                                            kTextStyle.copyWith(
                                                                color:
                                                                    kNeutralColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      const SizedBox(
                                                          height: 15.0),
                                                      const Divider(
                                                        height: 0,
                                                        thickness: 1.0,
                                                        color:
                                                            kBorderColorTextField,
                                                      ),
                                                      const SizedBox(
                                                          height: 15.0),
                                                      Text(
                                                        snapshot.data!.material!
                                                            .description!,
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kNeutralColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Text(
                                      'Reviews',
                                      maxLines: 1,
                                      style: kTextStyle.copyWith(
                                          color: kNeutralColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 15.0),
                                    const Review(),
                                    const SizedBox(height: 15.0),
                                    const ReviewDetails(),
                                    const SizedBox(height: 10.0),
                                    const ReviewDetails2(),
                                    const SizedBox(height: 20.0),
                                    Container(
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          border: Border.all(
                                              color: kSubTitleColor)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'View all reviews',
                                            maxLines: 1,
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                          const Icon(
                                            FeatherIcons.chevronDown,
                                            color: kSubTitleColor,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<Artwork?> getArtwork() async {
    try {
      return ArtworkApi()
          .getOne(
        PrefUtils().getTermId(),
        'arts,artworkReviews,createdByNavigation(expand=rank),category,surface,material',
      )
          .then(
        (value) {
          setState(
            () {
              totalImage = value.arts!.length;
            },
          );

          return value;
        },
      );
    } catch (error) {
      Fluttertoast.showToast(msg: 'Get artwork failed');
    }

    return null;
  }
}
