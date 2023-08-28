import 'package:food/headers.dart';

void main(List<String> arguments) async {
  final res = await DbFunc.connectDB();
  print("Res $res");
  // Create routes
  final app = Router();

  // app.mount(AppRoutes.)
  app.mount(AppRoutes.food, FoodRestApi().router);

  // Listen for incoming connections
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addHandler(app);

  withHotreload(() => serve(handler, InternetAddress.anyIPv4, AppRoutes.port));

  print('Server Listening at http://localhost:${AppRoutes.port}/');
}
