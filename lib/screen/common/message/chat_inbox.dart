import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../widgets/constant.dart';
import '../../widgets/responsive.dart';
import '../popUp/popup_1.dart';
import 'empty_widget.dart';
import 'function/chat_function.dart';
import 'provider/data_provider.dart';

class ChatInbox extends StatefulWidget {
  final dynamic receiverId;

  const ChatInbox({
    Key? key,
    this.receiverId,
  }) : super(key: key);

  @override
  State<ChatInbox> createState() => _ChatInboxState();
}

class _ChatInboxState extends State<ChatInbox> {
  void showBlockPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              insetPadding: DodResponsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: context.width() / 2.7) : const EdgeInsets.symmetric(horizontal: 40.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const BlockingReasonPopUp(),
            );
          },
        );
      },
    );
  }

  void showAddFilePopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              insetPadding: DodResponsive.isDesktop(context) ? EdgeInsets.symmetric(horizontal: context.width() / 2.7) : const EdgeInsets.symmetric(horizontal: 40.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const ImportDocumentPopUp(),
            );
          },
        );
      },
    );
  }

  TextEditingController messageController = TextEditingController();
  FocusNode msgFocus = FocusNode();

  get kTitleColor => null;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    ChatFunction.updateChatUser(
      senderId: jsonDecode(PrefUtils().getAccount())['Id'],
      receiverId: widget.receiverId,
    );

    Provider.of<ChatProvider>(context, listen: false)
      ..getMessages(widget.receiverId)
      ..getUser(widget.receiverId);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Chat',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: kDarkWhite,
          leadingWidth: 24,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Consumer<ChatProvider>(
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(value.user.image ?? defaultImage),
                  ),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.user.name ?? 'Drawing On Demand',
                        style: boldTextStyle(),
                      ),
                      value.user.isOnline!
                          ? Text('Online', style: secondaryTextStyle(color: kPrimaryColor))
                          : Text(
                              'Offline',
                              style: secondaryTextStyle(),
                            ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
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
                      onTap: () => showBlockPopUp(),
                      child: Text(
                        AppLocalizations.of(context)!.block,
                        style: kTextStyle.copyWith(color: kNeutralColor),
                      ),
                    ),
                    PopupMenuItem(
                      child: Text(
                        AppLocalizations.of(context)!.report,
                        style: kTextStyle.copyWith(color: kNeutralColor),
                      ),
                    ),
                  ],
                  onSelected: (value) {},
                  child: const Icon(
                    FeatherIcons.moreVertical,
                    color: kNeutralColor,
                  ),
                ),
              ),
            )
          ],
          shadowColor: kNeutralColor.withOpacity(0.5),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            height: context.height(),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: SingleChildScrollView(
              controller: Provider.of<ChatProvider>(context, listen: false).scrollController,
              physics: const BouncingScrollPhysics(),
              child: Consumer<ChatProvider>(
                builder: (context, value, child) => value.inboxDatas.isNotEmpty
                    ? Column(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: value.inboxDatas.length,
                            itemBuilder: (context, index) {
                              if (value.inboxDatas[index].id == 0) {
                                return Column(
                                  children: [
                                    8.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: DodResponsive.isDesktop(context) ? context.width() * 0.6 * 0.7 : context.width() * 0.6,
                                          ),
                                          decoration: boxDecorationWithRoundedCorners(
                                            backgroundColor: kPrimaryColor,
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              bottomLeft: Radius.circular(20.0),
                                              bottomRight: Radius.circular(0.0),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                (value.inboxDatas[index].message).validate(),
                                                style: primaryTextStyle(
                                                  color: white,
                                                ),
                                              ),
                                              Text(
                                                timeago.format(value.inboxDatas[index].sentTime!),
                                                style: secondaryTextStyle(
                                                  size: 9,
                                                  color: kNeutralColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        8.width,
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            jsonDecode(PrefUtils().getAccount())['Avatar'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    8.height,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Consumer<ChatProvider>(
                                          builder: (context, value, child) {
                                            return CircleAvatar(
                                              radius: 20,
                                              backgroundImage: NetworkImage(value.user.image ?? defaultImage),
                                            );
                                          },
                                        ),
                                        8.width,
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: DodResponsive.isDesktop(context) ? context.width() * 0.6 * 0.7 : context.width() * 0.6,
                                          ),
                                          decoration: boxDecorationWithRoundedCorners(
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(20.0),
                                            ),
                                            backgroundColor: kDarkWhite,
                                          ),
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (value.inboxDatas[index].message).validate(),
                                                style: primaryTextStyle(),
                                              ),
                                              Text(
                                                timeago.format(value.inboxDatas[index].sentTime!),
                                                style: secondaryTextStyle(
                                                  size: 9,
                                                  color: kNeutralColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(height: context.height() * 0.3),
                          EmptyWidget(
                            icon: Icons.waving_hand,
                            text: AppLocalizations.of(context)!.sayHello,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: MediaQuery.of(context).viewInsets,
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor,
            borderRadius: radius(0.0),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showAddFilePopUp();
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: kDarkWhite),
                        child: const Icon(
                          FeatherIcons.link,
                          color: kNeutralColor,
                        )),
                  ),
                ),
                Expanded(
                  flex: DodResponsive.isDesktop(context) ? 10 : 5,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: kDarkWhite,
                    ),
                    child: AppTextField(
                      controller: messageController,
                      textFieldType: TextFieldType.OTHER,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      focus: msgFocus,
                      maxLines: 7,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.mess,
                        hintStyle: secondaryTextStyle(size: 16),
                        suffixIcon: const Icon(
                          Icons.send_outlined,
                          size: 24,
                          color: kPrimaryColor,
                        ).paddingAll(4.0).onTap(
                          () {
                            onSend();
                          },
                        ),
                      ),
                      onFieldSubmitted: (p0) {
                        Future.delayed(
                          10.milliseconds,
                          () {
                            FocusScope.of(context).requestFocus(msgFocus);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addMessage(String message) async {
    await ChatFunction.addTextMessage(
      content: message,
      senderId: jsonDecode(PrefUtils().getAccount())['Id'],
      receiverId: widget.receiverId,
    );
  }

  void onSend() {
    String message = messageController.text.trim();
    messageController.clear();

    if (message.isNotEmpty) {
      addMessage(message);
    }
  }
}
