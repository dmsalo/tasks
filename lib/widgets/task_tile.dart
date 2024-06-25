import 'package:flutter/material.dart';
import '/screens/edit_task_screen.dart';
import 'package:intl/intl.dart';

import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import 'popup_menu.dart';

//class TaskTile extends StatelessWidget {
class TaskTile extends StatefulWidget {
  const TaskTile({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  void _removeOrDeleteTask(BuildContext ctx, Task task) {
    task.isDeleted!
        ? ctx.read<TasksBloc>().add(DeleteTask(task: task))
        : ctx.read<TasksBloc>().add(RemoveTask(task: task));
  }

  void _editTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // hacer visible todos los imputs y botones
      builder: ((context) => SingleChildScrollView(
            //physics: const ClampingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: EditTaskScreen(
                oldTask: widget.task,
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // ----
                /*
                widget.task.isFavorite == false
                    ? const Icon(Icons.star_outline)
                    : const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),

                 // ----

                IconButton(
                  onPressed: () => {
                    context.read<TasksBloc>().add(
                          MarkFavoriteOrUnFavoriteTask(task: widget.task),
                        ),
                  },
                  icon: widget.task.isFavorite == false
                      ? const Icon(Icons.star_border_outlined)
                      : const Icon(Icons.star, color: Colors.amber),
                ),
                */

                // ----

                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: widget.task.isFavorite == false
                        ? const Icon(Icons.star_border_outlined)
                        : const Icon(Icons.star, color: Colors.amber),
                  ),
                  onLongPress: () => {
                    // avoid change when deleted
                    if (widget.task.isDeleted == false)
                      {
                        context.read<TasksBloc>().add(
                              MarkFavoriteOrUnFavoriteTask(task: widget.task),
                            ),
                      }
                  },
                ),

                // ----

                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          // TextDecoration.lineThrough
                          decoration:
                              widget.task.isDone! ? TextDecoration.none : null,
                          color: widget.task.isDone! && !widget.task.isDeleted!
                              ? Colors.orange
                              : null,
                        ),
                      ),
                      Text(
                        //DateFormat().add_yMEd().format(DateTime.now()),
                        DateFormat()
                            .add_yMMMEd()
                            .add_jm()
                            //.format(DateTime.now()),
                            .format(DateTime.parse(widget.task.date)),
                        //DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now()),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                checkColor: Colors.yellow.shade300,
                activeColor: Colors.green,
                value: widget.task.isDone,
                onChanged: widget.task.isDeleted == false
                    ? (value) {
                        context
                            .read<TasksBloc>()
                            .add(UpdateTask(task: widget.task));
                      }
                    : null,
              ),
              PopupMenu(
                task: widget.task,
                cancelOrDeleteCallback: () =>
                    _removeOrDeleteTask(context, widget.task),
                likeOrDislikeCallback: () => context.read<TasksBloc>().add(
                      MarkFavoriteOrUnFavoriteTask(task: widget.task),
                    ),
                editTaskCallback: () {
                  Navigator.of(context).pop();
                  _editTask(context);
                },
                restoreTaskCallback: () => context
                    .read<TasksBloc>()
                    .add(RestoreTask(task: widget.task)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ListTile(
//       title: Text(
//         task.title,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//           // TextDecoration.lineThrough
//           decoration: task.isDone! ? TextDecoration.none : null,
//           color: task.isDone! ? Colors.orange : null,
//         ),
//       ),
//       trailing: Checkbox(
//         value: task.isDone,
//         onChanged: task.isDeleted == false
//             ? (value) {
//                 context.read<TasksBloc>().add(UpdateTask(task: task));
//               }
//             : null,
//       ),
//       onLongPress: () => _removeOrDeleteTask(context, task),
//     );
