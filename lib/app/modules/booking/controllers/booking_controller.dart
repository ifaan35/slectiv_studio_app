import 'dart:convert';
import 'dart:async';

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

  // Add timer variable
  Timer? _refreshTimer;
  // Add status for auto refresh
  var isAutoRefreshEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
    _scheduleDailyReset();
    // Start auto-refresh timer
    startAutoRefresh();
  }

  @override
  void onClose() {
    // Make sure to clean up timer when controller is disposed
    _refreshTimer?.cancel();
    super.onClose();
  }

  // Function to start auto-refresh
  void startAutoRefresh() {
    // Cancel running timer (if any)
    _refreshTimer?.cancel();

    // Create new timer that will call fetchBookings() every 1 second
    _refreshTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isAutoRefreshEnabled.value) {
        print('Auto-refresh: Updating booking data...');
        fetchBookings();
      }
    });

    print('Auto-refresh started: Data will be updated every 1 second');
  }

  // Function to stop auto-refresh
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    print('Auto-refresh stopped');
  }

  // Function to toggle auto-refresh
  void toggleAutoRefresh() {
    isAutoRefreshEnabled.value = !isAutoRefreshEnabled.value;

    if (isAutoRefreshEnabled.value) {
      Get.snackbar(
        'Auto-refresh Active',
        'Booking data will be automatically updated every 10 seconds',
        backgroundColor: SlectivColors.positifSnackbarColor,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      // If timer is not running, start new timer
      if (_refreshTimer == null || !_refreshTimer!.isActive) {
        startAutoRefresh();
      }
    } else {
      Get.snackbar(
        'Auto-refresh Inactive',
        'Booking data will not be automatically updated',
        backgroundColor: Colors.grey,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      // Timer keeps running, but won't call fetchBookings()
    }
  }

  Future<void> fetchBookings() async {
    try {
      var snapshot = await _firestore.collection(SlectivTexts.bookings).get();

      // Save old booking state for comparison
      Map<String, List<String>> oldBookings = Map.from(bookings);

      // Reset and fill with new data
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
      }

      // Notification if there are booking data changes on selected date
      String selectedDateStr =
          selectedDay.value.toIso8601String().split('T').first;
      bool hasChangesOnSelectedDate = _hasBookingChanges(
        oldBookings,
        bookings,
        selectedDateStr,
      );

      if (hasChangesOnSelectedDate) {
        update(); // Trigger UI update
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  // Helper method to check booking changes
  bool _hasBookingChanges(
    Map<String, List<String>> oldBookings,
    Map<String, List<String>> newBookings,
    String dateToCheck,
  ) {
    // If one doesn't have data on the checked date
    if (oldBookings[dateToCheck] == null && newBookings[dateToCheck] != null) {
      return true;
    }
    if (oldBookings[dateToCheck] != null && newBookings[dateToCheck] == null) {
      return true;
    }
    if (oldBookings[dateToCheck] == null && newBookings[dateToCheck] == null) {
      return false;
    }

    // Compare list length
    if (oldBookings[dateToCheck]!.length != newBookings[dateToCheck]!.length) {
      return true;
    }

    // Compare content
    for (var booking in newBookings[dateToCheck]!) {
      if (!oldBookings[dateToCheck]!.contains(booking)) return true;
    }

    return false;
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
      return;
    }

    try {
      // Initialize Midtrans SDK
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

      // Calculate total amount
      int totalAmount = 75000;
      int personCount = int.parse(controller.selectedPerson.value);
      if (personCount > 3) {
        totalAmount += (personCount - 3) * 20000;
      }

      // Create transaction
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
            "gross_amount": totalAmount,
          },
          "enabled_payments": ["gopay", "shopeepay", "dana"],
          "customer_details": {
            "first_name": "Budi",
            "last_name": "Pratama",
            "email": "budi.pra@example.com",
            "phone": "08111222333",
          },
        }),
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        var token = responseData['token'];
        controller.apiToken.value = token;
        print('Transaction token: $token');

        // Set up transaction callback
        midtrans?.setTransactionFinishedCallback((result) {
          print('Transaction finished with result: $result');
          if (result.isTransactionCanceled == true) {
            Get.snackbar(
              SlectivTexts.errorBookingValidationTitle,
              'Pembayaran dibatalkan',
              backgroundColor:
                  SlectivColors.cancelAndNegatifSnackbarButtonColor,
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

        // Configure and start payment
        midtrans?.setUIKitCustomSetting(skipCustomerDetailsPages: true);
        await midtrans?.startPaymentUiFlow(token: token);
      } else {
        print(
          'Failed to create transaction. Status code: ${response.statusCode}',
        );
        print('Response body: ${response.body}');
        Get.snackbar(
          'Error',
          'Gagal membuat transaksi. Silakan coba lagi.',
          backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
          colorText: SlectivColors.whiteColor,
        );
      }
    } catch (e) {
      print('Error in payment process: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: SlectivColors.whiteColor,
      );
    }
  }

  bool get isBookingComplete {
    return selectedOption.isNotEmpty &&
        selectedQuantity.isNotEmpty &&
        selectedTime.isNotEmpty;
  }
}
