import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ya_map_bug/features/map/map.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  StreamSubscription<int>? _streamSubscription;

  @override
  void initState() {
    _streamSubscription = context.read<MapBloc>().streamInt.listen((data) {
      /// После нажатия на маркер, данные отобразятся только после
      /// взаимодействия с картой, хотя должны отображаться сразу.
      print('Has data in stream: $data');
    });
    super.initState();
  }

  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Если вызвать событие через ui - BottomSheet откроется сразу.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<MapBloc>().add(MapOpenBottomSheetEvent()),
        label: const Text("Bottom Sheet откроется сразу"),
      ),

      /// После нажатия на маркер, BlocListener увидит MapOpenBottomSheetEvent
      /// только после взаимодействия с картой, хотя должен сразу.
      body: BlocListener<MapBloc, MapState>(
        listener: (context, state) async {
          if (state is MapLoaded) {
            if (state.openSheet) {
              await showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Center(child: Text("Bottom Sheet")),
                  );
                },
              ).then((_) {
                if (context.mounted) {
                  context.read<MapBloc>().add(MapCloseBottomSheetEvent());
                }
              });
            }
          }
        },
        child: YandexMap(
          onMapCreated: (mapWindow) =>
              context.read<MapBloc>().add(MapLoadEvent(mapWindow)),
        ),
      ),
    );
  }
}
