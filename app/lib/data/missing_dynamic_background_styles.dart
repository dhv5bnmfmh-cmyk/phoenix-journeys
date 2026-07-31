import 'package:flutter/material.dart';

@immutable
class JourneyCinematicStyle {
  const JourneyCinematicStyle({required this.duration, required this.skyColor, required this.atmosphereColor, required this.foregroundColor, required this.cameraTravel, this.waterLight = false});
  final Duration duration;
  final Color skyColor;
  final Color atmosphereColor;
  final Color foregroundColor;
  final Offset cameraTravel;
  final bool waterLight;
}

const missingJourneyCinematicStyles = <String, JourneyCinematicStyle>{
  'harbin-central-street': JourneyCinematicStyle(duration: Duration(seconds: 31), skyColor: Color(0xFFDCEAF4), atmosphereColor: Color(0xFF88A4B8), foregroundColor: Color(0xFF263543), cameraTravel: Offset(10, 8)),
  'kaifeng-song-capital': JourneyCinematicStyle(duration: Duration(seconds: 30), skyColor: Color(0xFFFFD79B), atmosphereColor: Color(0xFFA86D48), foregroundColor: Color(0xFF332018), cameraTravel: Offset(11, 8), waterLight: true),
  'huangshan-cloud-peaks': JourneyCinematicStyle(duration: Duration(seconds: 33), skyColor: Color(0xFFE9F2F5), atmosphereColor: Color(0xFF78949E), foregroundColor: Color(0xFF18342D), cameraTravel: Offset(9, 11)),
  'zhangjiajie-wulingyuan': JourneyCinematicStyle(duration: Duration(seconds: 34), skyColor: Color(0xFFDDEBED), atmosphereColor: Color(0xFF6F9388), foregroundColor: Color(0xFF17342D), cameraTravel: Offset(10, 12)),
  'dali-cangshan-erhai': JourneyCinematicStyle(duration: Duration(seconds: 32), skyColor: Color(0xFFE7F4FA), atmosphereColor: Color(0xFF6EA6B5), foregroundColor: Color(0xFF173B3A), cameraTravel: Offset(11, 7), waterLight: true),
  'wuyishan-nine-bend-stream': JourneyCinematicStyle(duration: Duration(seconds: 34), skyColor: Color(0xFFE7F0E8), atmosphereColor: Color(0xFF76927A), foregroundColor: Color(0xFF173829), cameraTravel: Offset(12, 8), waterLight: true),
  'pingyao-ancient-city': JourneyCinematicStyle(duration: Duration(seconds: 30), skyColor: Color(0xFFF1D2A0), atmosphereColor: Color(0xFF9A704E), foregroundColor: Color(0xFF3A271C), cameraTravel: Offset(10, 7)),
  'kaiping-diaolou-villages': JourneyCinematicStyle(duration: Duration(seconds: 32), skyColor: Color(0xFFE6E9D5), atmosphereColor: Color(0xFF87956B), foregroundColor: Color(0xFF304129), cameraTravel: Offset(11, 8), waterLight: true),
  'yuanyang-hani-rice-terraces': JourneyCinematicStyle(duration: Duration(seconds: 35), skyColor: Color(0xFFF0CFAE), atmosphereColor: Color(0xFF8FA0A0), foregroundColor: Color(0xFF27463A), cameraTravel: Offset(9, 12), waterLight: true),
  'wudang-mountains-ancient-buildings': JourneyCinematicStyle(duration: Duration(seconds: 34), skyColor: Color(0xFFDDE6E2), atmosphereColor: Color(0xFF71877F), foregroundColor: Color(0xFF1C302A), cameraTravel: Offset(9, 11)),
  'taishan-sacred-mountain': JourneyCinematicStyle(duration: Duration(seconds: 34), skyColor: Color(0xFFE4E8E1), atmosphereColor: Color(0xFF7A8174), foregroundColor: Color(0xFF273328), cameraTravel: Offset(9, 12)),
  'lushan-cultural-landscape': JourneyCinematicStyle(duration: Duration(seconds: 35), skyColor: Color(0xFFE6EDF0), atmosphereColor: Color(0xFF82959C), foregroundColor: Color(0xFF213A35), cameraTravel: Offset(10, 11), waterLight: true),
  'emeishan-sacred-ecology': JourneyCinematicStyle(duration: Duration(seconds: 36), skyColor: Color(0xFFDDE9E4), atmosphereColor: Color(0xFF708C80), foregroundColor: Color(0xFF18372B), cameraTravel: Offset(9, 12)),
  'hangzhou-west-lake': JourneyCinematicStyle(duration: Duration(seconds: 33), skyColor: Color(0xFFE9F1EE), atmosphereColor: Color(0xFF88A59F), foregroundColor: Color(0xFF28443C), cameraTravel: Offset(12, 7), waterLight: true),
  'xiamen-gulangyu': JourneyCinematicStyle(duration: Duration(seconds: 32), skyColor: Color(0xFFE8F2F4), atmosphereColor: Color(0xFF80A2A8), foregroundColor: Color(0xFF28413F), cameraTravel: Offset(11, 8), waterLight: true),
};
