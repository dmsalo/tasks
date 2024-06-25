part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class AddTask extends TasksEvent {
  final Task task;

  const AddTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TasksEvent {
  final Task task;

  const UpdateTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TasksEvent {
  final Task task;

  const DeleteTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

class RemoveTask extends TasksEvent {
  final Task task;

  const RemoveTask({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}

//---------------------- MarckFavorite
class MarkFavoriteOrUnFavoriteTask extends TasksEvent {
  final Task task;
  const MarkFavoriteOrUnFavoriteTask({required this.task});

  @override
  List<Object> get props => [task];
}

//---------------------- EditTask
class EditTask extends TasksEvent {
  final Task oldTask;
  final Task newTask;
  const EditTask({
    required this.oldTask,
    required this.newTask,
  });

  @override
  List<Object> get props => [oldTask, newTask];
}

//--------------------- TasksRestore
class RestoreTask extends TasksEvent {
  final Task task;

  const RestoreTask({required this.task});

  @override
  List<Object> get props => [task];
}

//-------------------- RestareAll
class DeleteAllTasks extends TasksEvent {}