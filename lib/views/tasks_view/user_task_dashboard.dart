import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/views/group_view/group_view_model.dart';
import 'package:work_flow/views/jobs_view/info_job.dart';
import 'package:work_flow/views/workflows_view/workflow_view.dart';
import 'package:http/http.dart' as http;

class UserTaskDashboard extends StatefulWidget {
  const UserTaskDashboard({super.key});

  @override
  State<UserTaskDashboard> createState() => _UserTaskDashboardState();
}

class _UserTaskDashboardState extends State<UserTaskDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _tasks = [];

  Future<void> _loadTasks() async {
    final token = await _getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/job/getAll'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _tasks = jsonData;
        });
      } else if (response.statusCode == 401) {
        // Token hết hạn, thử làm mới token và gửi lại yêu cầu
        print('Token expired, refreshing...');
        final data = jsonDecode(response.body);

        if (data.containsKey('token')) {
          await _setToken(data['token']); // Lưu lại token mới
          _loadTasks(); // Thử lại sau khi có token mới
        } else {
          print('Failed to refresh token');
        }
      } else {
        print('Failed to load tasks: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _setToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('token')) {
      await prefs.remove('token');
    }
    await prefs.setString('token', newToken);

    print("Token mới đã được lưu thành công: $newToken");
  }

  @override
  void initState() {
    _loadTasks();
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;
  var items = [
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Task',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Container(
            child: PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tạo workflow'),
                      const Icon(Icons.table_chart_outlined),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateWorkflow(),
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tạo Groups'),
                      const Icon(Icons.card_travel_outlined),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyGroups(
                          groupId: null,
                        ),
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tạo Project'),
                      const Icon(Icons.table_chart_outlined),
                    ],
                  ),
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => Project(),
                  //     ),
                  //   );
                  // },
                ),
              ],
            ),
          ),
        ],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.grey[200],
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColor.yellowColor,
              tabs: const [
                Tab(text: 'Hôm nay'),
                Tab(text: 'Hôm qua'),
                Tab(text: 'Tuần này'),
                Tab(text: 'Của tôi'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatusChip(label: 'To Do', color: Colors.orange),
                  StatusChip(label: 'In Progress', color: Colors.blue),
                  StatusChip(label: 'Review UAT', color: Colors.grey),
                  StatusChip(label: 'Done UAT', color: Colors.green),
                  StatusChip(label: 'Bug UAT', color: Colors.red),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '2 To Do',
                style: TextStyle(
                    color: AppColor.blackColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final nameTask = task['NameJob'] ?? 'No title';
                final timeStart = DateTime.parse(task['TimeStart']);
                final timeComplete = DateTime.parse(task['TimeComplete']);
                final formattedDate =
                    '${timeStart.day}-${timeStart.month}/${timeComplete.day}-${timeComplete.month}';
                final priority = task['Priority'] ?? 'Low';
                final priorityColor = priority == 'High'
                    ? Colors.red.shade100
                    : Colors.green.shade100;
                final letterColor = priority == 'High'
                    ? AppColor.redColor
                    : AppColor.greenColor;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoJob(jobId: task['IDJob']),
                      ),
                    );
                  },
                  child: TaskCard(
                    title: nameTask,
                    date: formattedDate,
                    priority: priority,
                    letterColor: letterColor,
                    priorityColor: priorityColor,
                    taskNumber: '[${task['IDJob']}]',
                    appName: 'MICXM/FieldSale App',
                  ),
                );
              },
            ),
          )
        ],
      ),
      // floatingActionButtonLocation: selectedfABLocation,
      // floatingActionButton: SpeedDial(
      //   icon: Icons.add,
      //   activeIcon: Icons.close,
      //   spacing: 3,
      //   mini: mini,
      //   openCloseDial: isDialOpen,
      //   childPadding: const EdgeInsets.all(8),
      //   spaceBetweenChildren: 4,
      //   dialRoot: customDialRoot
      //       ? (ctx, open, toggleChildren) {
      //           return ElevatedButton(
      //             onPressed: toggleChildren,
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: Colors.blue[900],
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 22, vertical: 18),
      //             ),
      //             child: const Text(
      //               "Custom Dial Root",
      //               style: TextStyle(fontSize: 17),
      //             ),
      //           );
      //         }
      //       : null,
      //   buttonSize: buttonSize,
      //   label: extend ? const Text("Open") : null,
      //   activeLabel: extend ? const Text("Close") : null,
      //   childrenButtonSize: childrenButtonSize,
      //   visible: visible,
      //   direction: speedDialDirection,
      //   switchLabelPosition: switchLabelPosition,
      //   closeManually: closeManually,
      //   renderOverlay: renderOverlay,
      //   useRotationAnimation: useRAnimation,
      //   tooltip: 'Open Speed Dial',
      //   heroTag: 'speed-dial-hero-tag',
      //   elevation: 8.0,
      //   animationCurve: Curves.elasticInOut,
      //   isOpenOnStart: false,
      //   shape: customDialRoot
      //       ? const RoundedRectangleBorder()
      //       : const StadiumBorder(),
      //   children: [
      //     SpeedDialChild(
      //       child: !rmicons ? const Icon(Icons.group_sharp) : null,
      //       backgroundColor: AppColor.primaryColor,
      //       foregroundColor: Colors.white,
      //       labelWidget: Container(
      //         width: 100,
      //         padding: const EdgeInsets.symmetric(vertical: 8),
      //         decoration: BoxDecoration(
      //           color: Colors.grey[300],
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //         child: const Center(
      //           child: Text(
      //             'Groups',
      //             style: TextStyle(color: Colors.black),
      //           ),
      //         ),
      //       ),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => MyGroups(
      //               groupId: context,
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: !rmicons
      //           ? const Icon(Icons.playlist_add_check_circle_outlined)
      //           : null,
      //       backgroundColor: AppColor.primaryColor,
      //       foregroundColor: Colors.white,
      //       labelWidget: Container(
      //         width: 100,
      //         padding: const EdgeInsets.symmetric(vertical: 8),
      //         decoration: BoxDecoration(
      //           color: Colors.grey[300],
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //         child: const Center(
      //           child: Text(
      //             'Workflows',
      //             style: TextStyle(color: Colors.black),
      //           ),
      //         ),
      //       ),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => CreateWorkflow(),
      //           ),
      //         );
      //       },
      //     ),
      //     SpeedDialChild(
      //         child: !rmicons ? const Icon(Icons.task_outlined) : null,
      //         backgroundColor: AppColor.primaryColor,
      //         foregroundColor: Colors.white,
      //         labelWidget: Container(
      //           width: 100,
      //           padding: const EdgeInsets.symmetric(vertical: 8),
      //           decoration: BoxDecoration(
      //             color: Colors.grey[300],
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           child: const Center(
      //             child: Text(
      //               'Create Tasks',
      //               style: TextStyle(color: Colors.black),
      //             ),
      //           ),
      //         ),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => CreateTask(),
      //             ),
      //         );
      //        }),
      // SpeedDialChild(
      //     child: !rmicons ? const Icon(Icons.task_outlined) : null,
      //     backgroundColor: AppColor.primaryColor,
      //     foregroundColor: Colors.white,
      //     labelWidget: Container(
      //       width: 100,
      //       padding: const EdgeInsets.symmetric(vertical: 8),
      //       decoration: BoxDecoration(
      //         color: Colors.grey[300],
      //         borderRadius: BorderRadius.circular(8),
      //       ),
      //       child: const Center(
      //         child: Text(
      //           ' Create tasks',
      //           style: TextStyle(color: Colors.black),
      //         ),
      //       ),
      //     ),
      //     visible: true,
      //     onTap: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => CreateTask(),
      //         ),
      //       );
      //     }),

      //     ],

      //   ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text(label, style: const TextStyle(color: Colors.white)),
        backgroundColor: color.withOpacity(1),
        labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String date;
  final String priority;
  final Color priorityColor;
  final Color letterColor;
  final String taskNumber;
  final String appName;

  TaskCard({
    required this.title,
    required this.date,
    required this.priority,
    required this.letterColor,
    required this.priorityColor,
    required this.taskNumber,
    required this.appName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(date, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              // const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                      color: letterColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('lib/images/user.png'),
                      radius: 16,
                    ),
                    const SizedBox(width: 5),
                    const CircleAvatar(
                      backgroundImage: AssetImage('lib/images/user.png'),
                      radius: 16,
                    ),
                    const SizedBox(width: 5),
                    const CircleAvatar(
                      backgroundImage: AssetImage('lib/images/user.png'),
                      radius: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '3+',
                      style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(taskNumber,
                    style: const TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          Text(appName, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

extension EnumExt on FloatingActionButtonLocation {
  String get value => toString().split(".")[1];
}
