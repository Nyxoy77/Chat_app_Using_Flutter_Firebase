import 'package:chata/firebase_options.dart';
import 'package:chata/services/alert_services.dart';
import 'package:chata/services/auth_service.dart';
import 'package:chata/services/database_service.dart';
import 'package:chata/services/media_service.dart';
import 'package:chata/services/navigation_service.dart';
import 'package:chata/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );
  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );
  getIt.registerSingleton<AlertServices>(
    AlertServices(),
  );
    getIt.registerSingleton<MediaService>(
    MediaService(),
  );
     getIt.registerSingleton<StorageService>(
    StorageService(),
  );
      getIt.registerSingleton<DatabaseService>(
    DatabaseService(),
  );
  
}

String generateChatID({required String uid1, required String uid2}){
  List uids = [uid1,uid2];
  uids.sort();
  String chatID = uids.fold("", (id,uid) => "$id$uid");
  return chatID;
}
