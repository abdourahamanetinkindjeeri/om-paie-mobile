
import 'package:om_paie_flutter/core/data/services/api.service.impl.dart';
import 'package:om_paie_flutter/features/users/user.entity.dart';

class UserService {
  final ApiServiceImpl api;

  UserService(this.api);

  Future<List<User>> getUsers() async {
    final data = await api.get('users');
    return data.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<User> getByIdUser(String idUser) async {
    final data = await api.getByPath("users", idUser);
    return User.fromJson(data);
  }

  /// Récupérer le QR code de l'utilisateur (format SVG)
  Future<String> getUserQrCode() async {
    return await api.getRaw("user/qrcode");
  }

  // Future<void> getUserById(String id) async {
  //   final user = await api.getByPath("users", id);
  //   print("👤 ${user['nom']} ${user['prenom']} - ${user['email']}");
  // }

}