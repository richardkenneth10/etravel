class ETravelDB {
  // ETravelDB(this.auth);

  // final FirebaseAuthService auth;
  // final store = FirebaseFirestore.instance;

  // CollectionReference<Map<String, dynamic>> get users =>
  //     store.collection(usersPath);

  // DocumentReference<Map<String, dynamic>> get user {
  //   if (auth.user == null) {
  //     throw const ETravelException('User is not logged in');
  //   }
  //   return users.doc(auth.user!.uid);
  // }

  static get usersPath => 'users';
}
