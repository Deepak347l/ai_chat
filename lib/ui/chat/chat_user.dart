import 'dart:math';

import 'fake_chat.dart';
import '../../model/chat/chats.dart';

class ChatUserHelper {
  static ChatUserModel getChatUser(String preference) {
    final random = Random();

    if (preference == "female") {
      final list = FakeUsers.girls;
      return list[random.nextInt(list.length)];
    } else {
      final list = FakeUsers.boys;
      return list[random.nextInt(list.length)];
    }
  }
}