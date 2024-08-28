import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';

class CategoryBoard extends StatefulWidget {
  const CategoryBoard({super.key});

  @override
  State<CategoryBoard> createState() => _CategoryBoardState();
}

class _CategoryBoardState extends State<CategoryBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Xử lý khi nhấn nút quay lại
          },
        ),
        title: Text(
          'Danh mục',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.4,
                children: [
                  buildStatCard(
                    Icon(Icons.task, color: AppColor.primaryColor),
                    '136',
                    'Task',
                    AppColor.primaryColor,
                  ),
                  buildStatCard(
                    Icon(Icons.event, color: AppColor.yellowColor),
                    '0',
                    'Nghỉ phép',
                    AppColor.yellowColor,
                  ),
                  buildStatCard(
                    Icon(Icons.timer, color: AppColor.greenColor),
                    '30',
                    'Chấm công',
                    AppColor.greenColor,
                  ),
                  buildStatCard(
                    Icon(Icons.summarize, color: AppColor.redColor),
                    '136',
                    'Tổng giờ',
                    AppColor.redColor,
                  ),
                ],
              ),
              SizedBox(height: 16),
              buildSectionHeader('Đang thực hiện', onViewAll: () {}),
              SizedBox(height: 16),
              buildShipmentCard(
                id: 'SDK-108-WRT-56',
                date: '12-04-2021',
                from: 'dong vi',
                status: 'In progress',
              ),
              SizedBox(height: 16),
              buildSectionHeader('Đã hoàng thành', onViewAll: () {}),
              SizedBox(height: 16),
              buildShipmentCard(
                id: 'SDK-108-WRT-56',
                date: '12-04-2021',
                from: 'dong vi',
                status: 'done',
                isRecent: true,
              ),
              buildShipmentCard(
                id: 'SDK-108-WRT-56',
                date: '12-04-2021',
                from: 'dong vi',
                status: 'done',
                isRecent: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(Icon icon, String count, String label, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionHeader(String title, {required VoidCallback onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildShipmentCard({
    required String id,
    required String date,
    required String from,
    required String status,
    bool isRecent = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    id,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(isRecent ? Icons.delete : Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 16),
              SizedBox(width: 4),
              Text(
                isRecent ? '$date' : '$date',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'From',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(from),
            ],
          ),
          if (!isRecent) ...[
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(status),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
