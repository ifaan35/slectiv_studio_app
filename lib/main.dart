import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'app/routes/app_pages.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDId-MVWbyDq_yrRAj--AheBMsjvfUwQIY",
      appId: "1:783802732450:android:0fbbb0305a3d3ffe352cfb",
      messagingSenderId: "783802732450",
      projectId: "mini-project-29e75",
      storageBucket: "gs://mini-project-29e75.appspot.com",
    ),
  );
  await Firebase.initializeApp();
  initSDK();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: SlectivTexts.mobileApplicationMainTitle,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

void initSDK() async {
  MidtransSDK? midtrans;
  midtrans = await MidtransSDK.init(
    config: MidtransConfig(
      clientKey: 'SB-Mid-client-ut94ktGniDplisdy',
      merchantBaseUrl: 'https://app.sandbox.midtrans.com/snap/v1/transactions',
      colorTheme: ColorTheme(
        colorPrimary: Color(0xFF00FF00),
        colorPrimaryDark: Color(0xFF00FF00),
        colorSecondary: Color(0xFF00FF00),
      ),
    ),
  );

  midtrans.setUIKitCustomSetting(skipCustomerDetailsPages: true);

  midtrans.setTransactionFinishedCallback((result) {
    print('Transaction Finished: $result');
  });
}
