import 'dart:io';

import 'package:bus_booking_app/modules/home/repository/base_receipt_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/common_firebase_storage_repository.dart';

class ReceiptRepository extends BaseReceiptRepository {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final CommonFirebaseStorageRepository _commonFirebaseStorageRepository =
      CommonFirebaseStorageRepository();

  @override
  Future<String> uploadReceipt({required File receipt}) async {
    final filePathRef = 'receipts/${DateTime.now().millisecondsSinceEpoch}';

    final fileUrl = await _commonFirebaseStorageRepository.storeFileToFirebase(
      file: receipt,
      ref: filePathRef,
    );

    return fileUrl;
  }
}
