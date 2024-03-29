// // ignore_for_file: lines_longer_than_80_chars

// import 'dart:async';
// import 'dart:io';

// import 'package:app_core/app_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// //import for InAppPurchaseAndroidPlatformAddition
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// //import for BillingResponse
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:oneshout/bootstrap.dart';
// import 'package:oneshout/modules/iap/consumable_store.dart';

// class IAPPage extends StatefulWidget {
//   const IAPPage({super.key});

//   @override
//   IAPPageState createState() => IAPPageState();
// }

// class IAPPageState extends State<IAPPage> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = [];
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];
//   List<String> _consumables = [];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String? _queryProductError;

//   @override
//   void initState() {
//     final purchaseUpdated = _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen(
//       _listenToPurchaseUpdated,
//       onDone: () {
//         _subscription.cancel();
//       },
//       onError: (error) {
//         _subscription.resume();
//       },
//     );
//     initStoreInfo();
//     super.initState();
//   }

//   Future<void> payar() async {
//     Offerings offerings;
//     try {
//       offerings = await Purchases.getOfferings();
//       print(offerings);
//     } on PlatformException catch (e) {
//       notify.snack(e.message!);
//     }
//   }

//   Future<void> initStoreInfo() async {
//     final isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = [];
//         _purchases = [];
//         _notFoundIds = [];
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     if (Platform.isIOS) {
//       final iosPlatformAddition = _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//     }

//     final productDetailResponse =
//         await _inAppPurchase.queryProductDetails(kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = productDetailResponse.error!.message;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     if (productDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     final consumables = await ConsumableStore.load();

//     setState(() {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = consumables;
//       _purchasePending = false;
//       _loading = false;
//     });
//   }

//   @override
//   void dispose() {
//     if (Platform.isIOS) {
//       _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>()
//           .setDelegate(null);
//     }
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final stack = <Widget>[];
//     if (_queryProductError == null) {
//       stack.add(
//         ListView(
//           children: [
//             _buildConnectionCheckTile(),
//             _buildProductList(),
//             _buildConsumableBox(),
//             // _buildRestoreButton(),
//           ],
//         ),
//       );
//     } else {
//       stack.add(
//         Center(
//           child: Text(_queryProductError!),
//         ),
//       );
//     }
//     if (_purchasePending) {
//       stack.add(
//         const Stack(
//           children: [
//             Opacity(
//               opacity: 0.3,
//               child: ModalBarrier(dismissible: false, color: Colors.grey),
//             ),
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//           ],
//         ),
//       );
//     }

//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('IAP Example'),
//         ),
//         body: Stack(
//           children: stack,
//         ),
//       ),
//     );
//   }

//   Card _buildConnectionCheckTile() {
//     if (_loading) {
//       return const Card(child: ListTile(title: Text('Trying to connect...')));
//     }

//     final Widget storeHeader = ListTile(
//       leading: Icon(
//         _isAvailable ? Icons.check : Icons.block,
//         color:
//             _isAvailable ? Colors.green : ThemeData.light().colorScheme.error,
//       ),
//       title: Text(
//         'The store is ${_isAvailable ? 'available' : 'unavailable'}.',
//       ),
//     );

//     final children = <Widget>[storeHeader];

//     if (!_isAvailable) {
//       children.addAll([
//         const Divider(),
//         ListTile(
//           title: Text(
//             'Not connected',
//             style: TextStyle(color: ThemeData.light().colorScheme.error),
//           ),
//           subtitle: const Text(
//             'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.',
//           ),
//         ),
//       ]);
//     }

//     return Card(child: Column(children: children));
//   }

//   Card _buildProductList() {
//     if (_loading) {
//       return const Card(
//         child: ListTile(
//           leading: CircularProgressIndicator(),
//           title: Text('Fetching products...'),
//         ),
//       );
//     }

//     if (!_isAvailable) {
//       return const Card();
//     }

//     const productHeader = ListTile(title: Text('Products for Sale'));
//     final productList = <ListTile>[];

//     if (_notFoundIds.isNotEmpty) {
//       productList.add(
//         ListTile(
//           title: Text(
//             '[${_notFoundIds.join(", ")}] not found',
//             style: TextStyle(color: ThemeData.light().colorScheme.error),
//           ),
//           subtitle: const Text(
//             'This app needs special configuration to run. Please see example/README.md for instructions.',
//           ),
//         ),
//       );
//     }

//     // This loading previous purchases code is just a demo. Please do not use this as it is.
//     // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//     // We recommend that you use your own server to verify the purchase data.
//     final purchases = Map<String, PurchaseDetails>.fromEntries(
//       _purchases.map((PurchaseDetails purchase) {
//         if (purchase.pendingCompletePurchase) {
//           _inAppPurchase.completePurchase(purchase);
//         }
//         return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//       }),
//     );

//     productList.addAll(
//       _products.map(
//         (ProductDetails productDetails) {
//           final previousPurchase = purchases[productDetails.id];
//           return ListTile(
//             title: Text(productDetails.title),
//             subtitle: Text(productDetails.description),
//             trailing: previousPurchase != null
//                 ? IconButton(
//                     onPressed: () => confirmPriceChange(context),
//                     icon: const Icon(Icons.upgrade),
//                   )
//                 : TextButton(
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.green[800],
//                       foregroundColor: Colors.white,
//                     ),
//                     onPressed: () {
//                       late PurchaseParam purchaseParam;

//                       if (Platform.isAndroid) {
//                         // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
//                         // verify the latest status of you your subscription by using server side receipt validation
//                         // and update the UI accordingly. The subscription purchase status shown
//                         // inside the app may not be accurate.
//                         final oldSubscription =
//                             _getOldSubscription(productDetails, purchases);

//                         // purchaseParam = GooglePlayPurchaseParam(
//                         //   productDetails: productDetails,
//                         //   applicationUserName: null,
//                         //   changeSubscriptionParam: (oldSubscription != null)
//                         //       ? ChangeSubscriptionParam(
//                         //           oldPurchaseDetails: oldSubscription,
//                         //           prorationMode:
//                         //               ProrationMode.immediateWithTimeProration,
//                         //         )
//                         //       : null,
//                         // );
//                       } else {
//                         purchaseParam = PurchaseParam(
//                           productDetails: productDetails,
//                           applicationUserName: null,
//                         );
//                       }

//                       if ((productDetails.id == sub1MonthId) ||
//                           (productDetails.id == sub6MonthsId) ||
//                           (productDetails.id == sub12MonthsId)) {
//                         _inAppPurchase.buyConsumable(
//                           purchaseParam: purchaseParam,
//                           autoConsume: kAutoConsume || Platform.isIOS,
//                         );
//                       } else {
//                         _inAppPurchase.buyNonConsumable(
//                           purchaseParam: purchaseParam,
//                         );
//                       }
//                     },
//                     child: Text(productDetails.price),
//                   ),
//           );
//         },
//       ),
//     );

//     return Card(
//       child: Column(
//         children: <Widget>[productHeader, const Divider()] + productList,
//       ),
//     );
//   }

//   Card _buildConsumableBox() {
//     if (_loading) {
//       return const Card(
//         child: ListTile(
//           leading: CircularProgressIndicator(),
//           title: Text('Fetching consumables...'),
//         ),
//       );
//     }

//     if (!_isAvailable || _notFoundIds.contains(sub1MonthId)) {
//       return const Card();
//     }

//     const consumableHeader = ListTile(title: Text('Purchased consumables'));

//     final List<Widget> tokens = _consumables.map((String id) {
//       return GridTile(
//         child: IconButton(
//           icon: const Icon(
//             Icons.stars,
//             size: 42,
//             color: Colors.orange,
//           ),
//           splashColor: Colors.yellowAccent,
//           onPressed: () => consume(id),
//         ),
//       );
//     }).toList();

//     return Card(
//       child: Column(
//         children: <Widget>[
//           consumableHeader,
//           const Divider(),
//           GridView.count(
//             crossAxisCount: 5,
//             shrinkWrap: true,
//             padding: const EdgeInsets.all(16),
//             children: tokens,
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildRestoreButton() {
//     if (_loading) {
//       return Container();
//     }

//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           TextButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Theme.of(context).primaryColor,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: _inAppPurchase.restorePurchases,
//             child: const Text('Restore purchases'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> consume(String id) async {
//     await ConsumableStore.consume(id);
//     final consumables = await ConsumableStore.load();
//     setState(() {
//       _consumables = consumables;
//     });
//   }

//   void showPendingUI() {
//     setState(() {
//       _purchasePending = true;
//     });
//   }

//   Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify purchase details before delivering the product.
//     if ((purchaseDetails.productID == sub1MonthId) ||
//         (purchaseDetails.productID == sub6MonthsId) ||
//         (purchaseDetails.productID == sub12MonthsId)) {
//       await ConsumableStore.save(purchaseDetails.purchaseID!);
//       final consumables = await ConsumableStore.load();

//       setState(() {
//         _purchasePending = false;
//         _consumables = consumables;
//       });
//     } else {
//       setState(() {
//         _purchases.add(purchaseDetails);
//         _purchasePending = false;
//       });
//     }
//   }

//   void handleError(IAPError error) {
//     setState(() {
//       _purchasePending = false;
//     });
//   }

//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     // IMPORTANT!! Always verify a purchase before delivering the product.
//     // For the purpose of an example, we directly return true.
//     print(purchaseDetails.verificationData.serverVerificationData);
//     return Future<bool>.value(true);
//   }

//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     // handle invalid purchase here if  _verifyPurchase` failed.
//   }

//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         showPendingUI();
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           handleError(purchaseDetails.error!);
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           final valid = await _verifyPurchase(purchaseDetails);

//           if (valid) {
//             await deliverProduct(purchaseDetails);
//           } else {
//             _handleInvalidPurchase(purchaseDetails);
//             return;
//           }
//         }
//         if (purchaseDetails.pendingCompletePurchase) {
//           await _inAppPurchase.completePurchase(purchaseDetails);
//         }
//       }
//     });
//   }

//   Future<void> confirmPriceChange(BuildContext context) async {
//     if (Platform.isAndroid) {
//       final androidAddition = _inAppPurchase
//           .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

//       final priceChangeConfirmationResult =
//           await androidAddition.launchPriceChangeConfirmationFlow(
//         sku: 'purchaseId',
//       );

//       if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
//         notify.snack('Price change accepted');
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(
//         //     content: Text('Price change accepted'),
//         //   ),
//         // );
//       } else {
//         notify.snack(
//           priceChangeConfirmationResult.debugMessage ??
//               'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
//         );
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(
//         //     content: Text(
//         //       priceChangeConfirmationResult.debugMessage ??
//         //           'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
//         //     ),
//         //   ),
//         // );
//       }
//     }
//     if (Platform.isIOS) {
//       final iapStoreKitPlatformAddition = _inAppPurchase
//           .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//       await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
//     }
//   }

//   GooglePlayPurchaseDetails? _getOldSubscription(
//     ProductDetails productDetails,
//     Map<String, PurchaseDetails> purchases,
//   ) {
//     // This is just to demonstrate a subscription upgrade or downgrade.
//     // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
//     // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
//     // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
//     // Please remember to replace the logic of finding the old subscription Id as per your app.
//     // The old subscription is only required on Android since Apple handles this internally
//     // by using the subscription group feature in iTunesConnect.
//     GooglePlayPurchaseDetails? oldSubscription;
//     // if (productDetails.id == basePlan180 &&
//     //     purchases[_kGoldSubscriptionId] != null) {
//     //   oldSubscription =
//     //       purchases[_kGoldSubscriptionId] as GooglePlayPurchaseDetails;
//     // } else if (productDetails.id == _kGoldSubscriptionId &&
//     //     purchases[basePlan180] != null) {
//     //   oldSubscription = purchases[basePlan180] as GooglePlayPurchaseDetails;
//     // }
//     return oldSubscription;
//   }
// }

// /// Example implementation of the
// /// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
// ///
// /// The payment queue delegate can be implementated to provide information
// /// needed to complete transactions.
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//     SKPaymentTransactionWrapper transaction,
//     SKStorefrontWrapper storefront,
//   ) {
//     return true;
//   }

//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }
