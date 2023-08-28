import 'package:food/headers.dart';

class DbFunc {
  static late MySQLConnection? food;

  static Future<bool> connectDB() async {
    try {
      food = await MySQLConnection.createConnection(
        host: "hm2.mysql.database.azure.com",
        port: 3306,
        userName: "salman",
        password: "Iloveazure.",
        databaseName: "food", // optional
      );

      await food!.connect();
      return true;
    } catch (e) {
      return false;
    }
  }
}
