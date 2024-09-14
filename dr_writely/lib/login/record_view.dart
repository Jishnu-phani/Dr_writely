import 'package:flutter/material.dart';
import 'package:dr_writely/login/audio_recorder_page.dart';

class RecordView extends StatelessWidget {
  static String tag = 'record-page';
  const RecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: [
            ElevatedButton(onPressed: (){Navigator.of(context).pushNamed(AudioRecorderPage.tag);}, child: const Text("Record")),
          ],
        ),
      ),
    );
    // return ListView.builder(
    //     itemCount: expenses.length,
    //     itemBuilder: (ctx, index) {
    //       return Dismissible(
    //         background: Container(
    //           color: Theme.of(context).colorScheme.error.withOpacity(0.75),
    //           margin: Theme.of(context).cardTheme.margin,
    //         ),
    //         key: ValueKey(expenses[index]),
    //         onDismissed: (direction) {
    //           onRemoveExpense(expenses[index]);
    //         },
    //         child: ExpenseItem(expenses[index]),
    //       );
    //     });
  }
}
