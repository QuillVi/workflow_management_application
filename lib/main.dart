import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:work_flow/repositorys/fecth_job_status_reponsitory.dart';
import 'package:work_flow/repositorys/fecth_total_job_receiced_reponsitory.dart';
import 'package:work_flow/repositorys/loaduser_repository.dart';
import 'package:work_flow/repositorys/task_repository.dart';
import 'package:work_flow/services/api_fecth_total_job_receiced.dart';
import 'package:work_flow/services/api_fetch_job_status.dart';
import 'package:work_flow/services/api_load_user_client.dart';
import 'package:work_flow/services/api_task_client.dart';
import 'package:work_flow/themes/themes_mode.dart';
import 'package:work_flow/viewmodels/caterory_view_model/fecth_job_done_view_model.dart';
import 'package:work_flow/viewmodels/caterory_view_model/fecth_job_todo_view_model.dart';
import 'package:work_flow/viewmodels/caterory_view_model/fecth_total_job_receiced_view_model.dart';
import 'package:work_flow/viewmodels/dashboard_view_model/fecth_job_status_view_model.dart';
import 'package:work_flow/viewmodels/dashboard_view_model/load_user_view_model.dart';
import 'package:work_flow/viewmodels/dashboard_view_model/task_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/addMember_to_group_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/create_group_addMember_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/create_workflow_in_group_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/load_group_id_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/load_group_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/load_list_group_create_workflow_view_model.dart';
import 'package:work_flow/viewmodels/group_view_model.dart/load_workflow_in_groupId_view_model.dart';
import 'package:work_flow/viewmodels/login_view_model/login_view_model.dart';
import 'package:work_flow/viewmodels/profile_view_model/get_user_id_view_model.dart';
import 'package:work_flow/viewmodels/profile_view_model/theme_view_model.dart';
import 'package:work_flow/views/message_push_notification/globalkey.dart';
import 'package:work_flow/views/message_push_notification/noti_service.dart';
import 'package:work_flow/views/mybottomnavigationbar_view/mybottomnavigationbar_view.dart';
import 'package:work_flow/views/screens/jobs/info_job.dart';
import 'package:work_flow/views/splash_creen_view/splash_creen_word_group_1_view.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Handling a background message: ${message.messageId}');
}

void _handleNotificationNavigation(RemoteMessage message) {
  final String? jobId = message.data['jobId'];
  if (jobId != null) {
    print("🔗 Điều hướng đến InfoJob với jobId: $jobId");
    NavigationService.navigatorKey.currentState
        ?.pushNamed('/infoJob', arguments: jobId);
  }
}

Future<void> handleInitialMessage() async {
  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print("📩 App mở từ thông báo (terminated)");
    _handleNotificationNavigation(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotiService.initialize();
  await handleInitialMessage();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSplashDone = false;
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _checkLoginStatus();
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationNavigation);
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    setState(() {
      _isLoggedIn = token != null && token.isNotEmpty;
      _isSplashDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UiProvider()..init()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(
            create: (context) =>
                TaskViewModel(TaskRepository(ApiTaskClient()))),
        ChangeNotifierProvider(
            create: (context) =>
                LoaduserViewModel(LoaduserRepository(ApiLoaduserClient()))),
        ChangeNotifierProvider(
            create: (context) => FecthJobStatusViewModel(
                FecthJobStatusReponsitory(ApiFecthJobStatus()))),
        ChangeNotifierProvider(
            create: (context) => FecthTotalJobReceicedViewModel(
                FecthTotalJobReceicedReponsitory(ApiFecthTotalJobReceiced()))),
        ChangeNotifierProvider(create: (context) => FecthJobTodoViewModel()),
        ChangeNotifierProvider(create: (context) => FecthJobDoneViewModel()),
        ChangeNotifierProvider(create: (context) => GetUserIdViewModel()),
        ChangeNotifierProvider(create: (context) => LoadGroupViewModel()),
        ChangeNotifierProvider(create: (context) => LoadGroupIdViewModel()),
        ChangeNotifierProvider(
            create: (conetxt) => LoadWorkflowInGroupidViewModel()),
        ChangeNotifierProvider(
            create: (context) => CreateGroupAddmemberViewModel()),
        ChangeNotifierProvider(
            create: (context) => AddmemberToGroupViewModel()),
        ChangeNotifierProvider(
            create: (context) => CreateWorkflowInGroupViewModel()),
        ChangeNotifierProvider(
            create: (context) => LoadListGroupCreateWorkflowViewModel()),
        //theme
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              if (settings.name == '/infoJob' && settings.arguments is String) {
                print("📌 jobId hợp lệ: ${settings.arguments}");
                return MaterialPageRoute(
                  builder: (context) =>
                      InfoJob(jobId: settings.arguments as String),
                );
              }
              return MaterialPageRoute(
                  builder: (context) => Mybottomnavigationbar());
            },
            title: 'Dark Theme',
            themeMode:
                themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            darkTheme: ThemeData.dark(),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: _isSplashDone
                ? (_isLoggedIn == true
                    ? Mybottomnavigationbar()
                    : SplashCreenWordGroup1())
                : AnimatedSplashScreen(
                    duration: 1500,
                    splash: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AssetImage('lib/images/managetment.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const Text(
                          'App Management',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    nextScreen: SplashCreenWordGroup1(),
                    splashTransition: SplashTransition.fadeTransition,
                    backgroundColor: Colors.white,
                  ),
          );
        },
      ),
    );
  }
}
