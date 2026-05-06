import 'dart:async';
import 'package:ai_chat/repository/wallet/wallet_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../model/wallet/transactions.dart';
import '../../model/wallet/wallets.dart';

class WalletViewModel extends ChangeNotifier {
  final WalletRepository _repo = WalletRepository();

  WalletModel? wallet;
  StreamSubscription? _walletSub;
  StreamSubscription? _txSub;
  List<TransactionModel> transactions = [];

  bool isLoading = false;


  //  LOAD WALLET
  void loadWallet() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    //  ensure wallet exists
    await _repo.createWallet(uid);

    //  cancel old listeners
    _walletSub?.cancel();
    _txSub?.cancel();

    // WALLET
    _walletSub = _repo.getWallet(uid).listen((data) {
      print(" WALLET UPDATE: ${data?.currentBalance}");

      wallet = data;
      isLoading = false;
      notifyListeners();
    });

    //  TRANSACTIONS
    _txSub = _repo.getTransactions(uid).listen((list) {
      print(" TRANSACTIONS UPDATE: ${list.length}");

      transactions = list;
      notifyListeners();
    });
  }

  //  ADD EARNING
  Future<void> addEarning(double amount, String source) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _repo.addEarning(uid: uid, amount: amount, source: source);

  }


  @override
  void dispose() {
    _walletSub?.cancel();
    _txSub?.cancel();
    super.dispose();
  }
}