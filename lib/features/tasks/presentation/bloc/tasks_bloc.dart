import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart' hide Task;
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/api_error_type.dart';

// Events
abstract class TasksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTasks extends TasksEvent {}

class AddTask extends TasksEvent {
  final String title;
  final String description;
  final DateTime? dueDate;
  final TaskPriority? priority;
  final String? category;
  final List<String>? tags;

  AddTask({
    required this.title,
    required this.description,
    this.dueDate,
    this.priority,
    this.category,
    this.tags,
  });

  @override
  List<Object?> get props => [title, description, dueDate, priority, category, tags];
}

class UpdateTask extends TasksEvent {
  final String id;
  final String? title;
  final String? description;
  final bool? isCompleted;
  final DateTime? dueDate;
  final TaskPriority? priority;
  final String? category;
  final List<String>? tags;

  UpdateTask({
    required this.id,
    this.title,
    this.description,
    this.isCompleted,
    this.dueDate,
    this.priority,
    this.category,
    this.tags,
  });

  @override
  List<Object?> get props => [id, title, description, isCompleted, dueDate, priority, category, tags];
}

class DeleteTask extends TasksEvent {
  final String taskId;

  DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompletion extends TasksEvent {
  final String taskId;

  ToggleTaskCompletion(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class AddSubTask extends TasksEvent {
  final String taskId;
  final String title;
  final DateTime? dueDate;

  AddSubTask({
    required this.taskId,
    required this.title,
    this.dueDate,
  });

  @override
  List<Object?> get props => [taskId, title, dueDate];
}

class UpdateSubTask extends TasksEvent {
  final String taskId;
  final String subTaskId;
  final String? title;
  final bool? isCompleted;
  final DateTime? dueDate;

  UpdateSubTask({
    required this.taskId,
    required this.subTaskId,
    this.title,
    this.isCompleted,
    this.dueDate,
  });

  @override
  List<Object?> get props => [taskId, subTaskId, title, isCompleted, dueDate];
}

class AddReminder extends TasksEvent {
  final String taskId;
  final String message;
  final DateTime time;
  final String type;

  AddReminder({
    required this.taskId,
    required this.message,
    required this.time,
    this.type = 'push',
  });

  @override
  List<Object?> get props => [taskId, message, time, type];
}

// States
abstract class TasksState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;

  TasksLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskActionSuccess extends TasksState {
  final List<Task> tasks;
  final String message;
  final ActionType actionType;
  final dynamic data;

  TaskActionSuccess({
    required this.tasks,
    required this.message,
    required this.actionType,
    this.data,
  });

  @override
  List<Object?> get props => [tasks, message, actionType, data];
}

enum ActionType {
  create,
  update,
  delete,
  toggle,
  addSubTask,
  updateSubTask,
  addReminder
}

class TasksError extends TasksState {
  final String message;
  final ApiErrorType? errorType;
  final dynamic data;

  TasksError({
    required this.message,
    this.errorType,
    this.data,
  });

  @override
  List<Object?> get props => [message, errorType, data];

  // Helper method to get user-friendly message
  String get userFriendlyMessage {
    if (errorType == null) return message;

    switch (errorType) {
      case ApiErrorType.network:
        return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet và thử lại.';
      case ApiErrorType.server:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      case ApiErrorType.auth:
        return 'Lỗi xác thực. Vui lòng đăng nhập lại.';
      case ApiErrorType.validation:
        return message; // Giữ nguyên thông báo gốc cho lỗi xác thực dữ liệu
      case ApiErrorType.notFound:
        return 'Không tìm thấy công việc yêu cầu.';
      case ApiErrorType.timeout:
        return 'Yêu cầu đã hết thời gian. Vui lòng thử lại.';
      case ApiErrorType.cors:
        return 'Lỗi CORS. Máy chủ không cho phép truy cập từ ứng dụng này.';
      case ApiErrorType.unknown:
      default:
        return message;
    }
  }
}

// Bloc
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository repository;

  TasksBloc({required this.repository}) : super(TasksInitial()) {
    on<FetchTasks>(_onFetchTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<AddSubTask>(_onAddSubTask);
    on<UpdateSubTask>(_onUpdateSubTask);
    on<AddReminder>(_onAddReminder);
  }

  Future<void> _onFetchTasks(
    FetchTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());
    final result = await repository.getTasks();

    emit(result.fold(
      (failure) => TasksError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data,
      ),
      (tasks) => TasksLoaded(tasks),
    ));
  }

  Future<void> _onAddTask(
    AddTask event,
    Emitter<TasksState> emit,
  ) async {
    print('*** _onAddTask: Event received ***');
    print('Title: ${event.title}');
    print('Description: ${event.description}');
    print('Due Date: ${event.dueDate}');
    print('Priority: ${event.priority}');
    print('Category: ${event.category}');
    print('Tags: ${event.tags}');

    // Validate input
    if (event.title.trim().isEmpty) {
      print('*** _onAddTask: Title is empty, emitting error ***');
      emit(TasksError(
        message: 'Tiêu đề công việc không được để trống',
        errorType: ApiErrorType.validation,
      ));
      return;
    }

    print('*** _onAddTask: Emitting TasksLoading ***');
    emit(TasksLoading());

    print('*** _onAddTask: Calling repository.createTask ***');
    final createResult = await repository.createTask(
      title: event.title,
      description: event.description,
      dueDate: event.dueDate,
      priority: event.priority,
      category: event.category,
      tags: event.tags,
    );
    print('*** _onAddTask: repository.createTask returned ***');

    await createResult.fold(
      (failure) async {
        print('*** _onAddTask: createTask failed: ${failure.message} ***');
        emit(TasksError(
          message: failure.message,
          errorType: failure.errorType,
          data: failure.data,
        ));
      },
      (task) async {
        print('*** _onAddTask: createTask succeeded, task ID: ${task.id} ***');

        // Tạo danh sách tasks chứa task mới
        final List<Task> tasks = [task];

        // Thử lấy danh sách tasks từ API (nhưng không phụ thuộc vào kết quả)
        print('*** _onAddTask: Calling repository.getTasks ***');
        final tasksResult = await repository.getTasks();
        print('*** _onAddTask: repository.getTasks returned ***');

        // Nếu lấy danh sách tasks thành công, sử dụng danh sách đó
        // Nếu không, sử dụng danh sách chỉ chứa task mới
        final List<Task> finalTasks = tasksResult.fold(
          (failure) {
            print('*** _onAddTask: getTasks failed: ${failure.message} ***');
            print('*** _onAddTask: Using only the new task ***');
            return tasks;
          },
          (apiTasks) {
            print('*** _onAddTask: getTasks succeeded, ${apiTasks.length} tasks ***');
            // Nếu API trả về danh sách rỗng, sử dụng danh sách chỉ chứa task mới
            if (apiTasks.isEmpty) {
              print('*** _onAddTask: API returned empty list, using only the new task ***');
              return tasks;
            }
            return apiTasks;
          },
        );

        emit(TaskActionSuccess(
          tasks: finalTasks,
          message: 'Đã thêm công việc mới thành công',
          actionType: ActionType.create,
          data: task,
        ));
      },
    );
    print('*** _onAddTask: Completed ***');
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TasksState> emit,
  ) async {
    // Validate input
    if (event.title != null && event.title!.trim().isEmpty) {
      emit(TasksError(
        message: 'Tiêu đề công việc không được để trống',
        errorType: ApiErrorType.validation,
      ));
      return;
    }

    emit(TasksLoading());

    final updateResult = await repository.updateTask(
      event.id,
      title: event.title,
      description: event.description,
      isCompleted: event.isCompleted,
      dueDate: event.dueDate,
      priority: event.priority,
      category: event.category,
      tags: event.tags,
    );

    await updateResult.fold(
      (failure) async => emit(TasksError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data,
      )),
      (task) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(
            message: failure.message,
            errorType: failure.errorType,
            data: failure.data,
          ),
          (tasks) => TaskActionSuccess(
            tasks: tasks,
            message: 'Đã cập nhật công việc thành công',
            actionType: ActionType.update,
            data: task,
          ),
        ));
      },
    );
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());

    final deleteResult = await repository.deleteTask(event.taskId);

    await deleteResult.fold(
      (failure) async => emit(TasksError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data,
      )),
      (_) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(
            message: failure.message,
            errorType: failure.errorType,
            data: failure.data,
          ),
          (tasks) => TaskActionSuccess(
            tasks: tasks,
            message: 'Đã xóa công việc thành công',
            actionType: ActionType.delete,
          ),
        ));
      },
    );
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());

    final toggleResult = await repository.toggleTaskCompletion(event.taskId);

    await toggleResult.fold(
      (failure) async => emit(TasksError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data,
      )),
      (_) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(
            message: failure.message,
            errorType: failure.errorType,
            data: failure.data,
          ),
          (tasks) => TaskActionSuccess(
            tasks: tasks,
            message: 'Đã cập nhật trạng thái công việc',
            actionType: ActionType.toggle,
          ),
        ));
      },
    );
  }

  Future<void> _onAddSubTask(
    AddSubTask event,
    Emitter<TasksState> emit,
  ) async {
    // Validate input
    if (event.title.trim().isEmpty) {
      emit(TasksError(
        message: 'Tiêu đề công việc con không được để trống',
        errorType: ApiErrorType.validation,
      ));
      return;
    }

    emit(TasksLoading());

    final addSubTaskResult = await repository.addSubTask(
      event.taskId,
      title: event.title,
      dueDate: event.dueDate,
    );

    await addSubTaskResult.fold(
      (failure) async => emit(TasksError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data,
      )),
      (subTask) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(
            message: failure.message,
            errorType: failure.errorType,
            data: failure.data,
          ),
          (tasks) => TaskActionSuccess(
            tasks: tasks,
            message: 'Đã thêm công việc con thành công',
            actionType: ActionType.addSubTask,
            data: subTask,
          ),
        ));
      },
    );
  }

  Future<void> _onUpdateSubTask(
    UpdateSubTask event,
    Emitter<TasksState> emit,
  ) async {
    // Validate input
    if (event.title != null && event.title!.trim().isEmpty) {
      emit(TasksError(
        message: 'Tiêu đề công việc con không được để trống',
        errorType: ApiErrorType.validation,
      ));
      return;
    }

    emit(TasksLoading());

    final updateSubTaskResult = await repository.updateSubTask(
      event.taskId,
      event.subTaskId,
      title: event.title,
      isCompleted: event.isCompleted,
      dueDate: event.dueDate,
    );

    await updateSubTaskResult.fold(
      (failure) async => emit(TasksError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data,
      )),
      (_) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(
            message: failure.message,
            errorType: failure.errorType,
            data: failure.data,
          ),
          (tasks) => TaskActionSuccess(
            tasks: tasks,
            message: 'Đã cập nhật công việc con thành công',
            actionType: ActionType.updateSubTask,
          ),
        ));
      },
    );
  }

  Future<void> _onAddReminder(
    AddReminder event,
    Emitter<TasksState> emit,
  ) async {
    // Validate input
    if (event.message.trim().isEmpty) {
      emit(TasksError(
        message: 'Nội dung nhắc nhở không được để trống',
        errorType: ApiErrorType.validation,
      ));
      return;
    }

    emit(TasksLoading());

    final addReminderResult = await repository.addReminder(
      event.taskId,
      message: event.message,
      time: event.time,
      type: event.type,
    );

    await addReminderResult.fold(
      (failure) async => emit(TasksError(
        message: failure.message,
        errorType: failure.errorType,
        data: failure.data,
      )),
      (reminder) async {
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(
            message: failure.message,
            errorType: failure.errorType,
            data: failure.data,
          ),
          (tasks) => TaskActionSuccess(
            tasks: tasks,
            message: 'Đã thêm nhắc nhở thành công',
            actionType: ActionType.addReminder,
            data: reminder,
          ),
        ));
      },
    );
  }
}