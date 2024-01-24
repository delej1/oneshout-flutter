// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:oneshout/bootstrap.dart';
import 'package:oneshout/firebase_options.dart';

const environment = 'development';
void main() {
  bootstrap(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
