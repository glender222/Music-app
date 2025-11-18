import 'package:get/get.dart';
import '../repository/settings_repository.dart';

class GetStreamingQualityUseCase {
  final SettingsRepository _settingsRepository = Get.find<SettingsRepository>();

  AudioQuality call() {
    return _settingsRepository.getStreamingQuality();
  }
}
