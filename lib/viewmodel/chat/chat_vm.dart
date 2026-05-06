import 'dart:async';

import 'package:ai_chat/repository/wallet/wallet_repo.dart';
import 'package:flutter/material.dart';

import '../../googleAds/adsServises.dart';
import '../../model/chat/chats.dart';
import '../../model/chat/message.dart';
import '../../repository/chat/chat_repo.dart';
import '../../ui/chat/chat_user.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repo = ChatRepository();
  final WalletRepository _walletRepo = WalletRepository();

  List<MessageModel> messages = [];

  bool isLoading = false;
  String mode = "normal"; // normal / anonymous
  bool isTyping = false;
  bool rewarded = false;

  ChatUserModel? chatUser;

  bool isLocked = false;
  int remainingSeconds = 10; // 2 min
  Timer? _timer;
  final AdService _adService = AdService();

  void startSession() {
    isLocked = false;
    remainingSeconds = 10;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds--;

      if (remainingSeconds <= 0) {
        lockChat();
      }

      notifyListeners();
    });
  }

  void lockChat() {
    isLocked = true;
    _adService.loadAd();
    _timer?.cancel();
    notifyListeners();
  }

  void unlockChat() {
    startSession();
  }

  Future<void> watchAdAndUnlock(String userId) async {
    _adService.showAd(
      onRewardEarned: () async {

        // 💰 STEP 1: SHOW REWARD ANIMATION
        rewarded = true;
        notifyListeners();

        // 💰 STEP 2: ADD COINS
        await _walletRepo.addEarning(
          uid: userId,
          amount: 10,
          source: 'Earned from chat',
        );

        // ⏳ STEP 3: LET USER SEE ANIMATION
        await Future.delayed(const Duration(seconds: 2));

        // 🔓 STEP 4: UNLOCK CHAT AFTER ANIMATION
        unlockChat();

      },

      // 🔥 ADD THIS (VERY IMPORTANT)
    );
  }

  void initChatUser(String preference) {
    chatUser = ChatUserHelper.getChatUser(preference);
    notifyListeners();
  }

  void toggleMode() {
    mode = mode == "normal" ? "anonymous" : "normal";
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    messages.add(MessageModel(text: text, isUser: true));
    notifyListeners();

    isTyping = true;
    notifyListeners();

    //  fake typing delay (human feel)
    await Future.delayed(const Duration(seconds: 2));

    isTyping = false;
    notifyListeners();


    final raw = await _repo.sendMessage(text, mode: mode);
    final response = cleanResponse(raw);

    messages.add(MessageModel(text: response, isUser: false));
    notifyListeners();
  }
  String cleanResponse(String text) {
    if (text.toLowerCase().contains("ai assistant") ||
        text.toLowerCase().contains("i am an ai") ||
        text.toLowerCase().contains("main ek ai")) {
      return "haha kya yaar 😄 aisa kyun lag raha tumhe?";
    }
    return text;
  }
}