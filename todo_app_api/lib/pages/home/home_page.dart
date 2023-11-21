import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:todo_app_api/components/dialog/td_dialog.dart';
import 'package:todo_app_api/components/snack_bar/td_snack_bar.dart';
import 'package:todo_app_api/components/snack_bar/top_snack_bar.dart';
import 'package:todo_app_api/components/td_search_box.dart';
import 'package:todo_app_api/models/task_model.dart';
import 'package:todo_app_api/pages/home/widget/card_task.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/remote/body/task_body.dart';
import 'package:todo_app_api/services/remote/task_services.dart';
import 'package:todo_app_api/utils/enum.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final addController = TextEditingController();
  final addFocus = FocusNode();
  final editController = TextEditingController();
  final editFocus = FocusNode();
  bool showAddBox = false;
  bool isLoading = false;
  bool isLoad = false;

  ///===========================///
  TaskServices taskServices = TaskServices();
  List<TaskModel>? tasks = [];
  List<TaskModel> tasksSearch = [];

  @override
  void initState() {
    super.initState();
    addController.addListener(() {
      setState(() {}); // lắng nghe và setState() khi TextField thay đổi
    });
    getTasks();
  }

  // Get List Task
  Future<void> getTasks() async {
    setState(() => isLoading = true);
    final query = {
      'deleted': false,
    };
    taskServices.getListTask(queryParams: query).then((response) {
      if (response.isSuccess) {
        isLoading = false;
        tasks = (response.body?.docs ?? []);
        tasksSearch = tasks ?? [];
        setState(() {});
      }
    }).catchError((onError) {
      setState(() => isLoading = false);
      showTopSnackBar(
        context,
        TDSnackBar.error(message: '$onError 😐'),
      );
    });
  }

  // Create Task
  Future<void> createTask() async {
    setState(() => isLoad = true);
    Timer(const Duration(milliseconds: 1600), () {
      final body = TaskBody()
        ..name = addController.text.trim()
        ..description = 'Hello World'
        ..status = StatusType.PROCESSING.name;
      taskServices.createTask(body).then((response) {
        if (response.isSuccess) {
          isLoad = false;
          tasks?.add(response.body ?? TaskModel());
          addController.clear();
          tasksSearch = [...tasks ?? []];
          searchController.clear();
          setState(() {});
          // addFocus.unfocus();
        }
      }).catchError((onError) {
        setState(() => isLoad = false);
        log('message $onError');
      });
    });
  }

  // Update Task
  Future<void> updateTask({required TaskBody body}) async {
    taskServices.updateTask(body).then((response) {
      if (response.isSuccess) {
        tasks?.singleWhere((element) => element.id == body.id)
          ?..name = body.name
          ..description = body.description
          ..status = body.status;
        tasksSearch.singleWhere((element) => element.id == body.id)
          ..name = body.name
          ..description = body.description
          ..status = body.status;
        setState(() {});
      }
    }).catchError((onError) {
      log('message $onError');
    });
  }

  // Delete Task Todo
  Future<void> deleteTask(String id) async {
    setState(() => isLoad = true);
    taskServices.deleteTask(id).then((response) {
      if (response.isSuccess) {
        isLoad = false;
        tasks?.removeWhere((element) => (element.id ?? '') == id);
        tasksSearch.removeWhere((element) => (element.id ?? '') == id);
        setState(() {});
      }
    }).catchError((onError) {
      setState(() => isLoad = false);
      log('message $onError');
    });
  }

  // Search Task
  void search(String value) {
    if (value.isEmpty) {
      setState(() {
        tasksSearch = tasks ?? [];
      });
      return;
    }
    setState(() {
      tasksSearch = (tasks ?? [])
          .where((element) =>
              (element.name ?? '').toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TdSearchBox(
                    controller: searchController,
                    onChanged: search,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Divider(height: 2.0, color: AppColor.primary),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getTasks();
                    },
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (tasks ?? []).isEmpty && !isLoading
                            ? const Center(
                                child: Text(
                                  'Tasks is empty',
                                  style: TextStyle(
                                      color: AppColor.brown, fontSize: 20.0),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ).copyWith(top: 16.0, bottom: 86.0),
                                itemCount: tasksSearch.length,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  final task = tasksSearch[index];
                                  return CardTask(
                                    task: task,
                                    isEdit: task.isEditing,
                                    editController: editController,
                                    editFocus: editFocus,
                                    onTap: () {
                                      final body = TaskBody()
                                        ..id = task.id
                                        ..name = task.name
                                        ..description = task.description
                                        ..status =
                                            task.status == StatusType.DONE.name
                                                ? StatusType.PROCESSING.name
                                                : StatusType.DONE.name;
                                      updateTask(body: body);
                                    },
                                    onEdit: () {
                                      setState(() {
                                        // close all edit task before open new edit task
                                        tasks?.forEach((element) {
                                          element.isEditing = false;
                                        });
                                        task.isEditing = true;
                                        editController.text = task.name ?? '';
                                        editFocus.requestFocus();
                                      });
                                    },
                                    onSave: () {
                                      final body = TaskBody()
                                        ..id = task.id
                                        ..name = editController.text.trim()
                                        ..description = task.description
                                        ..status = task.status;
                                      updateTask(body: body);
                                      setState(() {
                                        task.isEditing = false;
                                      });
                                    },
                                    onCancel: () {
                                      setState(() {
                                        task.isEditing = false;
                                      });
                                    },
                                    onDeleted: () async {
                                      bool? status = await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return TDDialog(
                                              title:
                                                  'Do you want to delete this task?',
                                              subText:
                                                  'The task will be moved to the deleted task list',
                                              icon: Icons.delete,
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                            );
                                          });
                                      if (status ?? false) {
                                        deleteTask(task.id ?? '');
                                      }
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16.0),
                              ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 12.0,
            child: Row(
              children: [
                Expanded(child: _addBox()),
                const SizedBox(width: 16.0),
                GestureDetector(
                  onTap: isLoad
                      ? null
                      : () {
                          showAddBox = !showAddBox;
                          if (showAddBox) {
                            addFocus.requestFocus();
                          }
                          if (addController.text.isNotEmpty) {
                            createTask();
                            FocusScope.of(context).unfocus();
                          }
                          setState(() {});
                        },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.shadow,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: isLoad
                        ? const Center(
                            child: SizedBox.square(
                            dimension: 32.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: AppColor.white,
                            ),
                          ))
                        : Icon(
                            addController.text.isEmpty
                                ? Icons.add
                                : Icons.check,
                            size: 32.0,
                            color: AppColor.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addBox() {
    return AnimatedScale(
      scale: showAddBox ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.6, vertical: 3.6),
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(color: AppColor.orange, width: 1.2),
          borderRadius: BorderRadius.circular(8.6),
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadow,
              offset: Offset(0.0, 3.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: TextField(
          controller: addController,
          focusNode: addFocus,
          onChanged: (value) {},
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Add a new todo item',
            hintStyle: TextStyle(color: AppColor.grey),
          ),
        ),
      ),
    );
  }
}
