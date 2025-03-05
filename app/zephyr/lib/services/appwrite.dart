import 'package:appwrite/appwrite.dart';

class AppWriteService {
  late final Client _client;
  late final Account _account;
  late final Databases _databases;

  AppWriteService() {
    _client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject('67c2a2b1002122a8b27e');
    _account = Account(_client);
    _databases = Databases(_client);
  }

  void listDocuments() async {
  }
}
