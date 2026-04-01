import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(DioClient.createPublic(AppConfig.production)),
);

sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final AuthUser user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkToken();
    return AuthInitial();
  }

  Future<void> _checkToken() async {
    final token = await ref.read(authServiceProvider).getToken();
    if (token != null) {
      // Token présent mais peut être expiré — on le considère valide
      // Le 401 interceptor se chargera de le supprimer si nécessaire
      state = AuthAuthenticated(const AuthUser(id: '', name: '', phone: ''));
    } else {
      state = AuthUnauthenticated();
    }
  }

  Future<String?> login(String phone, String pin) async {
    state = AuthLoading();
    try {
      final user = await ref.read(authServiceProvider).login(phone, pin);
      state = AuthAuthenticated(user);
      return null;
    } catch (e) {
      final msg = _clean(e);
      state = AuthError(msg);
      return msg;
    }
  }

  Future<bool> register(String name, String phone, String pin) async {
    state = AuthLoading();
    try {
      await ref.read(authServiceProvider).register(name, phone, pin);
      state = AuthUnauthenticated();
      return true;
    } catch (e) {
      state = AuthError(_clean(e));
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).logout();
    state = AuthUnauthenticated();
  }

  String _clean(Object e) => e.toString()
      .replaceAll('ApiException(0): ', '')
      .replaceAll('ApiException(400): ', '')
      .replaceAll('Exception: ', '');
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
