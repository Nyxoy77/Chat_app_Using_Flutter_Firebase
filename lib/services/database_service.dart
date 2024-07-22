import 'package:chata/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _userCollection;
  DatabaseService() {
    _setUpCollectionRefernces();
  }
  void _setUpCollectionRefernces() {
  _userCollection = _firebaseFirestore.collection('users').
  withConverter<UserProfile>(
    fromFirestore:(snapshot,_)=> UserProfile.fromJson(
      snapshot.data()!,
    ) , 
    toFirestore: (userProfile,_) => userProfile.toJson(),
    );
  }
  Future<void> createUserProfile({required UserProfile userProfile}) async{
    await _userCollection?.doc(userProfile.uid).set(userProfile);
  }
}
