import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppWriteService {
  late final Client _client;
  late final Account _account;

  AppWriteService() {
    _client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject('67c2a2b1002122a8b27e');
    _account = Account(_client);
  }

  Future<User> login(String email, String password) async {
    try{
      await _account.createEmailPasswordSession(email: email, password: password);
      final user = await _account.get();
      return user;
    } catch(err){
      print(err);
      throw Exception("Login failed: $err");
    }
  }
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current'); // Logs out the current session
      print("User logged out successfully.");
    } catch (err) {
      print("Logout failed: $err");
      throw Exception("Logout failed: $err"); // Ensure proper error handling
    }
  }
}
