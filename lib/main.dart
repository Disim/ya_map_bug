import 'package:ya_map_bug/features/map/map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_maps_mapkit_lite/init.dart' as init;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init.initMapkit(apiKey: '55d3ddad-2023-42ec-9c00-cd80f8aff686');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapApp',
      home: BlocProvider(
        create: (context) => MapBloc(),
        child: const MapPage(),
      ),
    );
  }
}
