import 'package:app_core/app_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneshout/common/consts/consts.dart';
import 'package:oneshout/common/widgets/native_dialog.dart';
import 'package:oneshout/modules/iap/iap.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Paywall extends StatefulWidget {
  const Paywall({super.key, this.offering});
  final Offering? offering;

  @override
  PaywallState createState() => PaywallState();
}

class PaywallState extends State<Paywall> {
  Offerings? offerings;
  Offering? offering;

  bool _isLoading = false;
  bool _purchaseLoading = false;

  @override
  void initState() {
    super.initState();
    loadOfferings();
  }

  Future<void> loadOfferings() async {
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => ShowDialogToDismiss(
          title: 'Error',
          content: e.message ?? '-',
          buttonText: 'OK',
        ),
      );
    }

    setState(() {
      _isLoading = false;
      offerings = offerings;
      offering = offerings!.current;
    });
  }

  Future<void> perfomMagic() async {
    setState(() {
      _isLoading = true;
    });

    final customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]!.isActive == true) {
      // iapAppData.currentData = WeatherData.generateData();
      notify.toast(
        'Entitlement: ${customerInfo.entitlements.all[entitlementID]!.identifier}',
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
            title: 'Error',
            content: e.message ?? '-',
            buttonText: 'OK',
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          // backgroundColor: kColorBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Paywall(
                  offering: offerings!.current!,
                );
              },
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One Shout Subscription'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.all(Insets.xl),
          child: _purchaseLoading?Center(child: CircularProgressIndicator()):Wrap(
            children: <Widget>[
              VSpace.lg,
              if (_isLoading)
                Center(child: Center(child: const CircularProgressIndicator()))
              else if (offerings == null || offerings!.current == null)
                //const Text('Could not load Offerings!')
                Center(child: Center(child: const CircularProgressIndicator()))
              else
                ListView.separated(
                  itemCount: offering!.availablePackages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final myProductList = offering!.availablePackages;
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          setState(() {_purchaseLoading = true;});
                          final nv = Navigator.of(context);
                          try {
                            final customerInfo =
                                await Purchases.purchasePackage(
                              myProductList[index],
                            );
                            iapAppData.entitlementIsActive = customerInfo
                                .entitlements.all[entitlementID]!.isActive;
                          } catch (e) {
                            setState(() {_purchaseLoading = false;});
                            print(e);
                          }

                          if (mounted) setState(() {});
                          nv.pop();
                        },
                        title: Text(
                          myProductList[index].storeProduct.title,
                          // style: kTitleTextStyle,
                        ),
                        subtitle: Text(
                          myProductList[index].storeProduct.description,
                          // style: kDescriptionTextStyle.copyWith(
                          //     fontSize: kFontSizeSuperSmall),
                        ),
                        trailing: ColoredBox(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              myProductList[index].storeProduct.priceString,
                              style: const TextStyle(color: Colors.white),
                              // style: kTitleTextStyle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(height: 20);
                  },
                ),
              Padding(
                padding:
                    EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontFamily: 'Poppins',
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'By clicking a subscription plan, you agree to our ',
                          ),
                          TextSpan(
                            text: 'Terms of Use and Privacy Policy',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(
                                  Uri.parse(
                                    //'https://ebsinafrica.com/terms-of-subscription/',
                                      'https://sites.google.com/view/one-shout/eula',
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
