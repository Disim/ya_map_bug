import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/image.dart' as img;
import 'package:yandex_maps_mapkit_lite/mapkit.dart' hide Icon;

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<MapLoadEvent>(_mapLoadEvent);
    on<MapOpenBottomSheetEvent>(_openBottomSheet);
    on<MapCloseBottomSheetEvent>(_closeBottomSheet);
  }

  final listener = MapObjectTapListenerImpl();

  final StreamController<int> _streamController = StreamController<int>();
  Stream<int> get streamInt => _streamController.stream;

  void _mapLoadEvent(MapLoadEvent event, Emitter<MapState> emit) {
    final imageProvider = img.ImageProvider.fromImageProvider(
      const AssetImage("assets/station-enable.png"),
    );

    /// Если нажать на маркер, то BottomSheet не откроется сразу, а только
    /// после повторного нажатия, либо после взаимодействия с картой.
    event.mapWindow.map.mapObjects.addPlacemark()
      ..geometry = const Point(latitude: 55.751225, longitude: 37.62954)
      ..setIcon(imageProvider)
      ..addTapListener(listener)
      ..userData = () {
        add(MapOpenBottomSheetEvent());
        _streamController.add(0);
      };
    emit(MapLoaded(event.mapWindow));
  }

  void _openBottomSheet(MapOpenBottomSheetEvent event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(openSheet: true));
    }
  }

  void _closeBottomSheet(
    MapCloseBottomSheetEvent event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(openSheet: false));
    }
  }
}

final class MapObjectTapListenerImpl implements MapObjectTapListener {
  @override
  bool onMapObjectTap(MapObject mapObject, Point point) {
    if (mapObject.userData is void Function()) {
      (mapObject.userData as void Function())();
    }
    return true;
  }
}
