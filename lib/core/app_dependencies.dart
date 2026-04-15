import 'package:parking/data/local_user_repository.dart';
import 'package:parking/data/user_repository.dart';

class AppDependencies {
  AppDependencies._();
  static final AppDependencies _instance = AppDependencies._();
  factory AppDependencies() => _instance;

  final UserRepository userRepository = LocalUserRepository();
}
