import 'package:flutter/material.dart';

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
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Danh mục',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            CategoryCard(
              label: 'Task',
              icon: Icons.task_alt_outlined,
              color: Colors.blue,
            ),
            CategoryCard(
              label: 'Nghỉ phép',
              icon: Icons.badge_outlined,
              color: Colors.orange,
            ),
            CategoryCard(
              label: 'Chấm công',
              icon: Icons.supervised_user_circle_outlined,
              color: Colors.green,
            ),
            CategoryCard(
              label: 'Tổng giờ',
              icon: Icons.timer_outlined,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  CategoryCard({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
