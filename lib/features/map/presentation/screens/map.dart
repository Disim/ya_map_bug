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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
