import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/wallet/transactions.dart';
import '../../model/wallet/wallets.dart';

class WalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Get Wallet
  Stream<WalletModel?> getWallet(String uid) {
    return _firestore
        .collection('wallets')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return WalletModel.fromJson(doc.data()!);
    });
  }

  //  Create Wallet (First Time)
  Future<void> createWallet(String uid) async {
    final docRef = _firestore.collection('wallets').doc(uid);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({
        'id': uid,
        'totalEarning': 0,
        'currentBalance': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  //  Add Transaction (Earning)
  Future<void> addEarning({
    required String uid,
    required double amount,
    required String source,
  }) async {
    final walletRef = _firestore.collection('wallets').doc(uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(walletRef);

      double total = (snapshot['totalEarning'] ?? 0).toDouble();
      double balance = (snapshot['currentBalance'] ?? 0).toDouble();

      total += amount;
      balance += amount;

      transaction.update(walletRef, {
        'totalEarning': total,
        'currentBalance': balance,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final txRef = walletRef.collection('transactions').doc();

      transaction.set(txRef, {
        'amount': amount,
        'type': 'earn',
        'source': source,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  //  Get Transactions
  Stream<List<TransactionModel>> getTransactions(String uid) {
    return FirebaseFirestore.instance
        .collection('wallets')
        .doc(uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.id, doc.data()))
          .toList();
    });
  }
}