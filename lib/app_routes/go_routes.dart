import 'package:drawing_on_demand/screen/common/authentication/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/pref_utils.dart';
import '../screen/client_screen/authentication/client_create_profile.dart';
import '../screen/client_screen/cart/cart_screen.dart';
import '../screen/client_screen/home/client_home.dart';
import '../screen/client_screen/home/client_home_screen.dart';
import '../screen/client_screen/home/popular_services.dart';
import '../screen/client_screen/home/top_seller.dart';
import '../screen/client_screen/job_post/create_new_job_post.dart';
import '../screen/client_screen/job_post/job_details.dart';
import '../screen/client_screen/job_post/job_post.dart';
import '../screen/common/authentication/opt_verification.dart';
import '../screen/common/orders/order_detail.dart';
import '../screen/common/orders/order_list.dart';
import '../screen/client_screen/profile/client_profile.dart';
import '../screen/client_screen/profile/client_profile_details.dart';
import '../screen/client_screen/service_details/client_order.dart';
import '../screen/common/artwork/service_details.dart';
import '../screen/common/authentication/log_in.dart';
import '../screen/common/message/chat_inbox.dart';
import '../screen/common/message/chat_list.dart';
import '../screen/common/orders/order_review.dart';
import '../screen/common/setting/language.dart';
import '../screen/common/setting/settings.dart';
import '../screen/common/welcome_screen/welcome_screen.dart';
import '../screen/seller_screen/authentication/seller_create_profile.dart';
import '../screen/seller_screen/home/seller_home.dart';
import '../screen/seller_screen/home/seller_home_screen.dart';
import '../screen/seller_screen/profile/seller_profile.dart';
import '../screen/seller_screen/profile/seller_profile_details.dart';
import '../screen/seller_screen/request/buyer_request_details.dart';
import '../screen/seller_screen/request/create_customer_offer.dart';
import '../screen/seller_screen/request/create_timeline.dart';
import '../screen/seller_screen/request/seller_buyer_request.dart';
import '../screen/seller_screen/services/create_new_service.dart';
import '../screen/seller_screen/services/create_service.dart';
import 'named_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

get rootNavigatorState => _rootNavigatorKey.currentState;
get shellNavigatorState => _shellNavigatorKey.currentState;

class AppRoutes {
  static const String defaultTag = HomeRoute.tag;

