import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';

class TransactionController extends GetxController {
  // Original properties
  var transaction = <String, List<String>>{}.obs;
  final count = 0.obs;

  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dependencies
  late BookingController _bookingController;

  // Observables for upcoming booking management
  final RxString selectedTime = ''.obs;
  final RxString selectedColor = ''.obs;
  final RxString selectedPerson = ''.obs;
  final RxBool isLoading = false.obs;

  // Options for dropdowns
  final List<String> timeOptions = [
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
  ];

  final List<String> colorOptions = [
    'White Background',
    'Dark Grey Background',
    'Sage Background',
    'Wide Blue',
    'Spotlight',
    'American Yearbook',
  ];

  final List<String> personOptions = [
    '1',
    '2',
    '3',
    '4(+20.000)',
    '5(+40.000)',
    '6(+60.000)',
    '7(+80.000)',
    '8(+100.000)',
    '9(+120.000)',
    '10(+140.000)',
  ];

  @override
  void onInit() {
    super.onInit();
    _bookingController = Get.find<BookingController>();
  }

  @override
  void onReady() {
    super.onReady();
    // Print transaction data when controller is ready
    print('Transaction data: $transaction');
  }

  void increment() => count.value++;

  /// Get upcoming bookings sorted by date and time
  List<Map<String, dynamic>> getUpcomingBookings() {
    if (_bookingController.bookings.isEmpty) return [];

    List<String> sortedDates = _bookingController.bookings.keys.toList();
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> upcomingBookings = [];

    for (String date in sortedDates) {
      DateTime parsedDate = DateTime.parse(date);
      List<String> bookings = _bookingController.bookings[date] ?? [];

      for (String booking in bookings) {
        List<String> bookingDetails = booking.split('|');
        String time = bookingDetails[0];

        try {
          DateTime bookingTime = DateTime(
            parsedDate.year,
            parsedDate.month,
            parsedDate.day,
            int.parse(time.split(':')[0]),
            int.parse(time.split(':')[1]),
          );

          if (bookingTime.isAfter(now)) {
            upcomingBookings.add({
              SlectivTexts.bookingDate: date,
              SlectivTexts.bookingDetails: booking,
            });
          }
        } catch (e) {
          print("Error parsing time: $time");
        }
      }
    }

    // Sort bookings by date and time
    upcomingBookings.sort((a, b) {
      DateTime dateTimeA = DateTime.parse(a[SlectivTexts.bookingDate]);
      DateTime dateTimeB = DateTime.parse(b[SlectivTexts.bookingDate]);

      DateTime timeA = DateTime(
        dateTimeA.year,
        dateTimeA.month,
        dateTimeA.day,
        int.parse(a[SlectivTexts.bookingDetails].split('|')[0].split(':')[0]),
        int.parse(a[SlectivTexts.bookingDetails].split('|')[0].split(':')[1]),
      );

      DateTime timeB = DateTime(
        dateTimeB.year,
        dateTimeB.month,
        dateTimeB.day,
        int.parse(b[SlectivTexts.bookingDetails].split('|')[0].split(':')[0]),
        int.parse(b[SlectivTexts.bookingDetails].split('|')[0].split(':')[1]),
      );

      return timeA.compareTo(timeB);
    });

    return upcomingBookings;
  }

  /// Initialize edit form with current values
  void initializeEditForm(String time, String color, String person) {
    selectedTime.value = time;
    selectedColor.value = color;
    selectedPerson.value = person;
  }

  /// Check if time slot is available for booking
  Future<bool> _checkTimeConflict(
    String date,
    String newTime,
    String oldTime,
  ) async {
    if (oldTime == newTime) return false; // No conflict if time hasn't changed

    try {
      DateTime bookingDate = DateTime.parse(date);
      Timestamp firestoreDate = Timestamp.fromDate(bookingDate);

      var conflictQuery =
          await _firestore
              .collection(SlectivTexts.bookings)
              .where(SlectivTexts.bookingDate, isEqualTo: firestoreDate)
              .where(SlectivTexts.bookingTime, isEqualTo: newTime)
              .get();

      return conflictQuery.docs.isNotEmpty;
    } catch (e) {
      print("Error checking time conflict: $e");
      return true; // Assume conflict on error
    }
  }

