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

  AddTask({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class UpdateTask extends TasksEvent {
  final Task task;

  UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
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

  TaskActionSuccess({
    required this.tasks,
    required this.message,
    required this.actionType,
  });

  @override
  List<Object?> get props => [tasks, message, actionType];
}

enum ActionType {
  create,
  update,
  delete,
  toggle
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
    // Validate input
    if (event.title.trim().isEmpty) {
      emit(TasksError(
        message: 'Tiêu đề công việc không được để trống',
        errorType: ApiErrorType.validation,
      ));
      return;
    }
    
    emit(TasksLoading());
    
    final createResult = await repository.createTask(
      title: event.title,
      description: event.description,
    );
    
    await createResult.fold(
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
            message: 'Đã thêm công việc mới thành công',
            actionType: ActionType.create,
          ),
        ));
      },
    );
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TasksState> emit,
  ) async {
    // Validate input
    if (event.task.title.trim().isEmpty) {
      emit(TasksError(
        message: 'Tiêu đề công việc không được để trống',
        errorType: ApiErrorType.validation,
      ));
      return;
    }
    
    emit(TasksLoading());
    
    final updateResult = await repository.updateTask(event.task);
    
    await updateResult.fold(
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
            message: 'Đã cập nhật công việc thành công',
            actionType: ActionType.update,
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
} 