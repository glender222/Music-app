import 'package:get/get.dart';
import '../repository/settings_repository.dart';

class SetStreamingQualityUseCase {
  final SettingsRepository _settingsRepository = Get.find<SettingsRepository>();

  Future<void> call(AudioQuality quality) {
    return _settingsRepository.setStreamingQuality(quality);
  }
}
