import 'package:get/get.dart';

class TransactionController extends GetxController {
  // Mendeklarasikan transaksi sebagai observasi (observable)
  var transaction = <String, List<String>>{}.obs;

  final count = 0.obs;

  @override
  void onReady() {
    super.onReady();
    // Menambahkan print untuk mencetak data transaksi saat controller siap
    print('Transaction data: $transaction');
  }

  void increment() => count.value++;
}
