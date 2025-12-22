import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _currentUserKey = 'currentUser';

  // Se connecter avec Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Déconnexion préalable pour forcer la sélection du compte
      await _googleSignIn.signOut();
      
      // Lancer le flux d'authentification Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        return {
          'success': false,
          'message': 'Connexion annulée',
        };
      }

      // Obtenir les détails d'authentification
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Créer un nouveau credential Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Se connecter à Firebase
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return {
          'success': false,
          'message': 'Erreur lors de la connexion Firebase',
        };
      }

      // Créer ou mettre à jour l'utilisateur dans Hive
      final userBox = await Hive.openBox<UserModel>('users');
      
      // Vérifier si l'utilisateur existe déjà
      UserModel? existingUser = userBox.values.firstWhere(
        (user) => user.email.toLowerCase() == firebaseUser.email!.toLowerCase(),
        orElse: () => UserModel(
          id: '',
          firstName: '',
          lastName: '',
          username: '',
          email: '',
          phoneNumber: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      UserModel userModel;

      if (existingUser.id.isEmpty) {
        // Créer un nouvel utilisateur
        final nameParts = firebaseUser.displayName?.split(' ') ?? ['', ''];
        final firstName = nameParts.isNotEmpty ? nameParts[0] : 'User';
        final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        
        userModel = UserModel(
          id: firebaseUser.uid,
          firstName: firstName,
          lastName: lastName,
          username: firebaseUser.email!.split('@')[0],
          email: firebaseUser.email!,
          phoneNumber: firebaseUser.phoneNumber ?? '',
          password: '', // Pas de mot de passe pour Google Sign-In
          createdAt: DateTime.now(),
          isLoggedIn: true,
        );
        
        await userBox.put(userModel.id, userModel);
      } else {
        // Mettre à jour l'utilisateur existant
        existingUser.isLoggedIn = true;
        await existingUser.save();
        userModel = existingUser;
      }

      // Sauvegarder comme utilisateur actuel
      final prefs = await Hive.openBox('preferences');
      await prefs.put(_currentUserKey, userModel.id);

      return {
        'success': true,
        'message': 'Connexion réussie avec Google',
        'user': userModel,
      };
    } catch (e) {
      print('Erreur Google Sign-In: $e');
      return {
        'success': false,
        'message': 'Erreur lors de la connexion: ${e.toString()}',
      };
    }
  }

  // Se déconnecter de Google
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      
      // Mettre à jour le statut dans Hive
      final prefs = await Hive.openBox('preferences');
      final userId = prefs.get(_currentUserKey);
      
      if (userId != null) {
        final userBox = await Hive.openBox<UserModel>('users');
        final user = userBox.get(userId);
        
        if (user != null) {
          user.isLoggedIn = false;
          await user.save();
        }
      }
      
      await prefs.delete(_currentUserKey);
    } catch (e) {
      print('Erreur lors de la déconnexion Google: $e');
    }
  }

  // Vérifier si l'utilisateur est connecté avec Google
  Future<bool> isSignedInWithGoogle() async {
    return await _googleSignIn.isSignedIn();
  }

  // Obtenir l'utilisateur Google actuel
  Future<GoogleSignInAccount?> getCurrentGoogleUser() async {
    return _googleSignIn.currentUser;
  }
}