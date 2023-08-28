import 'package:food/headers.dart';

class FoodRestApi {
  final _rFoods = '/';
  final _rFoodOnTemp = '/$eTemp';
  final _rPutTemp = '/$eId/$eTemp';
  final _rAddFood = '/$eName/$eIsDog/$eTemp';
  final _rDelete = '/$eId';

  static const String eId = 'id=<id|.+>';
  static const String eName = 'name=<name|.+>';
  static const String eIsDog = 'isDog=<isDog|.+>';
  static const String eTemp = 'temp=<temp|.+>';
  static const String eLimit = 'limit=<limit|.+>';

  Handler get router {
    final app = Router();

    app.get(_rFoods, (Request request) async {
      print("HIII");
      final res = await FoodContainer.getAll();
      final json = jsonEncode(res);
      return Response.ok(json);
    });

    app.get(_rFoodOnTemp, (Request request, String temp) async {
      final d = double.tryParse(temp);
      if (d == null) {
        return Response.badRequest();
      }

      final value = await FoodContainer.getAtTemp(temp);
      if (value == null) {
        return Response.badRequest();
      }

      final json = jsonEncode({"food": value});
      return Response.ok(json);
    });

    app.post(_rAddFood, (
      Request request,
      String name,
      String isDog,
      String temp,
    ) async {
      try {
        final isAdded = await FoodContainer.addFood(name, isDog, temp);
        if (isAdded) {
          return Response.ok(
              "Name $name, Type ${isDog == 'true' ? 'Dog' : 'Cat'}, Temperature $temp   added");
        }
        return Response.notFound('Not Added');
      } catch (e) {
        if (e is String) {
          return Response.notFound(e);
        }
        return Response.notFound('Not Added');
      }
    });

    app.put(_rPutTemp, (Request request, String id, String temp) async {
      final d = double.tryParse(temp);
      if (d == null) {
        return Response.badRequest();
      }

      final isUpdated = await FoodContainer.putTemp(id, temp);
      if (isUpdated) {
        return Response.ok('Tempeature Updated');
      }
      return Response.notFound('Tempeature NOT Updated');
    });
    app.delete(_rDelete, (Request request, String id) async {
      final isDelete = await FoodContainer.deleteFood(id);
      if (isDelete) {
        return Response.ok('ID $id is Deleted');
      }
      return Response.notFound('ID $id not Deleted');
    });

    return app;
  }
}
