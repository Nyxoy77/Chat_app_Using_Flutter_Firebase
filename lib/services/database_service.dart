import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _userCollection;
  DatabaseService() {
    _setUpCollectionRefernces();
  }
  void _setUpCollectionRefernces() {

  }
}
