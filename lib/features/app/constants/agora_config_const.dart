import 'package:flutter_dotenv/flutter_dotenv.dart';

class AgoraConfig {
  static String get agoraAppId => dotenv.env['AGORA_APP_ID'] ?? '';
  static String get agoraAppCertificate => dotenv.env['AGORA_APP_CERT'] ?? '';
}
