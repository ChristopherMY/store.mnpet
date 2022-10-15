import 'dart:async';

import 'package:flutter/foundation.dart';

class SplashBloc extends ChangeNotifier {
  ValueNotifier<int> countdown = ValueNotifier(4);

}
