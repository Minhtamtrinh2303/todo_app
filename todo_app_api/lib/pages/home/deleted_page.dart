import 'package:flutter/material.dart';
import 'package:todo_app_api/components/button/td_elevated_button.dart';
import 'package:todo_app_api/components/dialog/td_dialog.dart';
import 'package:todo_app_api/components/snack_bar/td_snack_bar.dart';
import 'package:todo_app_api/components/snack_bar/top_snack_bar.dart';
import 'package:todo_app_api/models/task_model.dart';
import 'package:todo_app_api/pages/home/widget/card_task.dart';
import 'package:todo_app_api/resources/app_color.dart';
import 'package:todo_app_api/services/remote/body/delete_task_body.dart';
import 'package:todo_app_api/services/remote/task_services.dart';
import 'package:todo_app_api/utils/enum.dart';

class DeletedPage extends StatefulWidget {
  const DeletedPage({super.key});

  @override
  State<DeletedPage> createState() => _DeletedPageState();
}

class _DeletedPageState extends State<DeletedPage> {
  TaskServices taskServices = TaskServices();
  List<TaskModel>? tasks;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getListTaskDeleted();
  }

  // Get List Deleted Task
  Future<void> getListTaskDeleted() async {
    setState(() => isLoading = true);
    final query = {
      'deleted': true,
    };
    taskServices.getListTask(queryParams: query).then((response) {
      if (response.isSuccess) {
        setState(() {
          isLoading = false;
          tasks = response.body?.docs ?? [];
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

  // Delete Task
  Future<void> deleteMultipleTask(DeleteTaskBody body) async {
    taskServices.deleteMultipleTask(body).then((response) {
      if (response.isSuccess) {
        getListTaskDeleted();
      }
    }).catchError((onError) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: '$onError 😐'),
      );
    });
  }

  // Restore Task
  Future<void> restoreMultipleTask(DeleteTaskBody body) async {
    taskServices.restoreMultipleTask(body).then((response) {
      if (response.isSuccess) {
        getListTaskDeleted();
      }
    }).catchError((onError) {
      showTopSnackBar(
        context,
        TDSnackBar.error(message: '$onError 😐'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TdElevatedButton.small(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return TDDialog(
                      title: 'Restore all task',
                      subText: 'Do you want to restore all task?',
                      icon: Icons.restore,
                      onPressed: () {
                        restoreMultipleTask(
                          DeleteTaskBody()..type = TaskType.RESTORE_ALL.name,
                        );
                        Navigator.pop(context, true);
                      },
                    );
                  },
                );
              },
              color: AppColor.white,
              borderColor: AppColor.green,
              text: 'Restore All',
              textColor: AppColor.green,
              icon: const Icon(
                Icons.restore,
                size: 18.0,
                color: AppColor.green,
              ),
            ),
            TdElevatedButton.small(
              onPressed: () {
                tasks?.forEach((element) => element.isConfirmDelete = false);
                setState(() {});
                showDialog(
                  context: context,
                  builder: (context) {
                    return TDDialog(
                      title: 'Permanently delete',
                      subText:
                          'Do you want to permanently delete the task list?',
                      icon: Icons.delete,
                      onPressed: () {
                        deleteMultipleTask(
                          DeleteTaskBody()..type = TaskType.DELETE_ALL.name,
                        );
                        Navigator.pop(context, true);
                      },
                    );
                  },
                );
              },
              color: AppColor.white,
              borderColor: AppColor.red,
              text: 'Delete All',
              textColor: AppColor.red,
              icon: const Icon(
                Icons.delete,
                size: 18.0,
                color: AppColor.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        const Divider(height: 1.2, color: AppColor.primary),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              getListTaskDeleted();
            },
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : (tasks ?? []).isEmpty && !isLoading
                    ? const Center(
                        child: Text(
                          'No task deleted',
                          style:
                              TextStyle(color: AppColor.brown, fontSize: 20.0),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        itemCount: (tasks ?? []).length,
                        itemBuilder: ((context, index) {
                          final task = (tasks ?? []).reversed.toList()[index];
                          return Row(
                            children: [
                              // if (task.isEditing)
                              //   Checkbox(
                              //     value: task.isEditing,
                              //     onChanged: (value) {
                              //       setState(() {
                              //         task.isEditing = value ?? false;
                              //       });
                              //     },
                              //     activeColor: AppColor.green,
                              //     checkColor: AppColor.white,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(4.0),
                              //     ),
                              //     // remove padding
                              //     materialTapTargetSize:
                              //         MaterialTapTargetSize.shrinkWrap,
                              //   ),
                              Expanded(
                                child: CardTask(
                                  task: task,
                                  onRestore: () {
                                    tasks?.forEach((element) =>
                                        element.isConfirmDelete = false);
                                    setState(() {});
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return TDDialog(
                                          title: 'Restore Task',
                                          subText:
                                              'Do you want to restore this task?',
                                          icon: Icons.restore,
                                          onPressed: () {
                                            restoreMultipleTask(
                                              DeleteTaskBody()
                                                ..ids = [task.id ?? ''],
                                            );
                                            Navigator.pop(context, true);
                                          },
                                        );
                                      },
                                    );
                                  },
                                  onDeleted: () {
                                    tasks?.forEach((element) =>
                                        element.isConfirmDelete = false);
                                    setState(() {});
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return TDDialog(
                                          title: 'Delete Task',
                                          subText:
                                              'Do you want to delete this task?',
                                          icon: Icons.delete,
                                          onPressed: () {
                                            deleteMultipleTask(
                                              DeleteTaskBody()
                                                ..ids = [task.id ?? ''],
                                            );
                                            Navigator.pop(context, true);
                                          },
                                        );
                                      },
                                    );
                                  },
                                  onHorizontalDragEnd: (details) {
                                    tasks?.forEach((element) =>
                                        element.isConfirmDelete = false);
                                    task.isConfirmDelete = true;
                                    setState(() {});
                                  },
                                  onConfirmYes: () async {
                                    deleteMultipleTask(
                                      DeleteTaskBody()..ids = [task.id ?? ''],
                                    );
                                    setState(() {});
                                  },
                                  onConfirmNo: () {
                                    task.isConfirmDelete = false;
                                    setState(() {});
                                  },
                                  onLongPress: () =>
                                      setState(() => task.isEditing = true),
                                ),
                              ),
                            ],
                          );
                        }),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16.4),
                      ),
          ),
        ),
      ],
    );
  }
}
