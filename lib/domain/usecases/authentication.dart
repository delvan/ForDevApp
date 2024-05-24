import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParms parms);
}

class AuthenticationParms {
  final String email;
  final String secret;

  AuthenticationParms({required this.email, required this.secret});

  Map toJson() => {'email': email, 'password': secret};
}
