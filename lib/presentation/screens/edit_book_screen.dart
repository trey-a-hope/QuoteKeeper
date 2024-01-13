import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quote_keeper/data/services/modal_service.dart';
import 'package:quote_keeper/utils/config/providers.dart';
import 'package:quote_keeper/presentation/widgets/qk_scaffold_widget.dart';

class EditBookScreen extends ConsumerWidget {
  EditBookScreen({Key? key}) : super(key: key);

  final _modalService = ModalService();
  final _quoteController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var book = ref.watch(Providers.editBookNotifierProvider);

    // If book is null, that means it's been deleted. Return to previous page
    if (book == null) {
      context.pop();
      return Container();
    }

    _quoteController.text = book.quote;

    return QKScaffoldWidget(
      leftIconButton: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () => context.pop(),
      ),
      rightIconButton: IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () async {
          bool? confirm = await _modalService.showConfirmation(
            context: context,
            title: 'Delete Quote',
            message: 'Are you sure?',
          );

          if (confirm == null || confirm == false) {
            return;
          }

          ref.read(Providers.editBookNotifierProvider.notifier).deleteBook();
        },
      ),
      title: 'Edit Book',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              book.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onChanged: (val) {
                  ref.read(Providers.editBookNotifierProvider.notifier).setBook(
                        book.copyWith(quote: val),
                      );
                },
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Theme.of(context).textTheme.headlineMedium!.color,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _quoteController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.displaySmall!.color,
                ),
                maxLines: 10,
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge!.color),
                  counterStyle: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge!.color),
                  hintText: 'Enter new favorite quote from ${book.title}',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SwitchListTile(
              title: Text(book.hidden ? 'Hidden' : 'Visible',
                  style: Theme.of(context).textTheme.headlineSmall),
              subtitle: Text(
                  'Book ${book.hidden ? 'cannot' : 'can'} be fetched by the "Get Random Quote" button on the dashboard.',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: book.hidden,
              onChanged: (val) {
                ref.read(Providers.editBookNotifierProvider.notifier).setBook(
                      book.copyWith(hidden: val),
                    );
              },
              secondary: Icon(book.hidden ? Icons.hide_image : Icons.image,
                  color: Theme.of(context).iconTheme.color),
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: Text(book.complete ? 'Complete' : 'Incomplete',
                  style: Theme.of(context).textTheme.headlineSmall),
              subtitle: Text(
                  'You have ${book.complete ? '' : 'not '}finished reading this book.',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: book.complete,
              onChanged: (val) {
                // _formIsDirty.value = true;
                ref.read(Providers.editBookNotifierProvider.notifier).setBook(
                      book.copyWith(complete: val),
                    );
              },
              secondary: Icon(book.complete ? Icons.check : Icons.cancel,
                  color: Theme.of(context).iconTheme.color),
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            const Spacer(),
            ElevatedButton(
              child: const Text('Update Quote'),
              onPressed: () async {
                bool? confirm = await _modalService.showConfirmation(
                  context: context,
                  title: 'Update Quote',
                  message: 'Are you sure?',
                );

                if (confirm == null || confirm == false) {
                  return;
                }

                try {
                  ref
                      .read(Providers.editBookNotifierProvider.notifier)
                      .saveBook();

                  if (!context.mounted) return;

                  _modalService.showInSnackBar(
                    context: context,
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    message: 'Your changes were saved.',
                    title: 'Updated',
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  _modalService.showInSnackBar(
                    context: context,
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    message: 'Error',
                    title: e.toString(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
