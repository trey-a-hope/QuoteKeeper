import 'dart:io';

import 'package:book_quotes/presentation/pages/create_book/create_book_view_model.dart';
import 'package:book_quotes/utils/constants/globals.dart';
import 'package:book_quotes/services/modal_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_page_widget/ui/simple_page_widget.dart';

class CreateBookView extends StatelessWidget {
  CreateBookView({Key? key}) : super(key: key);

  /// Key that holds the current state of the scaffold.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  final ModalService _modalService = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateBookViewModel>(
      init: CreateBookViewModel(),
      builder: (model) => SimplePageWidget(
        scaffoldKey: _scaffoldKey,
        leftIconButton: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back(result: false);
          },
        ),
        rightIconButton: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () async {
            bool? confirm = await _modalService.showConfirmation(
              context: context,
              title: 'Submit Quote',
              message: 'Are you sure?',
            );

            if (confirm == null || confirm == false) {
              return;
            }

            try {
              await model.create(
                title: _bookTitleController.text,
                author: _authorController.text,
                quote: _quoteController.text,
              );
              Get.back(result: true);
            } catch (error) {
              Get.showSnackbar(
                GetSnackBar(
                  title: 'Error',
                  message: error.toString(),
                  backgroundColor: Colors.red,
                  icon: const Icon(Icons.error),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        ),
        title: 'Create Quote',
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: AnimateList(
              interval: 400.ms,
              effects: Globals.fadeEffect,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    onChanged: (value) => {model.update()},
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Theme.of(context).textTheme.headline4!.color,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _bookTitleController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.headline3!.color,
                    ),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                          color: Theme.of(context).textTheme.headline6!.color),
                      counterStyle: TextStyle(
                          color: Theme.of(context).textTheme.headline6!.color),
                      hintText: 'Enter book title.',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    onChanged: (value) => {model.update()},
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Theme.of(context).textTheme.headline4!.color,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _authorController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.headline3!.color,
                    ),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                          color: Theme.of(context).textTheme.headline6!.color),
                      counterStyle: TextStyle(
                          color: Theme.of(context).textTheme.headline6!.color),
                      hintText: 'Enter book author.',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Theme.of(context).textTheme.headline4!.color,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _quoteController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.headline3!.color,
                    ),
                    maxLines: 10,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                          color: Theme.of(context).textTheme.headline6!.color),
                      counterStyle: TextStyle(
                          color: Theme.of(context).textTheme.headline6!.color),
                      hintText:
                          'Enter your favorite quote from ${_bookTitleController.text}',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => model.updateImage(
                    bookTitle: _bookTitleController.text,
                    imageSource: ImageSource.gallery,
                  ),
                  child: model.selectedCroppedFile == null
                      ? DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [4],
                          color: Colors.black,
                          strokeWidth: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: const [
                                Icon(Icons.add),
                                Text('Add Photo'),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 200,
                          width: 130,
                          child: Image.file(
                            File(model.selectedCroppedFile!.path),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
