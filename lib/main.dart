import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';
import 'package:sololandscapes_moblie/services/api_config.dart';
import 'package:sololandscapes_moblie/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(ApiConfig.graphqlEndpoint);

  final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: HiveStore()),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final GraphQLClient client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(client),
      child: GetMaterialApp(
        title: 'Solo Landscapes Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        initialRoute: AppRoutes.home,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
