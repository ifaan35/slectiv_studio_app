import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:slectiv_studio_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {
  MidtransSDK? midtrans;
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var selectedOption = ''.obs;
  var selectedQuantity = ''.obs;
  var selectedPerson = ''.obs;
  var selectedTime = ''.obs;
  var apiToken = ''.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var bookings = <String, List<String>>{}.obs;

  final ProfileController profileController = Get.put(ProfileController());

  var calendarFormat;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
    _scheduleDailyReset();
  }

  Future<void> fetchBookings() async {
    var snapshot = await _firestore.collection(SlectivTexts.bookings).get();
    bookings.clear();
    for (var doc in snapshot.docs) {
      String date =
          (doc[SlectivTexts.bookingDate] as Timestamp)
              .toDate()
              .toIso8601String()
              .split('T')
              .first;
      if (!bookings.containsKey(date)) {
        bookings[date] = [];
      }
      String time = doc[SlectivTexts.bookingTime];
      String color = doc[SlectivTexts.bookingColor];
      String person = doc[SlectivTexts.bookingPerson];
      String email =
          doc.data().containsKey(SlectivTexts.profileEmail)
              ? doc[SlectivTexts.profileEmail]
              : SlectivTexts.bookingUnknown;
      String bookingDetails = "$time|$color|$person|$email";
      bookings[date]?.add(bookingDetails);
      print(
        "${SlectivTexts.bookingFetched} $bookingDetails ${SlectivTexts.bookingForDate} $date",
      );
    }
  }

  Future<void> saveBooking() async {
    await _firestore.collection(SlectivTexts.bookings).add({
      SlectivTexts.bookingDate: selectedDay.value,
      SlectivTexts.bookingTime: selectedTime.value,
      SlectivTexts.bookingColor: selectedOption.value,
      SlectivTexts.bookingPerson: selectedQuantity.value,
      SlectivTexts.profileEmail: profileController.email.value,
    });

    String date = selectedDay.value.toIso8601String().split('T').first;
    if (!bookings.containsKey(date)) {
      bookings[date] = [];
    }

    String bookingDetails =
        "${selectedTime.value}|${selectedOption.value}|${selectedQuantity.value}|${profileController.email.value}";
    bookings[date]?.add(bookingDetails);
    selectedTime.value = '';
  }

  bool isTimeBooked(DateTime date, String time) {
    String dateStr = date.toIso8601String().split('T').first;
    return bookings[dateStr]?.any((booking) => booking.split('|')[0] == time) ??
        false;
  }

  bool isTimePassed(DateTime date, String time) {
    final now = DateTime.now();
    final selectedTimeParts = time.split(':');
    final bookingTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(selectedTimeParts[0]),
      int.parse(selectedTimeParts[1]),
    );

    return bookingTime.isBefore(now);
  }

  void _scheduleDailyReset() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final duration = nextMidnight.difference(now);

    Future.delayed(duration, () {
      selectedDay.value = DateTime.now();
      fetchBookings();
      _scheduleDailyReset();
    });
  }

  Future<void> slectivBookingValidation(BookingController controller) async {
    if (controller.selectedOption.value.isEmpty ||
        controller.selectedQuantity.value.isEmpty ||
        controller.selectedTime.value.isEmpty) {
      Get.snackbar(
        SlectivTexts.errorBookingValidationTitle,
        SlectivTexts.errorBookingValidationSubtitle,
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
    } else {
      // await controller.saveBooking();
      midtrans = await MidtransSDK.init(
        config: MidtransConfig(
          clientKey: 'SB-Mid-client-ut94ktGniDplisdy',
          merchantBaseUrl:
              'https://app.sandbox.midtrans.com/snap/v3/redirection/',
          colorTheme: ColorTheme(
            colorPrimary: Theme.of(Get.context!).primaryColor,
            colorPrimaryDark: Theme.of(Get.context!).primaryColor,
            colorSecondary: Theme.of(Get.context!).primaryColor,
          ),
        ),
      );
      var response = await http.post(
        Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions'),
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Basic U0ItTWlkLXNlcnZlci1kcXctRmI1UUExN1dhMjJkVmUwOGEydVA6',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "transaction_details": {
            "order_id": "order-id-${DateTime.now().millisecondsSinceEpoch}",
            "gross_amount":
                75000 +
                (int.parse(controller.selectedPerson.value) > 3
                    ? (int.parse(controller.selectedPerson.value) - 3) * 20000
                    : 0),
          },
          "enabled_payments": [
            "gopay",
            "shopeepay",
          ], // Pastikan "dana" ada di sini
          "customer_details": {
            "first_name": "Budi",
            "last_name": "Pratama",
            "email": "budi.pra@example.com",
            "phone": "08111222333",
          },
        }),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print('Response data: $responseData');
        // Periksa apakah "dana" ada di dalam daftar metode pembayaran
      }

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        var token = responseData['token'];
        // save token to apiToken
        controller.apiToken.value = token;
        print('Transaction token: $token');
      } else {
        print(
          'Failed to create transaction. Status code: ${response.statusCode}',
        );
      }
      midtrans!.setUIKitCustomSetting(skipCustomerDetailsPages: true);
      // open midtrans payment page
      midtrans?.startPaymentUiFlow(token: controller.apiToken.value);

      midtrans?.setTransactionFinishedCallback((result) {
        print('Transaction finished with result: $result');
        if (result.isTransactionCanceled == true) {
          Get.snackbar(
            SlectivTexts.errorBookingValidationTitle,
            SlectivTexts.errorBookingValidationSubtitle,
            backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
            colorText: SlectivColors.whiteColor,
          );
        } else {
          Get.snackbar(
            SlectivTexts.successBookingValidationTitle,
            SlectivTexts.successBookingValidationSubtitle,
            backgroundColor: SlectivColors.positifSnackbarColor,
            colorText: SlectivColors.whiteColor,
          );
          controller.saveBooking();
        }
      });
      // await controller.saveBooking();
      // Get.offAll(const BottomNavigationBarView());
    }
  }

  bool get isBookingComplete {
    return selectedOption.isNotEmpty &&
        selectedQuantity.isNotEmpty &&
        selectedTime.isNotEmpty;
  }
}
