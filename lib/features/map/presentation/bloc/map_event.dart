part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

final class MapLoadEvent extends MapEvent {
  const MapLoadEvent(this.mapWindow);
  final MapWindow mapWindow;

  @override
  List<Object> get props => [mapWindow];
}

final class MapOpenBottomSheetEvent extends MapEvent {
  const MapOpenBottomSheetEvent();
  @override
  List<Object> get props => [];
}

final class MapCloseBottomSheetEvent extends MapEvent {
  const MapCloseBottomSheetEvent();
  @override
  List<Object> get props => [];
}
