import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/views/group_view/group_view_model.dart';
import 'package:work_flow/views/jobs_view/info_job.dart';
import 'package:work_flow/views/tasks_view/create_task.dart';
import 'package:work_flow/views/workflows_view/workflow_view.dart';
import 'package:http/http.dart' as http;

class MyTaskDashBoard extends StatefulWidget {
  const MyTaskDashBoard({super.key});

  @override
  State<MyTaskDashBoard> createState() => _MyTaskDashBoardState();
}

class _MyTaskDashBoardState extends State<MyTaskDashBoard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _tasks = [];
  List<dynamic> _tasksInMy = [];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    _fetchJobs(context);
    _fetchJobsMy(context);
  }

  void _handleTabSelection() {
    switch (_tabController.index) {
      case 0:
        selectedTime = 'day';
        break;
      case 1:
        selectedTime = 'previousDay';
        break;
      case 2:
        selectedTime = 'week';
        break;
    }
    _fetchJobs(context,
        selectedTime: selectedTime, selectedStatus: selectedStatus);
    _fetchJobsMy(context, selectedStatus: selectedStatus);
  }

  Future<void> _fetchJobs(BuildContext context,
      {String selectedTime = 'day', String selectedStatus = 'to-do'}) async {
    final token = await _getToken();
    final refreshToken = await _getRefreshToken();
    final pref = await SharedPreferences.getInstance();
    final int? userId = pref.getInt('IDUser');

    if (token != null && userId != null) {
      String url =
          '$baseUrl/job/getJobsToTimeAndStatus/$userId?period=$selectedTime&status=$selectedStatus';
      print("url fetchJob: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("responsee: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _tasks = jsonData['data']['jobs'];
        });
      } else if (response.statusCode == 401) {
        print('Access Token hết hạn. Gọi API refreshToken...');

        final refreshResponse = await http.post(
          Uri.parse('$baseUrl/common/refreshToken'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        );

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          if (refreshData.containsKey('accessToken')) {
            await _updateToken(refreshData['accessToken']);
            print('Access Token mới đã được cập nhật.');
            return _fetchJobs(context,
                selectedTime: selectedTime, selectedStatus: selectedStatus);
          } else {
            throw Exception('API refreshToken không trả về accessToken.');
          }
        } else {
          throw Exception(
              'Failed to refresh token. Status code: ${refreshResponse.statusCode}');
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } else {
      print('Token hoặc IDUser không tồn tại. Đăng nhập lại...');
    }
  }

  Future<void> _fetchJobsMy(BuildContext context,
      {String selectedStatus = 'to-do'}) async {
    final token = await _getToken();
    final refreshToken = await _getRefreshToken();
    final pref = await SharedPreferences.getInstance();
    final int? userId = pref.getInt('IDUser');

    if (token != null && userId != null) {
      String url =
          '$baseUrl/job/getAllJobsByUserId/$userId?status=$selectedStatus';
      print("url fetchJob: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("responsee: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _tasksInMy = jsonData['data']['jobs'];
        });
      } else if (response.statusCode == 401) {
        print('Access Token hết hạn. Gọi API refreshToken...');

        final refreshResponse = await http.post(
          Uri.parse('$baseUrl/common/refreshToken'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        );

        if (refreshResponse.statusCode == 200) {
          final refreshData = jsonDecode(refreshResponse.body);
          if (refreshData.containsKey('accessToken')) {
            await _updateToken(refreshData['accessToken']);
            print('Access Token mới đã được cập nhật.');
            return _fetchJobsMy(context, selectedStatus: selectedStatus);
          } else {
            throw Exception('API refreshToken không trả về accessToken.');
          }
        } else {
          throw Exception(
              'Failed to refresh token. Status code: ${refreshResponse.statusCode}');
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } else {
      print('Token hoặc IDUser không tồn tại. Đăng nhập lại...');
    }
  }

  Future<void> _updateToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();

    final currentIDUser = prefs.getInt('IDUser');

    if (currentIDUser != null) {
      print('IDUser cũ được lưu: $currentIDUser');
    } else {
      print('Không tìm thấy IDUser cũ. Có thể chưa được lưu.');
    }

    await prefs.setString('token', newToken);

    if (currentIDUser != null) {
      await prefs.setInt('IDUser', currentIDUser);
    }

    print('Token mới đã được lưu thành công: $newToken');
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
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
  var buttonSize = const Size(60.0, 60.0);
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
  String selectedTime = 'day';
  String selectedStatus = 'to-do';

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
                //   PopupMenuItem(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         const Text('Tạo workflow'),
                //         const Icon(Icons.table_chart_outlined),
                //       ],
                //     ),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const CreateWorkflow(),
                //         ),
                //       );
                //     },
                //   ),
                //   PopupMenuItem(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         const Text('Tạo Groups'),
                //         const Icon(Icons.card_travel_outlined),
                //       ],
                //     ),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const MyGroups(
                //             groupId: null,
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                //   PopupMenuItem(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         const Text('Tạo Project'),
                //         const Icon(Icons.table_chart_outlined),
                //       ],
                //     ),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => Project(),
                //         ),
                //       );
                //     },
                //   ),
              ],
            ),
          ),
        ],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColor.yellowColor,
              tabs: const [
                Tab(
                  text: 'Hôm nay',
                ),
                Tab(text: 'Hôm qua'),
                Tab(text: 'Tuần này'),
                Tab(text: 'Của tôi'),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    selectedTime = 'day';
                    print("Tab 'Hôm nay' selected");
                    break;
                  case 1:
                    selectedTime = 'previousDay';
                    print("Tab 'Hôm qua' selected");
                    break;
                  case 2:
                    selectedTime = 'week';
                    print("Tab 'Tuần này' selected");
                    break;
                }
                _handleTabSelection();
              },
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
                  StatusChip(
                    label: 'To Do',
                    color: Colors.orange,
                    onTap: () {
                      print('abc');
                      setState(() {
                        selectedStatus = 'to-do';
                      });
                      _fetchJobs(context,
                          selectedTime: selectedTime,
                          selectedStatus: selectedStatus);
                      _fetchJobsMy(context, selectedStatus: selectedStatus);
                    },
                  ),
                  StatusChip(
                    label: 'In Progress',
                    color: Colors.blue,
                    onTap: () {
                      setState(() {
                        selectedStatus = 'in-progress';
                      });
                      _fetchJobs(context,
                          selectedTime: selectedTime,
                          selectedStatus: selectedStatus);
                      _fetchJobsMy(context, selectedStatus: selectedStatus);
                    },
                  ),
                  StatusChip(
                    label: 'Review UAT',
                    color: Colors.grey,
                    onTap: () {
                      setState(() {
                        selectedStatus = 'review';
                      });
                      _fetchJobs(context,
                          selectedTime: selectedTime,
                          selectedStatus: selectedStatus);
                      _fetchJobsMy(context, selectedStatus: selectedStatus);
                    },
                  ),
                  StatusChip(
                    label: 'Done UAT',
                    color: Colors.green,
                    onTap: () {
                      setState(() {
                        selectedStatus = 'done';
                      });
                      _fetchJobs(context,
                          selectedTime: selectedTime,
                          selectedStatus: selectedStatus);
                      _fetchJobsMy(context, selectedStatus: selectedStatus);
                    },
                  ),
                  StatusChip(
                    label: 'Bug UAT',
                    color: Colors.red,
                    onTap: () {
                      setState(() {
                        selectedStatus = 'bug';
                      });
                      _fetchJobs(context,
                          selectedTime: selectedTime,
                          selectedStatus: selectedStatus);
                      _fetchJobsMy(context, selectedStatus: selectedStatus);
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '2 to do',
                style: TextStyle(
                    color: AppColor.blackColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(_tasks), // Hôm nay
                _buildTaskList(_tasks), // Hôm qua
                _buildTaskList(_tasks), // Tuần này
                _buildTaskList(_tasksInMy), // Của tôi
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: selectedfABLocation,
      floatingActionButton: Transform.translate(
        offset: const Offset(0, -10),
        child: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          mini: mini,
          openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(8),
          spaceBetweenChildren: 4,
          dialRoot: customDialRoot
              ? (ctx, open, toggleChildren) {
                  return ElevatedButton(
                    onPressed: toggleChildren,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 18),
                    ),
                    child: const Text(
                      "Custom Dial Root",
                      style: TextStyle(fontSize: 17),
                    ),
                  );
                }
              : null,
          buttonSize: buttonSize,
          label: extend ? const Text("Open") : null,
          activeLabel: extend ? const Text("Close") : null,
          childrenButtonSize: childrenButtonSize,
          visible: visible,
          direction: speedDialDirection,
          switchLabelPosition: switchLabelPosition,
          closeManually: closeManually,
          renderOverlay: renderOverlay,
          useRotationAnimation: useRAnimation,
          tooltip: 'Open Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          elevation: 8.0,
          animationCurve: Curves.elasticInOut,
          isOpenOnStart: false,
          shape: customDialRoot
              ? const RoundedRectangleBorder()
              : const StadiumBorder(),
          children: [
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.group_sharp) : null,
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
              labelWidget: Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Groups',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyGroups(
                      groupId: context,
                    ),
                  ),
                );
              },
            ),
            SpeedDialChild(
              child: !rmicons
                  ? const Icon(Icons.playlist_add_check_circle_outlined)
                  : null,
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
              labelWidget: Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Workflows',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateWorkflow(),
                  ),
                );
              },
            ),
            SpeedDialChild(
                child: !rmicons ? const Icon(Icons.task_outlined) : null,
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                labelWidget: Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Create Tasks',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTask(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

Widget _buildTaskList(List<dynamic> tasks) {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      final task = tasks[index];
      final nameTask = task['NameJob'] ?? 'No title';
      final timeStart = DateTime.parse(task['TimeStart']);
      final timeComplete = DateTime.parse(task['TimeComplete']);
      final formattedDate =
          '${timeStart.day}-${timeStart.month}/${timeComplete.day}-${timeComplete.month}';
      final priority = task['Priority'] ?? 'Low';
      final priorityColor =
          priority == 'High' ? Colors.red.shade100 : Colors.green.shade100;
      final letterColor =
          priority == 'High' ? AppColor.redColor : AppColor.greenColor;

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
  );
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  StatusChip({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        onTap();
      },
      child: Padding(
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