  /// Find booking document in Firestore
  Future<DocumentSnapshot?> _findBookingDocument(
    String date,
    String time,
    String email,
  ) async {
    try {
      var querySnapshot =
          await _firestore.collection(SlectivTexts.bookings).get();

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        if (data[SlectivTexts.bookingDate] is Timestamp) {
          var docDate = data[SlectivTexts.bookingDate] as Timestamp;
          var docDateStr = DateFormat('yyyy-MM-dd').format(docDate.toDate());

          if (docDateStr == date &&
              data[SlectivTexts.bookingTime] == time &&
              data[SlectivTexts.profileEmail] == email) {
            return doc;
          }
        }
      }
      return null;
    } catch (e) {
      print("Error finding booking document: $e");
      return null;
    }
  }

  /// Show loading dialog
  void _showLoadingDialog() {
    isLoading.value = true;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  /// Hide loading dialog
  void _hideLoadingDialog() {
    isLoading.value = false;
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Show success snackbar
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: SlectivColors.positifSnackbarColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      isDismissible: true,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      isDismissible: true,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  /// Update booking in Firestore
  Future<void> updateBooking(String date, String oldTime, String email) async {
    try {
      _showLoadingDialog();

      // Check for time conflicts
      bool hasConflict = await _checkTimeConflict(
        date,
        selectedTime.value,
        oldTime,
      );
      if (hasConflict) {
        _hideLoadingDialog();
        _showErrorSnackbar(
          'Time ${selectedTime.value} on $date has already been booked by someone else. Please choose another time.',
        );
        return;
      }

      // Find the booking document
      DocumentSnapshot? matchingDoc = await _findBookingDocument(
        date,
        oldTime,
        email,
      );

      if (matchingDoc != null) {
        // Update the document
        await _firestore
            .collection(SlectivTexts.bookings)
            .doc(matchingDoc.id)
            .update({
              SlectivTexts.bookingTime: selectedTime.value,
              SlectivTexts.bookingColor: selectedColor.value,
              SlectivTexts.bookingPerson: selectedPerson.value,
            });

        _hideLoadingDialog();
        Get.back(); // Close edit dialog
        _showSuccessSnackbar('Booking updated successfully');

        // Refresh data
        await _bookingController.fetchBookings();
      } else {
        _hideLoadingDialog();
        _showErrorSnackbar('Booking not found');
      }
    } catch (e) {
      _hideLoadingDialog();
      _showErrorSnackbar('An error occurred: $e');
    }
  }

  /// Delete booking from Firestore
  Future<void> deleteBooking(String date, String time, String email) async {
    try {
      _showLoadingDialog();

      // Find the booking document
      DocumentSnapshot? matchingDoc = await _findBookingDocument(
        date,
        time,
        email,
      );

      if (matchingDoc != null) {
        // Delete the document
        await _firestore
            .collection(SlectivTexts.bookings)
            .doc(matchingDoc.id)
            .delete();

        _hideLoadingDialog();
        _showSuccessSnackbar('Booking deleted successfully');

        // Refresh data
        await _bookingController.fetchBookings();
      } else {
        _hideLoadingDialog();
        _showErrorSnackbar('Booking not found');
      }
    } catch (e) {
      _hideLoadingDialog();
      _showErrorSnackbar('An error occurred while deleting booking: $e');
    }
  }

  /// Show edit dialog
  void showEditDialog(
    String date,
    String time,
    String color,
    String person,
    String email,
  ) {
    initializeEditForm(time, color, person);

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Edit Booking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: $date',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              _buildTimeDropdown(),
              const SizedBox(height: 12),
              _buildColorDropdown(),
              const SizedBox(height: 12),
              _buildPersonDropdown(),
              const SizedBox(height: 12),
              Text('Email: $email'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: SlectivColors.cancelAndNegatifSnackbarButtonColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => updateBooking(date, time, email),
            child: Text(
              'Save',
              style: TextStyle(color: SlectivColors.submitButtonColor),
            ),
          ),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog
  void showDeleteConfirmation(String date, String time, String email) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Delete Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this booking?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: SlectivColors.blackColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteBooking(date, time, email);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: SlectivColors.cancelAndNegatifSnackbarButtonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown Builders
  Widget _buildTimeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Time'),
        Obx(
          () => DropdownButtonFormField<String>(
            value: selectedTime.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items:
                timeOptions.map((String time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                selectedTime.value = newValue;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Background'),
        Obx(
          () => DropdownButtonFormField<String>(
            value: selectedColor.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items:
                colorOptions.map((String color) {
                  return DropdownMenuItem<String>(
                    value: color,
                    child: Text(color),
                  );
                }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                selectedColor.value = newValue;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPersonDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Number of People'),
        Obx(
          () => DropdownButtonFormField<String>(
            value: selectedPerson.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items:
                personOptions.map((String person) {
                  return DropdownMenuItem<String>(
                    value: person,
                    child: Text(person),
                  );
                }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                selectedPerson.value = newValue;
              }
            },
          ),
        ),
      ],
    );
  }
}
