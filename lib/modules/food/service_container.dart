import 'package:food/headers.dart';

class FoodContainer {
  static Future<List<Map<String, dynamic>>> getAll() async {
    var result = await DbFunc.food!.execute("SELECT * FROM food");
    List<Map<String, dynamic>> data = [];
    for (var row in result.rows) {
      data.add(row.assoc());
    }
    return data;
  }

  static Future<String?> getAtTemp(String temp) async {
    var result = await DbFunc.food!.execute(
        "SELECT * FROM FOOD WHERE Temperature < $temp ORDER BY Temperature DESC LIMIT 1");
    List<Map<String, dynamic>> data = [];
    for (var row in result.rows) {
      data.add(row.assoc());
    }
    if (data.isNotEmpty) {
      return data[0]["Name"];
    }
    return null;
  }

  static Future<bool> putTemp(String id, String temp) async {
    try {
      var result = await DbFunc.food!
          .execute("UPDATE FOOD SET Temperature = $temp WHERE ID = $id");
      return result.affectedRows.toInt() > 0;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteFood(String id) async {
    try {
      var result =
          await DbFunc.food!.execute("DELETE FROM FOOD WHERE ID = $id");
      return result.affectedRows.toInt() > 0;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addFood(String name, String isDog, String temp) async {
    try {
      final type = isDog == 'true'
          ? 'Dog'
          : isDog == 'true'
              ? 'Cat'
              : throw 'Please Enter true or false in type';

      final tem = double.tryParse(temp);
      if (tem == null) throw 'Please Enter Correct Temperature Value';

      var result = await DbFunc.food!.execute(
        "INSERT INTO food (Type, Name, Temperature) VALUES (:type, :name, :temp)",
        {
          "type": type,
          "name": name,
          "temp": temp,
        },
      );
      print("Result HI");
      return result.affectedRows.toInt() > 0;
    } catch (e) {
      print("ERROR $e");
      return false;
    }
  }
}
