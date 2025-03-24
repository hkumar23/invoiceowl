import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ID
      adUnitId: 'ca-app-pub-7181037697962753/8347049835',
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? Container(
            alignment: Alignment.center,
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd),
          )
        : Container(
            height: 70,
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 38, 38, 39),
            child: const Text("Advertisement"),
          );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
