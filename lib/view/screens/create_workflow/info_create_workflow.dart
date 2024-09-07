import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';

class InfoCreateWorkflow extends StatefulWidget {
  const InfoCreateWorkflow({super.key});

  @override
  State<InfoCreateWorkflow> createState() => _InfoCreateWorkflowState();
}

class _InfoCreateWorkflowState extends State<InfoCreateWorkflow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên workflow',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.black),
            onPressed: () {
              // Xử lý thêm người
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Xử lý menu
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Các thao tác nhanh',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quickActionButton(
                      Icons.check_circle, 'Thêm Stage', Colors.green),
                  _quickActionButton(
                      Icons.attach_file, 'Thêm Tệp', Colors.blue),
                  _quickActionButton(Icons.person, 'Thành viên', Colors.purple),
                ],
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),
              _buildListItem(Icons.list, 'Thêm mô tả...'),
              _buildListItem(Icons.access_time, 'Ngày bắt đầu...'),
              _buildListItem(Icons.calendar_today, 'Ngày hết hạn...'),
              _buildListItem(Icons.label, 'Các nhãn...'),
              _buildListItem(Icons.person_outline, 'Các thành viên...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickActionButton(IconData icon, String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {},
      child: Column(
        children: [
          Icon(icon, color: color),
          SizedBox(height: 5),
          Container(
            width: 80,
            height: 20,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColor.greyColor,
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
