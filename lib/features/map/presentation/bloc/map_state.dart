part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

final class MapInitial extends MapState {}

final class MapLoaded extends MapState {
  const MapLoaded(this.mapWindow, {this.openSheet = false});

  final MapWindow mapWindow;
  final bool openSheet;

  @override
  List<Object> get props => [mapWindow, openSheet];

  MapLoaded copyWith({MapWindow? mapWindow, bool? openSheet}) {
    return MapLoaded(
      mapWindow ?? this.mapWindow,
      openSheet: openSheet ?? this.openSheet,
    );
  }
}
