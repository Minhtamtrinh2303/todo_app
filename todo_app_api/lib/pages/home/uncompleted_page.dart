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

class UncompletedPage extends StatefulWidget {
  const UncompletedPage({super.key});

  @override
  State<UncompletedPage> createState() => _UncompletedPageState();
}

class _UncompletedPageState extends State<UncompletedPage> {
  final searchController = TextEditingController();
  final editController = TextEditingController();
  final editFocus = FocusNode();
  bool isLoading = false;

  ///===========================///
  TaskServices taskServices = TaskServices();
  List<TaskModel>? tasks = [];
  List<TaskModel> tasksSearch = [];

  @override
  void initState() {
    super.initState();
    getListTaskUncompleted();
  }

  // Get List Task Uncompleted
  Future<void> getListTaskUncompleted() async {
    setState(() => isLoading = true);
    final query = {
      'status': StatusType.PROCESSING.name,
      'deleted': false,
    };
    taskServices.getListTask(queryParams: query).then((response) {
      if (response.isSuccess) {
        setState(() {
          isLoading = false;
          tasks = response.body?.docs ?? [];
          tasksSearch = tasks ?? [];
        });
      }
    }).catchError((onError) {
      setState(() => isLoading = false);
      showTopSnackBar(
        context,
        TDSnackBar.error(message: '$onError 😐'),
      );
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

        if (body.status == StatusType.DONE.name) {
          tasks?.removeWhere((element) => element.id == body.id);
          tasksSearch.removeWhere((element) => element.id == body.id);
        }

        setState(() {});
      }
    }).catchError((onError) {
      log('message $onError');
    });
  }

  // Delete Task
  Future<void> deleteTask(String id) async {
    taskServices.deleteTask(id).then((response) {
      if (response.isSuccess) {
        tasks?.removeWhere((element) => (element.id ?? '') == id);
        tasksSearch.removeWhere((element) => (element.id ?? '') == id);
        setState(() {});
      }
    }).catchError((onError) {
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TdSearchBox(
              controller: searchController,
              onChanged: (value) => setState(() => search(value)),
            ),
          ),
          const SizedBox(height: 16.0),
          const Divider(height: 2.0, color: AppColor.primary),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                getListTaskUncompleted();
              },
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (tasks ?? []).isEmpty && !isLoading
                      ? const Center(
                          child: Text(
                            'No task uncompleted',
                            style: TextStyle(
                                color: AppColor.brown, fontSize: 20.0),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 16.0),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: tasksSearch.length,
                              itemBuilder: ((context, index) {
                                final task =
                                    tasksSearch.reversed.toList()[index];
                                return Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.startToEnd,
                                  background: Container(
                                    color: Colors.green.withOpacity(0.46),
                                    child: const Icon(
                                        Icons.delete_outline_outlined,
                                        size: 32.0,
                                        color: Colors.yellow),
                                  ),
                                  secondaryBackground:
                                      Container(color: Colors.yellow),
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      deleteTask(task.id ?? '');
                                    }
                                  },
                                  child: CardTask(
                                    task: task,
                                    isEdit: task.isEditing,
                                    editController: editController,
                                    editFocus: editFocus,
                                    onTap: () async {
                                      bool? status = await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return TDDialog(
                                              title:
                                                  'Do you want to change task status?',
                                              subText:
                                                  'The task status will be changed',
                                              icon: Icons.question_mark,
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                            );
                                          });
                                      if (status ?? false) {
                                        final body = TaskBody()
                                          ..id = task.id
                                          ..name = task.name
                                          ..description = task.description
                                          ..status = StatusType.DONE.name;
                                        updateTask(body: body);
                                      }
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
                                  ),
                                );
                              }),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16.4),
                            ),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
