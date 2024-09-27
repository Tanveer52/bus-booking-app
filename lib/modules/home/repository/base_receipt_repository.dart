import 'dart:io';

abstract class BaseReceiptRepository {
  Future<String> uploadReceipt({
    required File receipt,
  });
}
