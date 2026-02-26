import 'package:get_it/get_it.dart';

/// A factory that creates BLoC instances via GetIt.
/// Register blocs as [Factory] in each feature's injection module
/// so each call to [create] produces a fresh instance.
class BlocFactory {
  const BlocFactory(this._sl);

  final GetIt _sl;

  T create<T extends Object>() => _sl<T>();
}
