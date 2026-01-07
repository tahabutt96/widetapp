import 'dart:io';

import 'package:appwidgetflutter/dashboard/error_handling/add_aya_state.dart';
import 'package:appwidgetflutter/dashboard/error_handling/error_handling_category.dart';
import 'package:appwidgetflutter/dashboard/error_handling/get_aya_state.dart';
import 'package:appwidgetflutter/dashboard/error_handling/get_category_states.dart';
import 'package:appwidgetflutter/dashboard/error_handling/login_user_state.dart';
import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:appwidgetflutter/dashboard/models/add_category_model.dart';
import 'package:appwidgetflutter/dashboard/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FirebaseController {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  static Future<AddCategoryState> addCategoryToFirebase({required AddCategoryModel addCategory})async {
     String id = _firestore.collection('categories').doc().id;
    try {
      int length= await getLengthofTheCategoriesExistsInFirebase();
         await _firestore.collection('categories').doc(id).set(
           AddCategoryModel(
            category: addCategory.category,
            date: DateTime.now().microsecondsSinceEpoch.toString(),
            id: id,
            key: length,
            image: addCategory.image).toJson(),
          );
          return AddCategoryState(success: true, message: 'Category uploaded successfully');
    } on FirebaseException catch (e) {
      return AddCategoryState(success: false, message: e.message.toString());
    }
  }

  static Future<AddCategoryState> findCategoryIfAlreadyExistsInFirebase({String? category}) async{
    try {
      final snap = await _firestore
          .collection('categories')
          .where('category',isEqualTo:category)
          .get();
          print(snap.docs.length);
        if(snap.docs.length == 1) {
          return AddCategoryState(success: true, message: 'Category Already Exists');
        }
        else return AddCategoryState(success: false, message: 'Not Exists');
    } on IOException catch (e) {
      return AddCategoryState(success: false, message: e.toString());
    }
  }

  static Future getLengthofTheAyaExistsInFirebase(catId) async {
    try {
      final snap = await _firestore
          .collection('aya').doc(catId).collection('cataya').get();
      return snap.docs.length;
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  static Future getLengthofTheCategoriesExistsInFirebase() async {
    try {
      final snap = await _firestore
          .collection('categories').get();
      return snap.docs.length;
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  static Future<AddCategoryState> uploadImageToFirebaseForWeb({Uint8List? data,String? meme}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putData(data!,SettableMetadata(contentType:meme));
    return uploadTask.then((TaskSnapshot storageTaskSnapshot)async {
      String url = await storageTaskSnapshot.ref.getDownloadURL();
      return AddCategoryState(success: true, message: url);
    }, onError: (e) {
      AddCategoryState(success: true, message: e);
    });
 }


 /// get All Categoreis
 /// 
  static Future<GetAllCategories> getAllCategoriesFromFirebase() async{
    try {
      final snap = await _firestore
          .collection('categories').orderBy('key', descending: true).get();
      return GetAllCategories(success: true, result: snap.docs.map((e) => AddCategoryModel.fromJson(e.data())).toList());
    } on FirebaseException catch (e) {
      return GetAllCategories(success: false, result: [],message: e.message!);
    }
  }

  static Future<bool> deleteCategory(String catId) async{
    try {
      await _firestore
          .collection('categories').doc(catId).delete();
      return true;
    } on FirebaseException {
      return false;
    }
  }
 static Future updateAyaTime(int oldIndex, int newIndex,String catId) async{
    try {
       final snap= await _firestore.collection('aya').doc(catId).collection('cataya').orderBy('key', descending: false).get();
       List<DocumentSnapshot> _docs=snap.docs;
       if (oldIndex < newIndex) newIndex -= 1;
        _docs.insert(newIndex, _docs.removeAt(oldIndex));
        final batch= FirebaseFirestore.instance.batch();
        for (int pos = 0; pos < _docs.length; pos++) {
            batch.update(_docs[pos].reference, {'key': pos});
          }
        batch.commit();
    }on FirebaseException catch (e) {
      print(e);
    }
  }

  static Future reorderCategoryTime(int oldIndex, int newIndex,String catId) async{
    try {
       final snap= await _firestore.collection('categories').orderBy('key', descending: true).get();
       List<DocumentSnapshot> _docs=snap.docs;
       if (oldIndex < newIndex) newIndex -= 1;
        _docs.insert(newIndex, _docs.removeAt(oldIndex));
        final batch= FirebaseFirestore.instance.batch();
        for (int pos = 0; pos < _docs.length; pos++) {
            batch.update(_docs[pos].reference, {'key': pos});
          }
        batch.commit();
    }on FirebaseException catch (e) {
      print(e);
    }
  }

  /// aya database
  static Future<AddAyaState> addAyaToFirebase({required AddAyaModel addAya})async {
     String id = _firestore.collection('aya').doc().id;
    try {
      int length= await getLengthofTheAyaExistsInFirebase(addAya.catId);
      
      await _firestore.collection('aya').doc(addAya.catId).collection('cataya').doc(id).set(
        AddAyaModel(
          aya: addAya.aya,
          catId: addAya.catId,
          date: DateTime.now().microsecondsSinceEpoch.toString(),
          id: id,
          key: length,
        ).toJson(),
      );
      return AddAyaState(success: true, message: 'Aya uploaded successfully');
    } on FirebaseException catch (e) {
      return AddAyaState(success: false, message: e.message.toString());
    }
  }

  static Future<GetAllAyaState> getAllAyaByCategoryFromFirebase({required String catId}) async{
    try {
      final snap = await _firestore
          .collection('aya').doc(catId).collection('cataya').orderBy('key', descending: false).get();
      return GetAllAyaState(success: true, result: snap.docs.map((e) => AddAyaModel.fromJson(e.data())).toList());
    } on FirebaseException catch (e) {
      return GetAllAyaState(success: false, result: [],message: e.message!);
    }
  }

  static Future<bool> deleteAyaByCategoryFromFirebase({required String catId, required String ayaId}) async{
    try {
      await _firestore.collection('aya').doc(catId).collection('cataya').doc(ayaId).delete();
      return true;
    } on FirebaseException {
      return false;
    }
  }

 static Future<LoginUserState> signInUserWitheEmailAndPassword({required UserModel userModel}) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: userModel.email, password: userModel.password!);
      return LoginUserState(userCredential: user, message: "Login Successfully");
    } on FirebaseAuthException catch(e) {
      return LoginUserState(userCredential: null, message: e.message.toString());
    }
  } 
}