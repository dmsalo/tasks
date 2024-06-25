import 'package:flutter/material.dart';
//import './my_drawer.dart';

//import '../models/task.dart';
import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../widgets/tasks_list.dart';
//import 'add_task_screen.dart';

//ignore: must_be_immutable
//class PendingTasksScreen extends StatelessWidget {
class PendingTasksScreen extends StatefulWidget {
  const PendingTasksScreen({Key? key}) : super(key: key);
  //static const id = 'task_screen';
  static const id = 'pending_task_screen';

  @override
  State<PendingTasksScreen> createState() => _PendingTasksScreenState();
}

class _PendingTasksScreenState extends State<PendingTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> tasksList = state.pendingTasks;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Chip(
                //backgroundColor: proma,
                label: Text(
                  '${tasksList.length} Pending | ${state.completedTasks.length} Completed',
                ),
              ),
            ),
            TasksList(taskList: tasksList),
          ],
        );
      },
    );
  }
}
