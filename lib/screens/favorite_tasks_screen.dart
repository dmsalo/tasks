import 'package:flutter/material.dart';
//import './my_drawer.dart';

//import '../models/task.dart';
import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../widgets/tasks_list.dart';
//import 'add_task_screen.dart';

//ignore: must_be_immutable
//class FavoriteTasksScreen extends StatelessWidget {
class FavoriteTasksScreen extends StatelessWidget {
  const FavoriteTasksScreen({Key? key}) : super(key: key);
  //static const id = 'task_screen';
  static const id = 'favorite_task_screen';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        List<Task> tasksList = state.favoriteTasks;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Chip(
                //backgroundColor: Colors.primary,
                label: Text(
                  '${tasksList.length} Tasks',
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
