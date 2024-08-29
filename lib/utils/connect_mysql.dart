import 'package:mysql1/mysql1.dart';

Future<void> connectToDatabase() async {
  final database = await MySqlConnection.connect(
    ConnectionSettings(
      host: 'localhost',
      port: 3000,
      user: 'root',
      password: '',
      db: 'workflow_v2',
    ),
  );

  await database.query('SELECT * FROM appuser');

  await database.close();
}
