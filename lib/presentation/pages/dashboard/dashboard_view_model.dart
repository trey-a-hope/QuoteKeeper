import 'package:book_quotes/domain/models/books/book_model.dart';
import 'package:book_quotes/data/services/book_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardViewModel extends GetxController {
  final BookService _bookService = Get.find();

  BookModel? book;

  @override
  void onInit() async {
    super.onInit();

    await load();
  }

  Future load() async {
    try {
      book = await _bookService.getRandom();
      update();
    } catch (e) {
      debugPrint('');
    }
  }
}
