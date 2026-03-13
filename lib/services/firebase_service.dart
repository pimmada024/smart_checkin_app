import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/checkin_model.dart';

class FirebaseService {
  Future<void> submitCheckIn(CheckInModel model) async {
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase is not initialized yet');
    }

    await FirebaseFirestore.instance.collection('checkins').add(model.toMap());
  }

  Future<void> submitFinishClass(FinishClassModel model) async {
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase is not initialized yet');
    }

    await FirebaseFirestore.instance
        .collection('finish_class')
        .add(model.toMap());
  }
}
