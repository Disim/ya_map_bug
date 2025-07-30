# Описание проблемы
При тапе на PlacemarkMapObject должен открываться BottomSheet с описанием объекта.
Для этого в userData PlacemarkMapObject я передаю метод, который вызывает событие в BLoC.

# Проблема
Событие в MapObjectTapListener срабатывает, но:
1. UI не обновляется до тех пор, пока не произойдет взаимодействия с картой
2. Если этот же метод вызвать через обычную кнопку (не через Placemark) — всё работает мгновенно

## Пример кода
Listener выглядит следующим образом
```dart
final class MapObjectTapListenerImpl implements MapObjectTapListener {
  @override
  bool onMapObjectTap(MapObject mapObject, Point point) {
    if (mapObject.userData is void Function()) {
      (mapObject.userData as void Function())();
    }
    return true;
  }
}
```

Так добавляется метка на карту
```dart
/// Если нажать на маркер, то BottomSheet не откроется сразу, а только
/// после повторного нажатия, либо после взаимодействия с картой.
event.mapWindow.map.mapObjects.addPlacemark()
  ..geometry = const Point(latitude: 55.751225, longitude: 37.62954)
  ..setIcon(imageProvider)
  ..addTapListener(listener)
  ..userData = () {
    add(MapOpenBottomSheetEvent());
  };
```
Как и говорилось ранее, если вызвать add(MapOpenBottomSheetEvent()) через кнопку в ui, то задержек не будет.

# Дополнительно
Пробовал по нажатию на PlacemarkMapObject вызывать stream.add(Объект), вместо add(MapOpenBottomSheetEvent()) там ситуация та же - подписчики на стрим не получают данные, пока не будет произведено действий с картой. Как понимаю, проблема происходит с любыми асинхронными взаимодействиями.

Проблему проверял на iOS и android, везде воспроизводится одинаково.
yandex_maps_mapkit_lite: ^4.19.0-beta
Dart 3.8.1 

[✓] Flutter (Channel stable, 3.32.8, on macOS 15.5 24F74 darwin-arm64, locale ru-RU)
[✓] Android toolchain - develop for Android devices (Android SDK version 35.0.1)
[✓] Xcode - develop for iOS and macOS (Xcode 16.3)
[✓] Android Studio (version 2024.3)

# Репозиторий
Собрал демонстрацию данной проблемы и залил к себе на Git.
[Репозиторий с описанной проблеймой](https://github.com/Disim/ya_map_bug)