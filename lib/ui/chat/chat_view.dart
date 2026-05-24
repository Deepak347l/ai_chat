import 'package:ai_chat/core/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodel/chat/chat_vm.dart';
import '../../viewmodel/user/users_vm.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final vm = context.read<ChatViewModel>();
      // vm.startSession(); //  SAFE NOW
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Column(
            children: [

              //  HUMAN STYLE NAVBAR
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 16.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary,
                      child: vm.chatUser?.avatar != null ? Text(vm.chatUser!.avatar ?? ""):Icon(Icons.person, color: Colors.white),
                    ),
                    SizedBox(width: 12.w),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.chatUser?.name ?? "",
                          style: AppTextStyles.h3,
                        ),
                        Text(
                          vm.isTyping ? "Typing..." : "Online",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),


                    SizedBox(width: 12.w),
                    Icon(Icons.refresh, color: AppColors.textPrimaryLight),
                  ],
                ),
              ),

              Column(
                children: [

                  // 🔥 SESSION TIMER BAR
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [

                        //  TIME TEXT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Session Time",
                              style: AppTextStyles.labelMedium,
                            ),
                            Text(
                              "${vm.remainingSeconds ~/ 60}:${(vm.remainingSeconds % 60).toString().padLeft(2, '0')}",
                              style: AppTextStyles.labelMedium,
                            ),
                          ],
                        ),

                        SizedBox(height: 6),

                        //  PROGRESS BAR
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: vm.remainingSeconds / 180,
                            minHeight: 6,
                            backgroundColor: AppColors.borderLight,
                            valueColor: AlwaysStoppedAnimation(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 💬 CHAT LIST
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(AppSpacing.md),
                  itemCount: vm.messages.length,
                  itemBuilder: (context, index) {
                    final msg = vm.messages[index];
                    final avtar = vm.chatUser?.avatar;
                    return _messageBubble(msg,avtar);
                  },
                ),
              ),

              // ✨ INPUT
              vm.isLocked ?
        Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

        Icon(Icons.lock, size: 50, color: Colors.white),
        SizedBox(height: 12),

        Text(
        "Session Ended",
        style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),

        SizedBox(height: 8),

        Text(
        "Watch an ad to continue chatting",
        style: AppTextStyles.bodySmall.copyWith(
        color: Colors.white70,
        ),
        ),

        SizedBox(height: 20),

        ElevatedButton(
        onPressed: () {
        vm.watchAdAndUnlock("XafpTBkYx1ey6ASF3CJKMNAe5wP2");
        if (vm.rewarded){
          print(vm.rewarded);
          showRewardDialog(context, 10);
        }
        },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 6,
            ),
          ),
        child: Text("Continue Watching"),
        )
        ],
        )
        )
        ):
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                color: AppColors.surfaceLight,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child:TextField(
                          controller: controller,

                          decoration: InputDecoration(
                            hintText: "Message...",
                            border: InputBorder.none,


                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.textSecondaryDark,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),

                    GestureDetector(
                      onTap: () {
                        vm.sendMessage(controller.text);
                        vm.startSession();
                        controller.clear();
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // 🔥 HUMAN MESSAGE BUBBLE
  Widget _messageBubble(msg, String? avtar) {
    final isUser = msg.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [

          // 👤 OTHER USER AVATAR
          if (!isUser)
            Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary,
                child: avtar != null ? Text(avtar ?? ""):Icon(Icons.person, color: Colors.white),
              ),
            ),

          // 💬 BUBBLE
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: isUser
                      ? Radius.circular(16.r)
                      : Radius.circular(4.r),
                  bottomRight: isUser
                      ? Radius.circular(4.r)
                      : Radius.circular(16.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isUser
                          ? Colors.white
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // ⏱ TIME
                  Text(
                    formatTime(DateTime.now()),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isUser
                          ? Colors.white70
                          : AppColors.textSecondaryLight,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  void showRewardDialog(BuildContext context, int coins) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 400),
            tween: Tween(begin: 0.8, end: 1.0),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // 💰 ICON
                      Icon(Icons.monetization_on,
                          size: 50, color: Colors.amber),

                      SizedBox(height: 12),

                      // 🎉 TEXT
                      Text(
                        "+$coins Coins!",
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Reward added to your wallet",
                        style: AppTextStyles.bodySmall,
                      ),

                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Awesome! 🚀"),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}