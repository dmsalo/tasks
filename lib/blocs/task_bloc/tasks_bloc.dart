//import 'package:bloc/bloc.dart';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import '/models/task.dart';

import '../bloc_exports.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnFavoriteTask>(_onMarkFavoriteOrUnFavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTasks);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..add(event.task),
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
      removedTasks: state.removedTasks,
    ));
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;

    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completedTasks = state.completedTasks;
    List<Task> favoriteTasks = state.favoriteTasks;

    if (task.isDone == false) {
      if (task.isFavorite == false) {
        // pending - no favorito
        pendingTasks = List.from(pendingTasks)..remove(task);
        completedTasks.insert(0, task.copyWith(isDone: true));
      } else {
        // pending - favorito
        var taskIndex = favoriteTasks.indexOf(task);
        pendingTasks = List.from(pendingTasks)..remove(task);
        completedTasks.insert(0, task.copyWith(isDone: true));
        favoriteTasks = List.from(favoriteTasks)
          ..remove(task)
          ..insert(taskIndex, task.copyWith(isDone: true));
      }
    } else {
      // completed - no favorito
      if (task.isFavorite == false) {
        completedTasks = List.from(completedTasks)..remove(task);
        pendingTasks = List.from(pendingTasks)
          ..insert(0, task.copyWith(isDone: false));
      } else {
        // completed - favorito
        var taskIndex = favoriteTasks.indexOf(task);
        completedTasks = List.from(completedTasks)..remove(task);
        pendingTasks = List.from(pendingTasks)
          ..insert(0, task.copyWith(isDone: false));
        favoriteTasks = List.from(favoriteTasks)
          ..remove(task)
          ..insert(taskIndex, task.copyWith(isDone: false));
      }
    }

    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      //favoriteTasks: state.favoriteTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: state.removedTasks,
    ));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: state.pendingTasks,
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
      removedTasks: List.from(state.removedTasks)..remove(event.task),
    ));
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..remove(event.task),
      completedTasks: List.from(state.completedTasks)..remove(event.task),
      favoriteTasks: List.from(state.favoriteTasks)..remove(event.task),
      removedTasks: List.from(state.removedTasks)
        ..add(event.task.copyWith(isDeleted: true)),
    ));
  }

  //------------------------------- favorite part 6 . 11.43
  void _onMarkFavoriteOrUnFavoriteTask(
      MarkFavoriteOrUnFavoriteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    List<Task> pendingTask = state.pendingTasks;
    List<Task> completedTasks = state.completedTasks;
    List<Task> favoriteTasks = state.favoriteTasks;

    if (event.task.isDone == false) {
      if (event.task.isFavorite == false) {
        var taskIndex = pendingTask.indexOf(event.task);
        pendingTask = List.from(pendingTask)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: true));
        favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
      } else {
        var taskIndex = pendingTask.indexOf(event.task);
        pendingTask = List.from(pendingTask)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: false));
        favoriteTasks.remove(event.task);
      }
    } else {
      if (event.task.isFavorite == false) {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: true));
        favoriteTasks.insert(0, event.task.copyWith(isFavorite: true));
      } else {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavorite: false));
        favoriteTasks.remove(event.task);
      }
    }
    emit(TasksState(
      pendingTasks: pendingTask,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removedTasks: state.removedTasks,
    ));
  }
  // end favorite

  //------------------------------------------------ editTask Part 6 18.00
  void _onEditTask(EditTask event, Emitter<TasksState> emit) {
    final state = this.state;
    //var taskIndex = state.pendingTasks.indexOf(event.oldTask); // **** ds

    List<Task> favouriteTasks = state.favoriteTasks;
    List<Task> completedTasks = state.completedTasks;
    List<Task> pendingTasks = state.pendingTasks;
    if (event.oldTask.isFavorite == true) {
      var taskIndexFav = state.favoriteTasks.indexOf(event.oldTask); // *** ds
      /*
      favouriteTasks = List.from(favouriteTasks)
        ..remove(event.oldTask)
        //..insert(0, event.newTask);
        //..insert(taskIndex, event.newTask);
        ..insert(taskIndexFav, event.newTask.copyWith(isDone: true));
        */

      // ---
      // *** ds
      if (event.oldTask.isDone == true) {
        var taskIndexCom =
            state.completedTasks.indexOf(event.oldTask); // *** ds
        favouriteTasks = List.from(favouriteTasks)
          ..remove(event.oldTask)
          //..insert(0, event.newTask);
          //..insert(taskIndex, event.newTask);
          ..insert(taskIndexFav, event.newTask.copyWith(isDone: true));
        // completado
        completedTasks = List.from(completedTasks)
          ..remove(event.oldTask)
          ..insert(taskIndexCom, event.newTask.copyWith(isDone: true));
        //print('------------------- 1');
      } else {
        var taskIndex = state.pendingTasks.indexOf(event.oldTask); // **** ds
        // pending tasks
        favouriteTasks = List.from(favouriteTasks)
          ..remove(event.oldTask)
          //..insert(0, event.newTask);
          //..insert(taskIndex, event.newTask);
          ..insert(taskIndexFav, event.newTask.copyWith(isDone: false));
        pendingTasks = List.from(pendingTasks)
          ..remove(event.oldTask)
          // ..insert(0, event.newTask),
          ..insert(taskIndex, event.newTask);
      }
    } else {
      // *** ds
      if (event.oldTask.isDone == true) {
        var taskIndexCom =
            state.completedTasks.indexOf(event.oldTask); // *** ds
        // completado
        completedTasks = List.from(completedTasks)
          ..remove(event.oldTask)
          ..insert(taskIndexCom, event.newTask);
      } else {
        var taskIndex = state.pendingTasks.indexOf(event.oldTask); // **** ds
        // pending tasks
        pendingTasks = List.from(pendingTasks)
          ..remove(event.oldTask)
          // ..insert(0, event.newTask),
          ..insert(taskIndex, event.newTask);
      }
    }
    emit(
      TasksState(
        /*
        pendingTasks: List.from(state.pendingTasks)
          ..remove(event.oldTask)
          // ..insert(0, event.newTask),
          ..insert(taskIndex, event.newTask),
          */
        //completedTasks: state.completedTasks..remove(event.oldTask),

        // ------------------- ds

        pendingTasks: pendingTasks,
        completedTasks: completedTasks,

        // ---

        favoriteTasks: favouriteTasks,
        removedTasks: state.removedTasks,
      ),
    );
  }
  // end edit

  //----------------------------------------------- restoreTask part 6 21.00
  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      removedTasks: List.from(state.removedTasks)..remove(event.task),
      pendingTasks: List.from(state.pendingTasks)
        ..insert(
            0,
            event.task.copyWith(
              isDeleted: false,
              isDone: false,
              isFavorite: false,
            )),
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
    ));
  }
  // end restore

  void _onDeleteAllTasks(DeleteAllTasks event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(
      TasksState(
        removedTasks: List.from(state.removedTasks)..clear(),
        pendingTasks: state.pendingTasks,
        completedTasks: state.completedTasks,
        favoriteTasks: state.favoriteTasks,
      ),
    );
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}
