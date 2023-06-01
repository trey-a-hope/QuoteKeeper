import 'dart:math';

import 'package:book_quotes/models/books/book_model.dart';
import 'package:book_quotes/models/users/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

const String users = 'users';
const String books = 'books';

enum BookQuery {
  title,
  author,
  quote,
}

extension on Query<BookModel> {
  Query<BookModel> queryBy(BookQuery query) {
    switch (query) {
      case BookQuery.title:
        return orderBy('title', descending: true);
      case BookQuery.author:
        return orderBy('author', descending: true);
      case BookQuery.quote:
        return orderBy('quote', descending: true);
    }
  }
}

final _usersDB = FirebaseFirestore.instance
    .collection(users)
    .withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (model, _) => model.toJson());

class BookService extends GetxService {
  BookQuery query = BookQuery.title;

  CollectionReference<BookModel> _booksDB({required String uid}) {
    CollectionReference<BookModel> bookCol = _usersDB
        .doc(uid)
        .collection(books)
        .withConverter<BookModel>(
          fromFirestore: (snapshot, _) => BookModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        );
    return bookCol;
  }

  Future<BookModel> _getBook({required String uid, required String id}) async {
    try {
      final DocumentReference model = _booksDB(uid: uid).doc(id);
      return (await model.get()).data() as BookModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> _getRandomBookID({required String uid}) async {
    try {
      final UserModel? user = (await _usersDB.doc(uid).get()).data();

      if (user == null) {
        throw Exception('User is null');
      }

      Random random = Random();

      List<String> bookIDs = user.bookIDs;

      return bookIDs[random.nextInt(bookIDs.length)];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> create({required String uid, required BookModel book}) async {
    try {
      //TODO: Need a way to use the batch.commit() here.

      // Create document reference of book.s
      final DocumentReference bookDocRef = _booksDB(uid: uid).doc();

      // Add the book ID to the list of book ids collection.
      _usersDB.doc(uid).update(
        {
          'bookIDs': FieldValue.arrayUnion(
            [
              bookDocRef.id,
            ],
          )
        },
      );

      // Update ID of the book.
      book = book.copyWith(id: bookDocRef.id);

      // Set book data.
      bookDocRef.set(book);

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<int> getTotalBookCount({required String uid}) async {
    try {
      AggregateQuery count = _usersDB.doc(uid).collection(books).count();
      return (await count.get()).count;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BookModel> getRandom({required String uid}) async {
    try {
      String randomBookID = await _getRandomBookID(uid: uid);

      final BookModel book = await _getBook(uid: uid, id: randomBookID);

      return book;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> update({
    required String uid,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['modified'] = DateTime.now().toUtc();
      await _booksDB(uid: uid).doc(id).update(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<List<BookModel>> list({
    required String uid,
    int? limit,
    String? orderBy,
  }) async {
    try {
      CollectionReference<BookModel> bookCol = FirebaseFirestore.instance
          .collection(users)
          .doc(uid)
          .collection('books')
          .withConverter<BookModel>(
              fromFirestore: (snapshot, _) =>
                  BookModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson());

      Query q = bookCol.queryBy(query);

      if (limit != null) {
        q = q.limit(limit);
      }

      if (orderBy != null) {
        q = q.orderBy(orderBy, descending: true);
      }

      List<BookModel> books = (await q.get())
          .docs
          .map(
            (doc) => doc.data() as BookModel,
          )
          .toList();

      return books;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
