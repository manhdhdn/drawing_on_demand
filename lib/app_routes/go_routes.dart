import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/utils/pref_utils.dart';
import '../screen/client_screen/cart/cart_screen.dart';
import '../screen/client_screen/home/client_home.dart';
import '../screen/client_screen/home/client_home_screen.dart';
import '../screen/client_screen/home/popular_services.dart';
import '../screen/client_screen/job_post/job_details.dart';
import '../screen/client_screen/job_post/job_post.dart';
import '../screen/client_screen/orders/client_orders.dart';
import '../screen/client_screen/profile/client_profile.dart';
import '../screen/client_screen/profile/client_profile_details.dart';
import '../screen/common/artwork/service_details.dart';
import '../screen/common/authentication/log_in.dart';
import '../screen/common/message/chat_inbox.dart';
import '../screen/common/message/chat_list.dart';
import '../screen/common/message/provider/data_provider.dart';
import '../screen/common/setting/language.dart';
import '../screen/common/setting/settings.dart';
import 'named_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

get rootNavigatorState => _rootNavigatorKey.currentState;
get shellNavigatorState => _shellNavigatorKey.currentState;

class AppRoutes {
  static const String defaultTag = HomeRoute.tag;

  static final GoRouter routes = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: defaultTag,
    routes: [
      GoRoute(
        path: LoginRoute.tag,
        name: LoginRoute.name,
        builder: (context, state) {
          return const Login();
        },
        redirect: (context, state) => _authened(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ClientHome(child: child);
        },
        routes: [
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
                        id: state.pathParameters['id'],
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
                    id: state.pathParameters['id'],
                  );
                },
              ),
            ],
          ),
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
                    var extra = Provider.of<ChatProvider>(context).user;

                    return ChatInbox(
                      img: extra.image,
                      name: extra.name,
                      receiverId: state.pathParameters['id'],
                    );
                  }),
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
                path: JobDetailRoute.tag,
                name: '${JobDetailRoute.name} in',
                builder: (context, state) {
                  return JobDetails(
                    id: state.pathParameters['id'],
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: OrderRoute.tag,
            name: OrderRoute.name,
            builder: (context, state) {
              return const ClientOrderList();
            },
            redirect: (context, state) => _unAuthened(),
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
        ],
      )
    ],
    onException: (context, state, router) {
      router.go(defaultTag);
    },
  );

  static String? _authened() {
    return PrefUtils().getToken() != '{}' ? HomeRoute.tag : null;
  }

  static String? _unAuthened() {
    return PrefUtils().getToken() != '{}' ? null : LoginRoute.tag;
  }
}
