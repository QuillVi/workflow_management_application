import 'package:flutter/material.dart';
import 'package:work_flow/themes/primarycolor.dart';
import 'package:work_flow/view/screens/create_task/my_task_dash_board.dart';

class ProfileBoard extends StatefulWidget {
  const ProfileBoard({super.key});

  @override
  State<ProfileBoard> createState() => _ProfileBoardState();
}

class _ProfileBoardState extends State<ProfileBoard> {
  void _onItemTappedProFileInfoCard(int index) {
    String label;

    switch (index) {
      case 0:
        label = 'dongvi';
        break;
      case 1:
        label = 'Password';
        break;
      case 2:
        label = 'My Task';
        break;
      case 3:
        label = 'Setting';
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (label) {
            case 'dongvi':
              return ProfileBoard();
            case 'Password':
              return ProfileBoard();
            case 'My Task':
              return MyTaskDashBoard();
            case 'Setting':
              return ProfileBoard();
            default:
              return Container();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(color: AppColor.blackColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColor.whiteColor,
              child: CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('lib/images/user.png'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: AppColor.primaryColor),
              onPressed: () {},
            ),
            ProfileInfoCard(
              icon: Icons.person,
              label: 'dong vi',
              onTap: () => _onItemTappedProFileInfoCard(0),
            ),
            ProfileInfoCard(
              icon: Icons.lock,
              label: 'Password',
              onTap: () => _onItemTappedProFileInfoCard(1),
            ),
            ProfileInfoCard(
              icon: Icons.task,
              label: 'My Tasks',
              onTap: () => _onItemTappedProFileInfoCard(2),
            ),
            ProfileInfoCard(
              icon: Icons.settings,
              label: 'Setting',
              onTap: () => _onItemTappedProFileInfoCard(3),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: AppColor.primaryColor,
                  ),
                  icon: Icon(
                    Icons.logout,
                    color: AppColor.whiteColor,
                  ),
                  label: Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, color: AppColor.whiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEditable;
  final VoidCallback onTap;

  const ProfileInfoCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isEditable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColor.blackColor, size: 30),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: AppColor.blackColor, fontSize: 18),
            ),
          ),
          if (isEditable)
            Icon(Icons.edit, color: AppColor.blackColor, size: 20),
        ],
      ),
    );
  }
}
