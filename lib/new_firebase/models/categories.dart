import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesModel {
  final String url;
  final String category;
  final String name;
  final String complete_ayat;
  final String id;
  bool isFavorite;

  CategoriesModel.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : this.url = snapshot['url'],
        this.category = snapshot['tag'],
        this.name = snapshot['name'],
        this.complete_ayat = snapshot['CompleteAyat'],
        this.id = snapshot.id,
        this.isFavorite = false;
}
