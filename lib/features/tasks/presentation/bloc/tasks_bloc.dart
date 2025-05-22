import 'dart:async';

import 'package:flutter/services.dart';
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
  addReminder,
  fetch
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

    // Thêm hiệu ứng haptic feedback
    HapticFeedback.mediumImpact();

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

        // Lấy danh sách tasks từ API
        print('*** _onAddTask: Calling repository.getTasks ***');
        final tasksResult = await repository.getTasks();
        print('*** _onAddTask: repository.getTasks returned ***');

        emit(tasksResult.fold(
          (failure) {
            print('*** _onAddTask: getTasks failed: ${failure.message} ***');
            // Nếu không lấy được danh sách tasks, trả về danh sách chỉ chứa task mới
            return TaskActionSuccess(
              tasks: [task],
              message: 'Đã thêm công việc mới thành công',
              actionType: ActionType.create,
              data: task,
            );
          },
          (apiTasks) {
            print('*** _onAddTask: getTasks succeeded, ${apiTasks.length} tasks ***');
            return TaskActionSuccess(
              tasks: apiTasks,
              message: 'Đã thêm công việc mới thành công',
              actionType: ActionType.create,
              data: task,
            );
          },
        ));
      },
    );
    print('*** _onAddTask: Completed ***');
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TasksState> emit,
  ) async {
    // Thêm hiệu ứng haptic feedback
    HapticFeedback.mediumImpact();

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
    print('*** _onDeleteTask: Event received ***');
    print('Task ID: ${event.taskId}');

    // Thêm hiệu ứng haptic feedback
    HapticFeedback.mediumImpact();

    // Lưu trữ trạng thái hiện tại để có thể khôi phục nếu có lỗi
    final currentState = state;
    List<Task> currentTasks = [];
    Task? deletedTask;

    // Lấy danh sách tasks hiện tại
    if (currentState is TasksLoaded) {
      print('*** _onDeleteTask: Current state is TasksLoaded ***');
      currentTasks = List.from(currentState.tasks);
      print('*** _onDeleteTask: Current tasks count: ${currentTasks.length} ***');
    } else if (currentState is TaskActionSuccess) {
      print('*** _onDeleteTask: Current state is TaskActionSuccess ***');
      currentTasks = List.from(currentState.tasks);
      print('*** _onDeleteTask: Current tasks count: ${currentTasks.length} ***');
    } else {
      print('*** _onDeleteTask: Current state is not TasksLoaded or TaskActionSuccess ***');
      // Nếu không có danh sách tasks, không thể thực hiện optimistic update
      print('*** _onDeleteTask: Emitting TasksLoading ***');
      emit(TasksLoading());

      print('*** _onDeleteTask: Calling repository.deleteTask ***');
      final deleteResult = await repository.deleteTask(event.taskId);
      print('*** _onDeleteTask: repository.deleteTask returned ***');

      await deleteResult.fold(
        (failure) async {
          print('*** _onDeleteTask: deleteTask failed: ${failure.message} ***');
          emit(TasksError(
            message: failure.message,
            errorType: failure.errorType,
            data: failure.data,
          ));
        },
        (_) async {
          print('*** _onDeleteTask: deleteTask succeeded ***');
          print('*** _onDeleteTask: Calling repository.getTasks ***');
          final tasksResult = await repository.getTasks();
          print('*** _onDeleteTask: repository.getTasks returned ***');

          emit(tasksResult.fold(
            (failure) {
              print('*** _onDeleteTask: getTasks failed: ${failure.message} ***');
              return TasksError(
                message: failure.message,
                errorType: failure.errorType,
                data: failure.data,
              );
            },
            (tasks) {
              print('*** _onDeleteTask: getTasks succeeded, ${tasks.length} tasks ***');
              return TaskActionSuccess(
                tasks: tasks,
                message: 'Đã xóa công việc thành công',
                actionType: ActionType.delete,
              );
            },
          ));
        },
      );
      print('*** _onDeleteTask: Completed (early return) ***');
      return;
    }

    // Tìm task cần xóa
    try {
      print('*** _onDeleteTask: Finding task to delete ***');
      deletedTask = currentTasks.firstWhere((task) => task.id == event.taskId);
      print('*** _onDeleteTask: Found task: ${deletedTask.title} ***');
    } catch (e) {
      // Nếu không tìm thấy task, báo lỗi
      print('*** _onDeleteTask: Task not found, emitting error ***');
      emit(TasksError(
        message: 'Không tìm thấy công việc cần xóa',
        errorType: ApiErrorType.notFound,
      ));
      return;
    }

    // Xóa task khỏi danh sách (optimistic update)
    print('*** _onDeleteTask: Removing task from list (optimistic update) ***');
    final updatedTasks = currentTasks.where((task) => task.id != event.taskId).toList();
    print('*** _onDeleteTask: Updated tasks count: ${updatedTasks.length} ***');

    // Emit trạng thái mới với task đã bị xóa
    print('*** _onDeleteTask: Emitting TaskActionSuccess with optimistic update ***');
    emit(TaskActionSuccess(
      tasks: updatedTasks,
      message: 'Đã xóa công việc',
      actionType: ActionType.delete,
      data: deletedTask, // Lưu task đã xóa để có thể hoàn tác
    ));

    // Gọi API để xóa task
    print('*** _onDeleteTask: Calling repository.deleteTask ***');
    final deleteResult = await repository.deleteTask(event.taskId);
    print('*** _onDeleteTask: repository.deleteTask returned ***');

    // Luôn gọi API để lấy danh sách tasks mới nhất sau khi xóa, bất kể thành công hay thất bại
    print('*** _onDeleteTask: Calling repository.getTasks after deletion attempt ***');
    final tasksResult = await repository.getTasks();
    print('*** _onDeleteTask: repository.getTasks returned ***');

    await deleteResult.fold(
      (failure) async {
        print('*** _onDeleteTask: deleteTask failed: ${failure.message} ***');

        // Emit kết quả từ API getTasks nếu có
        tasksResult.fold(
          (getTasksFailure) {
            print('*** _onDeleteTask: getTasks also failed: ${getTasksFailure.message} ***');
            // Nếu cả hai API đều thất bại, khôi phục lại trạng thái cũ
            if (currentState is TasksLoaded) {
              emit(TasksLoaded(currentTasks));
            } else if (currentState is TaskActionSuccess) {
              emit(TaskActionSuccess(
                tasks: currentTasks,
                message: 'Không thể xóa công việc',
                actionType: ActionType.delete,
                data: null,
              ));
            } else {
              emit(TasksError(
                message: failure.message,
                errorType: failure.errorType,
                data: failure.data,
              ));
            }
          },
          (tasks) {
            print('*** _onDeleteTask: getTasks succeeded despite deleteTask failure, ${tasks.length} tasks ***');
            // Nếu getTasks thành công, cập nhật UI với danh sách tasks mới nhất
            emit(TaskActionSuccess(
              tasks: tasks,
              message: 'Đã cập nhật danh sách công việc',
              actionType: ActionType.fetch,
            ));
          }
        );
      },
      (_) async {
        print('*** _onDeleteTask: deleteTask succeeded ***');
        // Emit kết quả từ API getTasks
        tasksResult.fold(
          (failure) {
            print('*** _onDeleteTask: getTasks failed: ${failure.message} ***');
            // Nếu không lấy được danh sách tasks, giữ nguyên trạng thái hiện tại
            emit(state);
          },
          (tasks) {
            print('*** _onDeleteTask: getTasks succeeded, ${tasks.length} tasks ***');
            emit(TaskActionSuccess(
              tasks: tasks,
              message: 'Đã xóa công việc thành công',
              actionType: ActionType.delete,
            ));
          },
        );
      },
    );
    print('*** _onDeleteTask: Completed ***');
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TasksState> emit,
  ) async {
    print('*** _onToggleTaskCompletion: Event received ***');
    print('Task ID: ${event.taskId}');

    // Thêm hiệu ứng haptic feedback
    HapticFeedback.mediumImpact();

    // Lấy trạng thái hiện tại của task và danh sách tasks
    Task? currentTask;
    List<Task> currentTasks = [];

    if (state is TasksLoaded) {
      currentTasks = List.from((state as TasksLoaded).tasks);
      try {
        currentTask = currentTasks.firstWhere((t) => t.id == event.taskId);
      } catch (e) {
        currentTask = null;
      }
    } else if (state is TaskActionSuccess) {
      currentTasks = List.from((state as TaskActionSuccess).tasks);
      try {
        currentTask = currentTasks.firstWhere((t) => t.id == event.taskId);
      } catch (e) {
        currentTask = null;
      }
    }

    if (currentTask != null) {
      print('*** _onToggleTaskCompletion: Current task found ***');
      print('Current completion status: ${currentTask.isCompleted}');

      // Optimistic update - cập nhật UI ngay lập tức
      final updatedTask = currentTask.copyWith(isCompleted: !currentTask.isCompleted);
      final taskIndex = currentTasks.indexWhere((t) => t.id == event.taskId);
      if (taskIndex != -1) {
        currentTasks[taskIndex] = updatedTask;

        // Emit trạng thái mới với task đã được cập nhật
        emit(TaskActionSuccess(
          tasks: currentTasks,
          message: updatedTask.isCompleted ? 'Đã hoàn thành công việc' : 'Đã đánh dấu chưa hoàn thành',
          actionType: ActionType.toggle,
          data: updatedTask,
        ));
      }
    } else {
      print('*** _onToggleTaskCompletion: Current task not found ***');
      // Nếu không tìm thấy task, emit loading state
      emit(TasksLoading());
    }

    try {
      print('*** _onToggleTaskCompletion: Calling repository.toggleTaskCompletion ***');
      final toggleResult = await repository.toggleTaskCompletion(event.taskId);
      print('*** _onToggleTaskCompletion: repository.toggleTaskCompletion returned ***');

      // Luôn gọi API để lấy danh sách tasks mới nhất sau khi toggle, bất kể thành công hay thất bại
      print('*** _onToggleTaskCompletion: Calling repository.getTasks after toggle attempt ***');
      final tasksResult = await repository.getTasks();
      print('*** _onToggleTaskCompletion: repository.getTasks returned ***');

      await toggleResult.fold(
        (failure) async {
          print('*** _onToggleTaskCompletion: toggleTaskCompletion failed: ${failure.message} ***');

          // Emit kết quả từ API getTasks nếu có
          tasksResult.fold(
            (getTasksFailure) {
              print('*** _onToggleTaskCompletion: getTasks also failed: ${getTasksFailure.message} ***');
              // Nếu cả hai API đều thất bại, emit lỗi
              emit(TasksError(
                message: failure.message,
                errorType: failure.errorType,
                data: failure.data,
              ));
            },
            (tasks) {
              print('*** _onToggleTaskCompletion: getTasks succeeded despite toggle failure, ${tasks.length} tasks ***');
              // Nếu getTasks thành công, cập nhật UI với danh sách tasks mới nhất
              emit(TaskActionSuccess(
                tasks: tasks,
                message: 'Đã cập nhật danh sách công việc',
                actionType: ActionType.fetch,
              ));
            }
          );
        },
        (updatedTask) async {
          print('*** _onToggleTaskCompletion: toggleTaskCompletion succeeded ***');
          print('*** _onToggleTaskCompletion: Updated task: ${updatedTask.id}, isCompleted: ${updatedTask.isCompleted} ***');

          // Sử dụng kết quả từ API getTasks đã gọi trước đó
          tasksResult.fold(
            (failure) {
              print('*** _onToggleTaskCompletion: getTasks failed: ${failure.message} ***');
              // Nếu không lấy được danh sách tasks, vẫn cập nhật UI với task đã cập nhật
              List<Task> updatedTasks = List.from(currentTasks);

              // Cập nhật task trong danh sách
              final taskIndex = updatedTasks.indexWhere((t) => t.id == updatedTask.id);
              if (taskIndex != -1) {
                updatedTasks[taskIndex] = updatedTask;
              } else {
                updatedTasks.add(updatedTask);
              }

              emit(TaskActionSuccess(
                tasks: updatedTasks,
                message: updatedTask.isCompleted ? 'Đã hoàn thành công việc' : 'Đã đánh dấu chưa hoàn thành',
                actionType: ActionType.toggle,
                data: updatedTask,
              ));
            },
            (tasks) {
              print('*** _onToggleTaskCompletion: getTasks succeeded, ${tasks.length} tasks ***');

              // Đảm bảo task đã cập nhật có trong danh sách
              final taskIndex = tasks.indexWhere((t) => t.id == updatedTask.id);
              if (taskIndex == -1) {
                print('*** _onToggleTaskCompletion: Updated task not found in tasks list, adding it ***');
                tasks.add(updatedTask);
              } else {
                print('*** _onToggleTaskCompletion: Updated task found in tasks list, updating it ***');
                // Đảm bảo task trong danh sách có trạng thái mới nhất
                tasks[taskIndex] = updatedTask;
              }

              emit(TaskActionSuccess(
                tasks: tasks,
                message: updatedTask.isCompleted ? 'Đã hoàn thành công việc' : 'Đã đánh dấu chưa hoàn thành',
                actionType: ActionType.toggle,
                data: updatedTask,
              ));
            },
          );
        },
      );
    } catch (e) {
      print('*** _onToggleTaskCompletion: Unexpected error: $e ***');

      // Nếu có lỗi không xác định, vẫn gọi API để lấy danh sách tasks mới nhất
      print('*** _onToggleTaskCompletion: Calling repository.getTasks after error ***');
      final tasksResult = await repository.getTasks();

      emit(tasksResult.fold(
        (failure) => TasksError(
          message: 'Không thể cập nhật trạng thái công việc: ${failure.message}',
          errorType: failure.errorType,
          data: failure.data,
        ),
        (tasks) => TaskActionSuccess(
          tasks: tasks,
          message: 'Đã cập nhật danh sách công việc',
          actionType: ActionType.fetch,
        ),
      ));
    }

    print('*** _onToggleTaskCompletion: Completed ***');
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
    print('*** _onUpdateSubTask: Event received ***');
    print('Task ID: ${event.taskId}, SubTask ID: ${event.subTaskId}');

    // Validate input
    if (event.title != null && event.title!.trim().isEmpty) {
      emit(TasksError(
        message: 'Tiêu đề công việc con không được để trống',
        errorType: ApiErrorType.validation,
      ));
      return;
    }

    // Thêm hiệu ứng haptic feedback
    HapticFeedback.mediumImpact();

    // Lấy trạng thái hiện tại của task và danh sách tasks
    Task? currentTask;
    List<Task> currentTasks = [];

    if (state is TasksLoaded) {
      currentTasks = List.from((state as TasksLoaded).tasks);
      try {
        currentTask = currentTasks.firstWhere((t) => t.id == event.taskId);
      } catch (e) {
        currentTask = null;
      }
    } else if (state is TaskActionSuccess) {
      currentTasks = List.from((state as TaskActionSuccess).tasks);
      try {
        currentTask = currentTasks.firstWhere((t) => t.id == event.taskId);
      } catch (e) {
        currentTask = null;
      }
    }

    // Optimistic update - cập nhật UI ngay lập tức nếu có thể
    if (currentTask != null && event.isCompleted != null) {
      print('*** _onUpdateSubTask: Current task found, performing optimistic update ***');

      // Tìm subtask cần cập nhật
      final subTaskIndex = currentTask.subTasks.indexWhere((st) => st.id == event.subTaskId);
      if (subTaskIndex != -1) {
        // Cập nhật subtask
        final updatedSubTasks = List<SubTask>.from(currentTask.subTasks);
        updatedSubTasks[subTaskIndex] = updatedSubTasks[subTaskIndex].copyWith(
          isCompleted: event.isCompleted,
          title: event.title,
          dueDate: event.dueDate,
        );

        // Cập nhật task với subtasks mới
        final updatedTask = currentTask.copyWith(subTasks: updatedSubTasks);

        // Cập nhật danh sách tasks
        final taskIndex = currentTasks.indexWhere((t) => t.id == event.taskId);
        if (taskIndex != -1) {
          currentTasks[taskIndex] = updatedTask;

          // Emit trạng thái mới với task đã được cập nhật
          emit(TaskActionSuccess(
            tasks: currentTasks,
            message: event.isCompleted != null && event.isCompleted!
                ? 'Đã hoàn thành công việc con'
                : 'Đã cập nhật công việc con',
            actionType: ActionType.updateSubTask,
            data: updatedTask,
          ));
        }
      }
    } else {
      // Nếu không thể thực hiện optimistic update, hiển thị loading
      emit(TasksLoading());
    }

    // Gọi API để cập nhật subtask
    print('*** _onUpdateSubTask: Calling repository.updateSubTask ***');
    final updateSubTaskResult = await repository.updateSubTask(
      event.taskId,
      event.subTaskId,
      title: event.title,
      isCompleted: event.isCompleted,
      dueDate: event.dueDate,
    );
    print('*** _onUpdateSubTask: repository.updateSubTask returned ***');

    await updateSubTaskResult.fold(
      (failure) async {
        print('*** _onUpdateSubTask: updateSubTask failed: ${failure.message} ***');
        emit(TasksError(
          message: failure.message,
          errorType: failure.errorType,
          data: failure.data,
        ));

        // Gọi API để lấy lại danh sách tasks chính xác
        final tasksResult = await repository.getTasks();
        emit(tasksResult.fold(
          (failure) => TasksError(
            message: failure.message,
            errorType: failure.errorType,
            data: failure.data,
          ),
          (tasks) => TasksLoaded(tasks),
        ));
      },
      (_) async {
        print('*** _onUpdateSubTask: updateSubTask succeeded ***');

        // Luôn gọi API để lấy danh sách tasks mới nhất
        print('*** _onUpdateSubTask: Calling repository.getTasks ***');
        final tasksResult = await repository.getTasks();
        print('*** _onUpdateSubTask: repository.getTasks returned ***');

        emit(tasksResult.fold(
          (failure) {
            print('*** _onUpdateSubTask: getTasks failed: ${failure.message} ***');
            return TasksError(
              message: failure.message,
              errorType: failure.errorType,
              data: failure.data,
            );
          },
          (tasks) {
            print('*** _onUpdateSubTask: getTasks succeeded, ${tasks.length} tasks ***');
            return TaskActionSuccess(
              tasks: tasks,
              message: event.isCompleted != null && event.isCompleted!
                  ? 'Đã hoàn thành công việc con'
                  : 'Đã cập nhật công việc con',
              actionType: ActionType.updateSubTask,
            );
          },
        ));
      },
    );

    print('*** _onUpdateSubTask: Completed ***');
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