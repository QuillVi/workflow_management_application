import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:work_flow/themes/primarycolor.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int? selectedDateIndex;

  //   switch (index) {
  //     case 0:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const DashBoard()),
  //       );
  //       break;
  //     case 1:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const CategoryBoard()),
  //       );
  //       break;
  //     case 2:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const MyTaskDashBoard()),
  //       );
  //       break;
  //     case 3:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const ChatDashBoard()),
  //       );
  //       break;
  //     case 4:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const ProfileBoard()),
  //       );
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Image.asset('lib/images/user.png'),
            ),
            const SizedBox(width: 10),
            const Text(
              'Xin chào , Vi',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tổng kết',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SummaryCard(
                    label: 'Trong tuần',
                    value: '84',
                    color: whiteColor,
                    colorbackground: primaryColor,
                    sizebackground: const Size(80, 80),
                  ),
                  SummaryCard(
                    label: 'Đang làm',
                    value: '16',
                    color: whiteColor,
                    sizebackground: const Size(80, 80),
                    colorbackground: yellowColor,
                  ),
                  SummaryCard(
                    label: 'Hoàn thành',
                    value: '16',
                    color: whiteColor,
                    sizebackground: const Size(80, 80),
                    colorbackground: greenColor,
                  ),
                  SummaryCard(
                    label: 'Quá hạn',
                    value: '16',
                    color: whiteColor,
                    sizebackground: const Size(80, 80),
                    colorbackground: redColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Hoạt động',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                child: SizedBox(
                  height: 65,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: daysOfWeek.length,
                    itemBuilder: (context, index) {
                      return ActivityChip(
                        label: daysOfWeek[index],
                        time: '1/2 (3h)',
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
              const SizedBox(height: 20),
              const Text(
                'Công việc hôm nay',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        TaskCard(
                          title: 'Refresh Data Màn hình danh sách Telesales',
                          date: '04-08/06-08',
                          iconuser: Image.asset(
                            'lib/images/user.png',
                            width: 30,
                            height: 30,
                          ),
                          appName: 'MICXM/FieldSale App',
                          taskNumber: '[222]',
                        ),
                        const SizedBox(width: 10),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
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
  'Th 2',
  'Th 3',
  'Th 4',
  'Th 5',
  'Th 6',
  'Th 7',
  'CN',
];

class ActivityChip extends StatefulWidget {
  final String label;
  final String time;
  final int index;
  final VoidCallback onTap;
  final bool active;

  ActivityChip(
      {required this.active,
      required this.label,
      required this.time,
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
          color: widget.active ? primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              widget.label,
              style:
                  TextStyle(color: widget.active ? Colors.white : Colors.black),
            ),
            Text(
              widget.time,
              style:
                  TextStyle(color: widget.active ? Colors.white : Colors.black),
            ),
          ],
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
