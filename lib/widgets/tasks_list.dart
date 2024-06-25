import 'package:flutter/material.dart';

import '../models/task.dart';
//import '../blocs/bloc_exports.dart';
import 'task_tile.dart';

//class TasksList extends StatelessWidget {
class TasksList extends StatelessWidget {
  const TasksList({
    Key? key,
    required this.taskList,
  }) : super(key: key);

  final List<Task> taskList;

  @override
  Widget build(BuildContext context) {
    // buenos metodos para evitar problema para render
    // part 5: 7.05
    return Expanded(
      child: SingleChildScrollView(
        child: ExpansionPanelList.radio(
          children: taskList.isNotEmpty
              ? taskList
                  .map(
                    (task) => ExpansionPanelRadio(
                      value: task.id,
                      headerBuilder: (context, isOpen) => TaskTile(task: task),
                      body: ListTile(
                        //tileColor: Colors.black38,
                        //tileColor: Colors.grey.shade300,
                        //tileColor: Colors.grey.shade700,
                        tileColor: Theme.of(context).listTileTheme.tileColor,
                        title: SelectableText.rich(
                          TextSpan(children: [
                            const TextSpan(
                              text: 'Title: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: task.title,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const WidgetSpan(
                                child: Divider(
                              color: Colors.black38,
                              thickness: 2,
                            )),
                            const TextSpan(
                              text: '\nDescription: \n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: task.description,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  )
                  .toList()
              : [],
        ),
      ),
    );
  }
}

// Expanded(
//       child: ListView.builder(
//         itemCount: taskList.length,
//         itemBuilder: (context, i) {
//           var task = taskList[i];
//           return TaskTile(task: task);
//         },
//       ),
//     );
