import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  RewardedAd? _rewardedAd;

  void loadAd() {
    print("loading ad...");
    RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => print(error),
      ),
    );
  }

  void showAd({
    required Function onRewardEarned,
  }) {
    if (_rewardedAd == null) return;

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onRewardEarned();
      },
    );

    _rewardedAd = null;
    loadAd(); // preload next
  }
}