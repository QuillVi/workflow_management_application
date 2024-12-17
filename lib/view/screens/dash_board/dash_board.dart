import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_flow/api_constants.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/view/screens/chats/chat_dash_board.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:work_flow/view/screens/jobs/info_job.dart';
import 'package:work_flow/view/screens/login_app/login.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

Map mapResponse = {};
String nameUser = '';
int idUser = -1;

class _DashBoardState extends State<DashBoard> {
  int? selectedDateIndex;
  List<dynamic> _members = [];
  List<dynamic> _tasks = [];
  late Future<Map<String, dynamic>> jobDataFuture;

  Future<void> _loadTasks() async {
    final token = await _getToken();
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/job/getAll'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);

          if (mounted) {
            setState(() {
              _tasks = jsonData;
            });
          }
        } else {
          print('Failed to load jobs: ${response.statusCode}');
        }
      } catch (error) {
        print('Error loading jobs: $error');
      }
    } else {
      print('Token not found');
    }
  }

  Future<void> loadUsers() async {
    final token = await _getToken();
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/appUser/getAll'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);

          if (jsonData is List) {
            setState(() {
              _members = jsonData;
            });
          } else {
            print('Expected a list, but got something else');
          }
        } else {
          print('Failed to load users');
        }
      } catch (error) {
        print('Error loading users: $error');
      }
    } else {
      print('Token not found');
    }
  }

  Future<Map<String, dynamic>> fetchJobData() async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
      }

      final idUser = pref.getInt('IDUser');
      if (idUser == null) {
        throw Exception('IDUser không được tìm thấy trong SharedPreferences.');
      }

      final url = '$baseUrl/job/totaljobsinweek/$idUser';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return {
            'totalJobsReceived': data['data']['totalJobsReceived'],
            'totalJobsTodo': data['data']['totalJobsTodo'],
            'totalJobsCompleted': data['data']['totalJobsCompleted'],
            'totalJobsLate': data['data']['totalJobsLate'],
          };
        } else {
          throw Exception(data['message'] ?? 'Error fetching data.');
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  void getData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      nameUser = pref.getString(
            'name',
          ) ??
          'not found';

      idUser = pref.getInt('IDUser') ?? -1;
    });
  }

  Future<void> _handleTokenExpiry() async {
    // Xóa token cũ
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Chuyển hướng về trang đăng nhập
    if (mounted) {
      // Dùng Future để đảm bảo pushReplacement được gọi đúng lúc
      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()),
        );
      });
    }
  }

  Future<bool> _isTokenExpired(String? token) async {
    if (token == null) return true; // Token không tồn tại, coi như hết hạn

    try {
      // Giải mã token và kiểm tra
      bool isExpired = Jwt.isExpired(token);
      return isExpired; // Trả về true nếu token hết hạn
    } catch (e) {
      print('Error decoding token: $e');
      return true; // Lỗi giải mã, coi như token không hợp lệ
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final isExpired = await _isTokenExpired(token);
    if (isExpired) {
      print('Token đã hết hạn');
      await _handleTokenExpiry(); // Xóa token và chuyển về màn hình đăng nhập
      return null;
    }

    return token; // Chỉ trả về token còn hiệu lực
  }

  @override
  void initState() {
    super.initState();
    getData();
    loadUsers();
    _loadTasks();
    jobDataFuture = fetchJobData();
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
                  FutureBuilder<Map<String, dynamic>>(
                    future: fetchJobData(), // Gọi API
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Hiển thị khi đang tải dữ liệu
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;

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
                              value: data['totalJobsCompleted'].toString(),
                              color: AppColor.whiteColor,
                              sizebackground: const Size(80, 80),
                              colorbackground: AppColor.greenColor,
                            ),
                            SummaryCard(
                              label: 'Quá hạn',
                              value: data['totalJobsLate'].toString(),
                              color: AppColor.whiteColor,
                              sizebackground: const Size(80, 80),
                              colorbackground: AppColor.redColor,
                            ),
                          ],
                        );
                      } else {
                        return Text('No data available');
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
                  const SizedBox(height: 10),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        final nameTask = task['NameJob'] ?? 'No title';
                        final timeStart = DateTime.parse(task['TimeStart']);
                        final timeComplete =
                            DateTime.parse(task['TimeComplete']);

                        // Định dạng ngày với gói intl
                        final formattedStartDate =
                            DateFormat('dd-MM-yyyy').format(timeStart);
                        final formattedCompleteDate =
                            DateFormat('dd-MM-yyyy').format(timeComplete);
                        final formattedDate =
                            '$formattedStartDate to $formattedCompleteDate';

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
                          child: Row(
                            children: [
                              TaskCard(
                                title: nameTask,
                                date: formattedDate,
                                iconuser: Image.asset(
                                  'lib/images/user.png',
                                  width: 30,
                                  height: 30,
                                ),
                                appName: 'MICXM/FieldSale App',
                                taskNumber: '[${task['IDJob']}]',
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: _members.length,
                      itemBuilder: (context, index) {
                        final member = _members[index];
                        final nameMember = member['Name'] ?? 'No Name';

                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
          color: widget.active ? AppColor.primaryColor : Colors.grey.shade200,
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
