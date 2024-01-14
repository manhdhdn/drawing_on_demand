import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../widgets/constant.dart';
import '../../widgets/nothing_yet.dart';
import 'function/chat_function.dart';
import 'model/chat_model.dart';
import 'provider/data_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    ChatFunction.updateUserData({
      'image': jsonDecode(PrefUtils().getAccount())['Avatar'],
      'name': jsonDecode(PrefUtils().getAccount())['Name'],
      'isOnline': true,
    });

    Provider.of<ChatProvider>(context, listen: false).getChatedUsers();
  }

  @override
  void dispose() {
    ChatFunction.updateUserData({
      'lastActive': DateTime.now(),
      'isOnline': false,
    });

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Message',
      color: kPrimaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kDarkWhite,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: kNeutralColor),
            backgroundColor: kDarkWhite,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              'Message',
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              height: context.height(),
              width: context.width(),
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Consumer<ChatProvider>(
                  builder: (context, value, child) => value.users.isNotEmpty
                      ? Column(
                          children: value.users
                              .map((user) => Column(
                                    children: [
                                      const SizedBox(height: 10.0),
                                      SettingItemWidget(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        title: user.name.validate(),
                                        subTitle: user.lastMessage.validate(),
                                        subTitleTextStyle: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: kTextStyle.fontFamily,
                                          fontWeight: user.isSeen.validate() ? FontWeight.normal : FontWeight.w700,
                                        ),
                                        leading: Image.network(user.image.validate(), height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(25),
                                        trailing: Column(
                                          children: [
                                            Text(
                                              timeago.format(user.lastActive!),
                                              style: secondaryTextStyle(),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          onChat(user);
                                        },
                                      ),
                                      const Divider(
                                        thickness: 1.0,
                                        color: kBorderColorTextField,
                                        height: 0,
                                      ),
                                    ],
                                  ))
                              .toList(),
                        )
                      : const NothingYet(visible: true),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onChat(UserModel user) {
    context.goNamed(
      ChatRoute.name,
      pathParameters: {'id': user.uid.validate()},
    );
  }
}
