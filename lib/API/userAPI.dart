import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/usermodel.dart';

final _auth = FirebaseAuth.instance;

class userAPI {
  static AppUser? _loggedInUser;

  static AppUser? get loggedInUser {
    return _loggedInUser;
  }

// SignIn
  Future<AppUser?> signIn(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => uid);

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      final user =
          users.where("uid", isEqualTo: userCredential?.user?.uid).get().then(
        (querySnapshot) {
          final userData =
              querySnapshot.docs.first.data() as Map<String, dynamic>;
          final user = AppUser.fromMap(userData);
          _loggedInUser = user;
          return user;
        },
      );
      return user;

      //return uid.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return null;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<AppUser?> getLoggedInAppUser() {
    return getAppUserFromUid(_loggedInUser?.uid ?? "");
  }

  Future<AppUser?> getAppUserFromUid(String uid) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      //TODO : replace this logic with collection map

      final user = users.where("uid", isEqualTo: uid).get().then(
        (querySnapshot) {
          final userData =
              querySnapshot.docs.first.data() as Map<String, dynamic>;
          final user = AppUser.fromMap(userData);
          _loggedInUser = user;
          return user;
        },
      );
      return user;

      //return uid.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return null;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }

  // SignUp
  Future<AppUser?> signUp(
      String email, String password, String name, String mobile) async {
    try {
      final userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(value.user!.uid)
              .set(
            {
              'email': email,
              'uid': value.user!.uid,
              'name': name,
              'mobile': mobile,
              'favoriteSongIds': [],
              'allowEdit': false,
            },
          );
          return value;
        },
      );
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      final user =
          users.where("uid", isEqualTo: userCredential.user?.uid).get().then(
        (querySnapshot) {
          final userData =
              querySnapshot.docs.first.data() as Map<String, dynamic>;
          final user = AppUser.fromMap(userData);
          _loggedInUser = user;
          return user;
        },
      );
      return user;

      //return uid.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Email already is in use');
        return null;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Reset Password

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      }
      return false;
    }
  }

// signout
  dynamic logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  // add favSongs in favorite list
  Future<void> addSongToFavorite(String? songId) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var songIds;
    await collection.doc(loggedInUser!.uid).get().then(
      (DocumentSnapshot ds) {
        songIds = ds['favoriteSongIds'];

        //print(songIds);
      },
    );
    //print(songIds);

    var favSongs = songIds as List<dynamic>?;
    if (songId != null && favSongs != null && !favSongs.contains(songId)) {
      favSongs.add(songId);
      print(songIds);
    }

    collection
        .doc(loggedInUser!.uid)
        .update({'favoriteSongIds': songIds})
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

// remove favSongs from favorite list
  Future<void> removeSongFromFavorite(String? id) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var songIds;
    await collection.doc(loggedInUser!.uid).get().then(
      (DocumentSnapshot ds) {
        songIds = ds['favoriteSongIds'];

        //print(songIds);
      },
    );
    //print(songIds);
    var favSongs = songIds as List<dynamic>?;
    if (id != null && favSongs != null && favSongs.contains(id)) {
      favSongs.remove(id);
      //print(songIds);
    }

    collection
        .doc(loggedInUser!.uid)
        .update({'favoriteSongIds': songIds})
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  Future<List<dynamic>> getFavoriteSongIdsFromUid(String? uid) async {
    var songIds;
    //var favSongs;
    var collection = FirebaseFirestore.instance.collection('users');
    await collection.doc(uid).get().then(
      (DocumentSnapshot ds) {
        Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
        // You can then retrieve the value from the Map like this:
        songIds = data['favoriteSongIds'];
        // songIds = ds['favoriteSongs'];
        print(songIds);
        //favSongs = songIds as List<String>?;
        //print(favSongs);
        // return favSongs;
      },
    );
    return songIds as List<dynamic>;
  }

  Future<List<dynamic>> getFavoriteSongIdsOfCurrentUser() async {
    return getFavoriteSongIdsFromUid(_auth.currentUser?.uid);
  }
}
