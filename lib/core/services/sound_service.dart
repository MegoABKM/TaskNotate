import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService extends GetxService {
  // Separate players for each sound to allow concurrent playback
  final AudioPlayer _buttonPlayer = AudioPlayer();
  final AudioPlayer _completionPlayer = AudioPlayer();
  bool _isInitialized = false;
  final RxBool _isSoundDisabled =
      false.obs; // Reversed: true means sound is disabled
  DateTime? _lastButtonPlayTime;
  DateTime? _lastCompletionPlayTime;
  final Duration _debounceDuration = const Duration(milliseconds: 100);
  SharedPreferences? _prefs;

  // Audio file paths
  static const _buttonClickSound = 'assets/buttonclick.mp3';
  static const _taskCompletedSound = 'assets/completed.mp3';

  Future<void> init() async {
    try {
      // Initialize SharedPreferences
      _prefs = await SharedPreferences.getInstance();
      _isSoundDisabled.value = _prefs!.getBool('isSoundDisabled') ?? false;

      // Configure audio session to mix with other apps
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.ambient,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.notification,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
      ));

      // Preload sounds
      await _preloadSound(_buttonPlayer, _buttonClickSound, volume: 0.8);
      await _preloadSound(_completionPlayer, _taskCompletedSound, volume: 1.0);

      _isInitialized = true;
      print('✅ SoundService initialized successfully');
    } catch (e, stackTrace) {
      print('❌ Error initializing sound: $e\nStackTrace: $stackTrace');
      _isInitialized = false;
    }
  }

  Future<void> _preloadSound(AudioPlayer player, String path,
      {double volume = 1.0}) async {
    try {
      await player.setAsset(path);
      await player.setVolume(volume.clamp(0.0, 1.0));
      await player.setLoopMode(LoopMode.off);
      await player.stop(); // Ensure player is stopped after preloading
      print('✅ Preloaded sound: $path at volume $volume');
    } catch (e, stackTrace) {
      print('❌ Failed to preload $path: $e\nStackTrace: $stackTrace');
      _isInitialized = false;
      rethrow;
    }
  }

  Future<void> playButtonClickSound() async {
    if (!_isInitialized || _isSoundDisabled.value) {
      print('❌ SoundService not initialized or sound disabled');
      return;
    }

    // Debounce rapid play requests
    final now = DateTime.now();
    if (_lastButtonPlayTime != null &&
        now.difference(_lastButtonPlayTime!) < _debounceDuration) {
      return;
    }
    _lastButtonPlayTime = now;

    try {
      await _buttonPlayer.seek(Duration.zero);
      await _buttonPlayer.play();
      print('🔊 Played button click sound at $now');
    } catch (e, stackTrace) {
      print('❌ Error playing button sound: $e\nStackTrace: $stackTrace');
      await _recoverPlayer(_buttonPlayer, _buttonClickSound, volume: 0.8);
    }
  }

  Future<void> playTaskCompletedSound() async {
    if (!_isInitialized || _isSoundDisabled.value) {
      print('❌ SoundService not initialized or sound disabled');
      return;
    }

    // Debounce rapid play requests
    final now = DateTime.now();
    if (_lastCompletionPlayTime != null &&
        now.difference(_lastCompletionPlayTime!) < _debounceDuration) {
      return;
    }
    _lastCompletionPlayTime = now;

    try {
      await _completionPlayer.seek(Duration.zero);
      await _completionPlayer.play();
      print('🔊 Played task completed sound at $now');
    } catch (e, stackTrace) {
      print('❌ Error playing completion sound: $e\nStackTrace: $stackTrace');
      await _recoverPlayer(_completionPlayer, _taskCompletedSound, volume: 1.0);
    }
  }

  Future<void> _recoverPlayer(AudioPlayer player, String assetPath,
      {double volume = 1.0}) async {
    try {
      await player.stop();
      await player.setAsset(assetPath);
      await player.setVolume(volume.clamp(0.0, 1.0));
      print('✅ Recovered player for $assetPath');
    } catch (e, stackTrace) {
      print('❌ Failed to recover player: $e\nStackTrace: $stackTrace');
    }
  }

  Future<void> toggleSound(bool disabled) async {
    _isSoundDisabled.value = disabled;
    await _prefs?.setBool('isSoundDisabled', disabled);
    print('🔊 Sound ${disabled ? 'disabled' : 'enabled'}');
  }

  bool get isSoundDisabled => _isSoundDisabled.value;

  @override
  void onClose() {
    _buttonPlayer.dispose();
    _completionPlayer.dispose();
    super.onClose();
  }
}
