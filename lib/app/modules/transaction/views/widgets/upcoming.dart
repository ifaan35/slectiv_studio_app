import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slectiv_studio_app/app/modules/booking/controllers/booking_controller.dart';
import 'package:slectiv_studio_app/app/modules/bottom_navigation_bar/controllers/bottom_navigation_bar_controller.dart';
import 'package:slectiv_studio_app/utils/constants/colors.dart';
import 'package:slectiv_studio_app/utils/constants/text_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.put(BookingController());

    return SafeArea(
      child: Obx(() {
        if (bookingController.bookings.isEmpty) {
          return const Center(
            child: Text(
              SlectivTexts.bookingNotHistory,
              style: TextStyle(fontSize: 16, color: SlectivColors.blackColor),
            ),
          );
        } else {
          List<String> sortedDates = bookingController.bookings.keys.toList();
          DateTime now = DateTime.now();

          List<Map<String, dynamic>> upcomingBookings = [];

          for (String date in sortedDates) {
            DateTime parsedDate = DateTime.parse(date);
            List<String> bookings = bookingController.bookings[date] ?? [];
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

          upcomingBookings.sort((a, b) {
            DateTime dateTimeA = DateTime.parse(a[SlectivTexts.bookingDate]);
            DateTime dateTimeB = DateTime.parse(b[SlectivTexts.bookingDate]);
            DateTime timeA = DateTime(
              dateTimeA.year,
              dateTimeA.month,
              dateTimeA.day,
              int.parse(
                a[SlectivTexts.bookingDetails].split('|')[0].split(':')[0],
              ),
              int.parse(
                a[SlectivTexts.bookingDetails].split('|')[0].split(':')[1],
              ),
            );
            DateTime timeB = DateTime(
              dateTimeB.year,
              dateTimeB.month,
              dateTimeB.day,
              int.parse(
                b[SlectivTexts.bookingDetails].split('|')[0].split(':')[0],
              ),
              int.parse(
                b[SlectivTexts.bookingDetails].split('|')[0].split(':')[1],
              ),
            );
            return timeA.compareTo(timeB);
          });

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            children: [
              const SizedBox(height: 8),
              ...upcomingBookings.map((booking) {
                return buildBookingList(
                  booking[SlectivTexts.bookingDate],
                  booking[SlectivTexts.bookingDetails],
                );
              }),
            ],
          );
        }
      }),
    );
  }

  Widget buildBookingList(String date, String bookingDetails) {
    List<String> details = bookingDetails.split('|');
    String time = details[0];
    String color = details[1];
    String person = details[2];
    String email = details.length > 3 ? details[3] : "";

    final BottomNavigationBarController bottomNavigationBarController = Get.put(
      BottomNavigationBarController(),
    );
    var role = bottomNavigationBarController.isUser.value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        clipBehavior: Clip.none, // Memungkinkan children melebihi batas Stack
        children: [
          // Container utama
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$date $time",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${SlectivTexts.bookingTitleTime} : $time",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "${SlectivTexts.bookingTitle3} : $color",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "${SlectivTexts.bookingTitle4} : $person",
                  style: const TextStyle(fontSize: 16),
                ),
                role
                    ? const SizedBox.shrink() // Tidak menampilkan email untuk user biasa
                    : Text(
                      "Email : $email",
                      style: const TextStyle(fontSize: 16),
                    ),
                // Tambahkan padding di bawah untuk memberikan ruang untuk FAB
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Tombol edit di pojok kanan bawah
          Positioned(
            right: 0,
            bottom: -15,
            child: FloatingActionButton(
              onPressed: () {
                _showEditDialog(date, time, color, person, email);
              },
              backgroundColor: const Color.fromARGB(255, 211, 211, 247),
              mini: true, // FAB ukuran kecil
              elevation: 3,
              child: const Icon(Icons.edit, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // Tambahkan metode untuk menampilkan dialog edit
  void _showEditDialog(
    String date,
    String time,
    String color,
    String person,
    String email,
  ) {
    // Options untuk dropdown
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

    // Nilai yang akan digunakan untuk menyimpan pilihan baru
    RxString selectedTime = time.obs;
    RxString selectedColor = color.obs;
    RxString selectedPerson = person.obs;

    Get.dialog(
      AlertDialog(
        title: Text(
          'Edit Booking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tanggal: $date',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),

              // Waktu
              Text('Waktu'),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedTime.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
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
              SizedBox(height: 12),

              // Background Color
              Text('Background'),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedColor.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
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
              SizedBox(height: 12),

              // Person Count
              Text('Jumlah Orang'),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedPerson.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
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
              SizedBox(height: 12),

              // Email (read-only)
              Text('Email: $email'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Tutup dialog tanpa menyimpan perubahan
              Get.back();
            },
            child: Text(
              'Batal',
              style: TextStyle(
                color: SlectivColors.cancelAndNegatifSnackbarButtonColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Simpan perubahan
              _updateBooking(
                date,
                time,
                selectedTime.value,
                selectedColor.value,
                selectedPerson.value,
                email,
              );
            },
            child: Text(
              'Simpan',
              style: TextStyle(color: SlectivColors.submitButtonColor),
            ),
          ),
        ],
      ),
    );
  }

  // Metode untuk memperbarui data booking
  Future<void> _updateBooking(
    String date,
    String oldTime,
    String newTime,
    String newColor,
    String newPerson,
    String email,
  ) async {
    try {
      // Tampilkan loading dialog
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final BookingController bookingController = Get.find<BookingController>();

      DateTime bookingDate = DateTime.parse(date);
      Timestamp firestoreDate = Timestamp.fromDate(bookingDate);

      // Cek konflik waktu apakah sudah ada booking lain dengan waktu yang sama
      // (Jika waktu tidak berubah, tidak perlu mengecek konflik)
      if (oldTime != newTime) {
        // Cari semua booking pada tanggal yang sama dengan waktu yang sama
        var conflictQuery =
            await firestore
                .collection(SlectivTexts.bookings)
                .where(SlectivTexts.bookingDate, isEqualTo: firestoreDate)
                .where(SlectivTexts.bookingTime, isEqualTo: newTime)
                .get();

        if (conflictQuery.docs.isNotEmpty) {
          // Tutup loading dialog
          Get.back();

          // Tampilkan pesan error untuk konflik waktu
          Get.snackbar(
            'Gagal Update',
            'Waktu $newTime pada tanggal $date sudah dipesan oleh orang lain. Silakan pilih waktu lain.',
            backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.all(10),
            borderRadius: 8,
            isDismissible: true,
            icon: Icon(Icons.error, color: Colors.white),
          );
          return; // Hentikan proses update
        }
      }

      // Cari booking yang akan diupdate
      var querySnapshot =
          await firestore.collection(SlectivTexts.bookings).get();

      // Cari dokumen yang cocok
      DocumentSnapshot? matchingDoc;
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Periksa timestamp dan konversi ke string untuk perbandingan
        if (data[SlectivTexts.bookingDate] is Timestamp) {
          var docDate = data[SlectivTexts.bookingDate] as Timestamp;
          var docDateStr = DateFormat('yyyy-MM-dd').format(docDate.toDate());

          if (docDateStr == date &&
              data[SlectivTexts.bookingTime] == oldTime &&
              data[SlectivTexts.profileEmail] == email) {
            matchingDoc = doc;
            break;
          }
        }
      }

      if (matchingDoc != null) {
        // Update dokumen langsung tanpa transaction
        await firestore
            .collection(SlectivTexts.bookings)
            .doc(matchingDoc.id)
            .update({
              SlectivTexts.bookingTime: newTime,
              SlectivTexts.bookingColor: newColor,
              SlectivTexts.bookingPerson: newPerson,
            });

        // Tutup loading dialog
        Get.back();

        // Tutup dialog edit
        Get.back();

        // Tampilkan pesan sukses
        Get.snackbar(
          'Berhasil',
          'Booking berhasil diperbarui',
          backgroundColor: SlectivColors.positifSnackbarColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          borderRadius: 8,
          isDismissible: true,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );

        // Refresh data
        await bookingController.fetchBookings();
      } else {
        // Tutup loading dialog
        Get.back();

        // Tampilkan pesan error
        Get.snackbar(
          'Error',
          'Booking tidak ditemukan',
          backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          borderRadius: 8,
          isDismissible: true,
          icon: Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      // Tutup loading dialog jika masih terbuka
      Get.back();

      // Tampilkan pesan error
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: SlectivColors.cancelAndNegatifSnackbarButtonColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(10),
        borderRadius: 8,
        isDismissible: true,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }
}
