import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mt_carplay/mt_carplay.dart';

const _channel = MethodChannel('net.mobitouch.mt_carplay');
const _events = EventChannel('net.mobitouch.mt_carplay/event');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(_channel, null);
    messenger.setMockStreamHandler(_events, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('setNowPlayingUpNextButton sends the state and title', () async {
    MethodCall? sent;
    messenger.setMockMethodCallHandler(_channel, (call) async {
      sent = call;
      return true;
    });

    final isCompleted = await FlutterCarplay.setNowPlayingUpNextButton(
      enabled: true,
      title: 'Queue',
    );

    expect(isCompleted, isTrue);
    expect(sent?.method, 'setNowPlayingUpNextButton');
    expect(sent?.arguments, {'enabled': true, 'title': 'Queue'});
  });

  test('an Up Next tap reaches the listener', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    messenger.setMockStreamHandler(
      _events,
      MockStreamHandler.inline(
        onListen: (_, sink) => sink.success({
          'type': 'onNowPlayingUpNextButtonPressed',
          'data': <String, dynamic>{},
        }),
      ),
    );
    var taps = 0;

    final carplay = FlutterCarplay()
      ..addListenerOnNowPlayingUpNext(() => taps++);
    addTearDown(carplay.closeConnection);
    await pumpEventQueue();

    expect(taps, 1);
  });

  test('a removed Up Next listener is not called', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    messenger.setMockStreamHandler(
      _events,
      MockStreamHandler.inline(
        onListen: (_, sink) => sink.success({
          'type': 'onNowPlayingUpNextButtonPressed',
          'data': <String, dynamic>{},
        }),
      ),
    );
    var taps = 0;

    final carplay = FlutterCarplay()
      ..addListenerOnNowPlayingUpNext(() => taps++)
      ..removeListenerOnNowPlayingUpNext();
    addTearDown(carplay.closeConnection);
    await pumpEventQueue();

    expect(taps, 0);
  });
}
