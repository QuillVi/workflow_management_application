import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/viewmodels/dashboard_view_model/fecth_job_status_view_model.dart';
import 'package:work_flow/viewmodels/dashboard_view_model/load_user_view_model.dart';
import 'package:work_flow/viewmodels/dashboard_view_model/task_view_model.dart';
import 'package:work_flow/views/chat_view/chat_dash_board.dart';
import 'package:intl/intl.dart';

import 'package:work_flow/views/jobs_view/info_job.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Map mapResponse = {};
String nameUser = '';
int idUser = -1;

class _DashBoardState extends State<DashBoard> {
  int? selectedDateIndex;
  List<dynamic> _members = [];
  List<dynamic> _tasks = [];

  void getData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      nameUser = pref.getString('name') ?? 'not found';
      idUser = pref.getInt('IDUser') ?? -1;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    context.read<LoaduserViewModel>().loadUsers().then(
      (value) {
        _members = value;
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().loadTasks();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FecthJobStatusViewModel>().fetchJobData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Image.asset('lib/images/user.png'),
                ),
                const SizedBox(width: 10),
                Container(
                  child: Text(
                    'Xin chào, $nameUser',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                )
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatDashBoard()));
                },
                icon: Image.asset('lib/images/chat.png',
                    width: 25, height: 25, color: Colors.grey[700]),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng kết',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Consumer<FecthJobStatusViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading) {
                        return const CircularProgressIndicator();
                      } else if (viewModel.errorMessage != null) {
                        return Text('Lỗi: ${viewModel.errorMessage}');
                      } else if (viewModel.jobStatus.isNotEmpty) {
                        final data = viewModel.jobStatus;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SummaryCard(
                              label: 'Trong tuần',
                              value: data['totalJobsReceived'].toString(),
                              color: AppColor.whiteColor,
                              colorbackground: AppColor.primaryColor,
                              sizebackground: const Size(80, 80),
                            ),
                            SummaryCard(
                              label: 'Đang làm',
                              value: data['totalJobsTodo'].toString(),
                              color: AppColor.whiteColor,
                              sizebackground: const Size(80, 80),
                              colorbackground: AppColor.yellowColor,
                            ),
                            SummaryCard(
                              label: 'Hoàn thành',
                              value: data['totalJobsDone'].toString(),
                              color: AppColor.whiteColor,
                              sizebackground: const Size(80, 80),
                              colorbackground: AppColor.greenColor,
                            ),
                            SummaryCard(
                              label: 'Lỗi',
                              value: data['totalJobsBug'].toString(),
                              color: AppColor.whiteColor,
                              sizebackground: const Size(80, 80),
                              colorbackground: AppColor.redColor,
                            ),
                          ],
                        );
                      } else {
                        return const Text('Không có dữ liệu.');
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hoạt động',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: daysOfWeek.length,
                        itemBuilder: (context, index) {
                          return ActivityChip(
                            label: daysOfWeek[index],
                            index: index,
                            onTap: () {
                              setState(() {
                                selectedDateIndex = index;
                              });
                            },
                            active: selectedDateIndex == index,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<TaskViewModel>(
                    builder: (context, taskViewModel, child) {
                      final tasks = taskViewModel.tasks;
                      final isLoading = taskViewModel.isLoading;

                      return SizedBox(
                        height:
                            160, // Tăng chiều cao để có đủ không gian hiển thị
                        child: isLoading
                            ? const Center(
                                child:
                                    CircularProgressIndicator(), // Hiển thị loading
                              )
                            : tasks.isEmpty
                                ? const Center(
                                    child: Text(
                                      "Không có công việc nào",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = tasks[index];
                                      final nameTask =
                                          task['NameJob'] ?? 'Không có tiêu đề';
                                      final timeStart = DateTime.tryParse(
                                              task['TimeStart'] ?? '') ??
                                          DateTime.now();
                                      final timeComplete = DateTime.tryParse(
                                              task['TimeComplete'] ?? '') ??
                                          DateTime.now();

                                      // Định dạng ngày
                                      final formattedStartDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(timeStart);
                                      final formattedCompleteDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(timeComplete);
                                      final formattedDate =
                                          '$formattedStartDate → $formattedCompleteDate';

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  InfoJob(jobId: task['IDJob']),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width:
                                              250, // Điều chỉnh chiều rộng của card
                                          child: Card(
                                            elevation:
                                                4, // Đổ bóng nhẹ cho card
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15), // Bo góc avatar
                                                        child: Image.asset(
                                                          'lib/images/user.png',
                                                          width: 30,
                                                          height: 30,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          nameTask,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'App: MICXM/FieldSale App',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors
                                                            .blue.shade700),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Mã công việc: [${task['IDJob']}]',
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      );
                    },
                  ),
                  Consumer<LoaduserViewModel>(
                    builder: (context, value, child) {
                      return Container(
                        height: 300,
                        width: double.infinity,
                        child: _members.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: _members.length,
                                itemBuilder: (context, index) {
                                  final member = _members[index];
                                  final nameMember =
                                      member['Name'] ?? 'No Name';
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'lib/images/user.png',
                                              width: 40,
                                              height: 40,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                nameMember,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color colorbackground;
  final Size sizebackground;

  SummaryCard(
      {required this.label,
      required this.value,
      required this.color,
      required this.colorbackground,
      required this.sizebackground});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: sizebackground.width,
      decoration: BoxDecoration(
        color: colorbackground.withOpacity(1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

List<String> daysOfWeek = [
  'Thứ 2',
  'Thứ 3',
  'Thứ 4',
  'Thứ 5',
  'Thứ 6',
  'Thứ 7',
  'Chủ nhật',
];

class ActivityChip extends StatefulWidget {
  final String label;
  //final String time;
  final int index;
  final VoidCallback onTap;
  final bool active;

  ActivityChip(
      {required this.active,
      required this.label,
      //required this.time,
      required this.index,
      required this.onTap});

  @override
  _ActivityChipState createState() => _ActivityChipState();
}

class _ActivityChipState extends State<ActivityChip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: widget.active ? AppColor.primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.active ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String date;
  final String appName;
  final String taskNumber;
  final Image iconuser;

  TaskCard(
      {required this.title,
      required this.date,
      required this.appName,
      required this.taskNumber,
      required this.iconuser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
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
                  const SizedBox(width: 10),
                  Text(date, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(width: 150),
              Text(taskNumber, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              iconuser,
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 5),
          Text(appName, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
