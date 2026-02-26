import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxExtension on num {
  /// Responsive vertical space — e.g. `16.hBox`
  SizedBox get hBox => SizedBox(height: toDouble().h);

  /// Responsive horizontal space — e.g. `16.wBox`
  SizedBox get wBox => SizedBox(width: toDouble().w);
}