  static GoRouter routes() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: defaultTag,
      routes: [
        GoRoute(
          path: LoginRoute.tag,
          name: LoginRoute.name,
          builder: (context, state) {
            return Login(
              apiKey: state.uri.queryParameters['apiKey'],
              oobCode: state.uri.queryParameters['oobCode'],
            );
          },
          redirect: (context, state) => _authened(),
        ),
        GoRoute(
          path: WelcomeRoute.tag,
          name: WelcomeRoute.name,
          builder: (context, state) {
            return const WelcomeScreen();
          },
          routes: [
            GoRoute(
              path: RegisterRoute.tag,
              name: RegisterRoute.name,
              builder: (context, state) {
                return const SignUp();
              },
              routes: [
                GoRoute(
                  path: VerifyRoute.tag,
                  name: VerifyRoute.name,
                  builder: (context, state) {
                    return const OtpVerification();
                  },
                ),
                GoRoute(
                  path: CreateProfileRoute.tag,
                  name: CreateProfileRoute.name,
                  builder: (context, state) {
                    return PrefUtils().getRole() == 'Customer' ? const ClientCreateProfile() : const SellerCreateProfile();
                  },
                ),
              ],
            ),
          ],
        ),
        PrefUtils().getRole() == 'Artist'
            ? ShellRoute(
                navigatorKey: _shellNavigatorKey,
                builder: (context, state, child) {
                  return SellerHome(child: child);
                },
                routes: [
                  GoRoute(
                    path: MessageRoute.tag,
                    name: MessageRoute.name,
                    builder: (context, state) {
                      return const ChatScreen();
                    },
                    redirect: (context, state) => _unAuthened(),
                    routes: [
                      GoRoute(
                        path: ChatRoute.tag,
                        name: ChatRoute.name,
                        builder: (context, state) {
                          return ChatInbox(
                            receiverId: state.pathParameters['id'],
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: JobApplyRoute.tag,
                    name: JobApplyRoute.name,
                    builder: (context, state) {
                      return const SellerBuyerReq();
                    },
                    redirect: (context, state) => _unAuthened(),
                    routes: [
                      GoRoute(
                        path: JobOfferRoute.tag,
                        name: JobOfferRoute.name,
                        builder: (context, state) {
                          return CreateCustomerOffer(
                            id: state.pathParameters['jobId'],
                          );
                        },
                      ),
                      GoRoute(
                        path: JobDetailRoute.tag,
                        name: JobDetailRoute.name,
                        builder: (context, state) {
                          return BuyerRequestDetails(
                            id: state.pathParameters['jobId'],
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: OrderRoute.tag,
                    name: OrderRoute.name,
                    builder: (context, state) {
                      return const OrderList();
                    },
                    redirect: (context, state) => _unAuthened(),
                    routes: [
                      GoRoute(
                        path: OrderDetailRoute.tag,
                        name: OrderDetailRoute.name,
                        builder: (context, state) {
                          return OrderDetailScreen(
                            id: state.pathParameters['orderId'],
                          );
                        },
                        routes: [
                          GoRoute(
                            path: CreateTimelineRoute.tag,
                            name: CreateTimelineRoute.name,
                            builder: (context, state) {
                              return CreateTimeline(
                                id: state.pathParameters['requirementId'],
                              );
                            },
                          ),
                          GoRoute(
                            path: ArtworkDetailRoute.tag,
                            name: '${ArtworkDetailRoute.name} order',
                            builder: (context, state) {
                              return ServiceDetails(
                                id: state.pathParameters['artworkId'],
                              );
                            },
                          ),
                        ],
                      ),
                      GoRoute(
                        path: ReviewRoute.tag,
                        name: ReviewRoute.name,
                        builder: (context, state) {
                          return OrderReview(
                            id: state.pathParameters['id'],
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ProfileRoute.tag,
                    name: ProfileRoute.name,
                    builder: (context, state) {
                      return const SellerProfile();
                    },
                    redirect: (context, state) => _unAuthened(),
                    routes: [
                      GoRoute(
                        path: ArtistProfileDetailRoute.tag,
                        name: ArtistProfileDetailRoute.name,
                        builder: (context, state) {
                          return SellerProfileDetails(
                            id: state.pathParameters['id'],
                          );
                        },
                      ),
                      GoRoute(
                        path: SettingRoute.tag,
                        name: SettingRoute.name,
                        builder: (context, state) {
                          return const Settings();
                        },
                        routes: [
                          GoRoute(
                            path: LanguageRoute.tag,
                            name: LanguageRoute.name,
                            builder: (context, state) {
                              return const Language();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: HomeRoute.tag,
                    name: HomeRoute.name,
                    builder: (context, state) {
                      return const SellerHomeScreen();
                    },
                    redirect: (context, state) => _unAuthened(),
                    routes: [
                      GoRoute(
                        path: ArtworkRoute.tag,
                        name: ArtworkRoute.name,
                        builder: (context, state) {
                          return const CreateService();
                        },
                        routes: [
                          GoRoute(
                            path: ArtworkCreateRoute.tag,
                            name: ArtworkCreateRoute.name,
                            builder: (context, state) {
                              return const CreateNewService();
                            },
                          ),
                          GoRoute(
                            path: ArtworkDetailRoute.tag,
                            name: '${ArtworkDetailRoute.name} in',
                            builder: (context, state) {
                              return ServiceDetails(
                                id: state.pathParameters['artworkId'],
                              );
                            },
                          ),
                        ],
                      ),
                      GoRoute(
                        path: ArtworkDetailRoute.tag,
                        name: '${ArtworkDetailRoute.name} out',
                        builder: (context, state) {
                          return ServiceDetails(
                            id: state.pathParameters['artworkId'],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              )
            : ShellRoute(
                navigatorKey: _shellNavigatorKey,
                builder: (context, state, child) {
                  return ClientHome(child: child);
                },
                routes: [
                  GoRoute(
                    path: MessageRoute.tag,
                    name: MessageRoute.name,
                    builder: (context, state) {
                      return const ChatScreen();
                    },
                    redirect: (context, state) => _unAuthened(),
                    routes: [
                      GoRoute(
                        path: ChatRoute.tag,
                        name: ChatRoute.name,
                        builder: (context, state) {
                          return ChatInbox(
                            receiverId: state.pathParameters['id'],
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: JobRoute.tag,
                    name: JobRoute.name,
                    builder: (context, state) {
                      return const JobPost();
                    },
                    redirect: (context, state) => _unAuthened(),
                    routes: [
                      GoRoute(
                        path: JobCreateRoute.tag,
                        name: JobCreateRoute.name,
                        builder: (context, state) {
                          return const CreateNewJobPost();
                        },
                      ),
                      GoRoute(
                        path: JobDetailRoute.tag,
                        name: JobDetailRoute.name,
                        builder: (context, state) {
                          return JobDetails(
                            id: state.pathParameters['jobId'],
                          );
                        },
                        routes: [
                          GoRoute(
                            path: ArtistRoute.tag,
                            name: '${ArtistRoute.name} job',
                            builder: (context, state) {
                              return const TopSeller();
                            },
                            routes: [
                              GoRoute(
                                path: ArtistProfileDetailRoute.tag,
                                name: '${ArtistProfileDetailRoute.name} job',
                                builder: (context, state) {
                                  return SellerProfileDetails(
                                    id: state.pathParameters['id'],
                                  );
                                },
                                routes: [
                                  GoRoute(
                                    path: ArtworkDetailRoute.tag,
                                    name: '${ArtworkDetailRoute.name} job',
                                    builder: (context, state) {
                                      return ServiceDetails(
                                        id: state.pathParameters['artworkId'],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GoRoute(
                            path: ArtistProfileDetailRoute.tag,
                            name: '${ArtistProfileDetailRoute.name} jobOut',
                            builder: (context, state) {
                              return SellerProfileDetails(
                                id: state.pathParameters['id'],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: OrderRoute.tag,
                    name: OrderRoute.name,
                    builder: (context, state) {
                      return const OrderList();
                    },
                    redirect: (context, state) => _unAuthened(),
                    routes: [
                      GoRoute(
                        path: CheckoutRoute.tag,
                        name: '${CheckoutRoute.name} order',
                        builder: (context, state) {
                          return ClientOrder(
                            id: state.pathParameters['id'],
                          );
                        },
                      ),
                      GoRoute(
                        path: ReviewRoute.tag,
                        name: ReviewRoute.name,
                        builder: (context, state) {
                          return OrderReview(
                            id: state.pathParameters['id'],
                          );
                        },
                      ),
                      GoRoute(
                        path: OrderDetailRoute.tag,
                        name: OrderDetailRoute.name,
                        builder: (context, state) {
                          return OrderDetailScreen(
                            id: state.pathParameters['orderId'],
                          );
                        },
                        routes: [
                          GoRoute(
                            path: ArtworkDetailRoute.tag,
                            name: '${ArtworkDetailRoute.name} order',
                            builder: (context, state) {
                              return ServiceDetails(
                                id: state.pathParameters['artworkId'],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ProfileRoute.tag,
                    name: ProfileRoute.name,
                    builder: (context, state) {
                      return const ClientProfile();
                    },
                    redirect: (context, state) => _unAuthened(),
                    routes: [
                      GoRoute(
                        path: ProfileDetailRoute.tag,
                        name: ProfileDetailRoute.name,
                        builder: (context, state) {
                          return const ClientProfileDetails();
                        },
                      ),
                      GoRoute(
                        path: SettingRoute.tag,
                        name: SettingRoute.name,
                        builder: (context, state) {
                          return const Settings();
                        },
                        routes: [
                          GoRoute(
                            path: LanguageRoute.tag,
                            name: LanguageRoute.name,
                            builder: (context, state) {
                              return const Language();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: HomeRoute.tag,
                    name: HomeRoute.name,
                    builder: (context, state) {
                      return const ClientHomeScreen();
                    },
                    routes: [
                      GoRoute(
                        path: CartRoute.tag,
                        name: CartRoute.name,
                        builder: (context, state) {
                          return const CartScreen();
                        },
                        redirect: (context, state) => _unAuthened(),
                        routes: [
                          GoRoute(
                            path: CheckoutRoute.tag,
                            name: CheckoutRoute.name,
                            builder: (context, state) {
                              return ClientOrder(
                                id: state.pathParameters['id'],
                              );
                            },
                          ),
                          GoRoute(
                            path: ArtworkDetailRoute.tag,
                            name: '${ArtworkDetailRoute.name} cart',
                            builder: (context, state) {
                              return ServiceDetails(
                                id: state.pathParameters['artworkId'],
                              );
                            },
                          ),
                        ],
                      ),
                      GoRoute(
                        path: ArtworkRoute.tag,
                        name: ArtworkRoute.name,
                        builder: (context, state) {
                          return PopularServices(
                            tab: state.uri.queryParameters['tab'],
                          );
                        },
                        routes: [
                          GoRoute(
                            path: ArtworkDetailRoute.tag,
                            name: '${ArtworkDetailRoute.name} in',
                            builder: (context, state) {
                              return ServiceDetails(
                                id: state.pathParameters['artworkId'],
                              );
                            },
                          ),
                        ],
                      ),
                      GoRoute(
                        path: ArtistRoute.tag,
                        name: ArtistRoute.name,
                        builder: (context, state) {
                          return const TopSeller();
                        },
                        routes: [
                          GoRoute(
                            path: ArtistProfileDetailRoute.tag,
                            name: ArtistProfileDetailRoute.name,
                            builder: (context, state) {
                              return SellerProfileDetails(
                                id: state.pathParameters['id'],
                              );
                            },
                            routes: [
                              GoRoute(
                                path: ArtworkDetailRoute.tag,
                                name: '${ArtworkDetailRoute.name} artist',
                                builder: (context, state) {
                                  return ServiceDetails(
                                    id: state.pathParameters['artworkId'],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      GoRoute(
                        path: ArtworkDetailRoute.tag,
                        name: '${ArtworkDetailRoute.name} out',
                        builder: (context, state) {
                          return ServiceDetails(
                            id: state.pathParameters['artworkId'],
                          );
                        },
                      ),
                      GoRoute(
                        path: ArtistProfileDetailRoute.tag,
                        name: '${ArtistProfileDetailRoute.name} out',
                        builder: (context, state) {
                          return SellerProfileDetails(
                            id: state.pathParameters['id'],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ],
      onException: (context, state, router) {
        router.go(defaultTag);
      },
    );
  }

  static String? _authened() {
    return PrefUtils().getAccount() != '{}' ? HomeRoute.tag : null;
  }

  static String? _unAuthened() {
    return PrefUtils().getAccount() != '{}' ? null : LoginRoute.tag;
  }
}
