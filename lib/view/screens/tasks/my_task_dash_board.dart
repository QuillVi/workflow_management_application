import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/view/screens/groups/my_group.dart';
import 'package:work_flow/view/screens/jobs/job.dart';
import 'package:work_flow/view/screens/projects/project.dart';
import 'package:work_flow/view/screens/tasks/create_task.dart';
import 'package:work_flow/view/screens/workflows/workflow.dart';

class MyTaskDashBoard extends StatefulWidget {
  const MyTaskDashBoard({super.key});

  @override
  State<MyTaskDashBoard> createState() => _MyTaskDashBoardState();
}

class _MyTaskDashBoardState extends State<MyTaskDashBoard>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
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
            color: Colors.grey[200],
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColor.yellowColor,
              tabs: const [
                Tab(text: 'Tuần này'),
                Tab(text: 'Của tôi'),
                Tab(text: 'Hôm nay'),
                Tab(text: 'Hôm qua'),
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TaskCard(
                  title: 'Refresh Data Màn hình danh sách Telesales',
                  date: '04-08/06-08',
                  priority: 'High',
                  letterColor: AppColor.redColor,
                  priorityColor: Colors.red.shade100,
                  taskNumber: '[222]',
                  appName: 'MICXM/FieldSale App',
                ),
                TaskCard(
                  title: 'Tạo phân hệ User',
                  date: '04-08/06-08',
                  priority: 'Low',
                  letterColor: AppColor.greenColor,
                  priorityColor: Colors.green.shade100,
                  taskNumber: '[113]',
                  appName: 'MICXM/FieldSale App',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: selectedfABLocation,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        mini: mini,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
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
              child: !rmicons ? const Icon(Icons.work_outline) : null,
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
                    'Jobs',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Job(),
                  ),
                );
              }),
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
                    ' Create tasks',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              visible: true,
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
              Text(taskNumber, style: const TextStyle(color: Colors.grey)),
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
