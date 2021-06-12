import 'package:secondhand_sharing/generated/l10n.dart';

class Application {
  int chattingWithUserId;
  int watchingItemId;

  static final Application _singleton = Application._create();

  factory Application() {
    return _singleton;
  }

  Application._create();
}
