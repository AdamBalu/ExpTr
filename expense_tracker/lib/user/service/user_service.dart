import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/common/service/common_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../../plans/model/plan.dart';
import '../../plans/service/plan_service.dart';
import '../model/user.dart' as app_user;
import '../../common/utils/firebase_id.dart';
import '../../common/service/ioc_container.dart';

class UserService {
  final _planService = get<PlanService>();

  final _commonService = get<CommonService>();

  // hold current user
  String _currentUserId = "";
  get currentUserId => _currentUserId;

  // login err messages
  final _errMessageStreamController = BehaviorSubject<String>.seeded("");
  get errMessageStream => _errMessageStreamController.stream;

  // firebase auth for user login check
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // stream for user that is logged in
  final StreamController<app_user.User> _currentUserController = BehaviorSubject<app_user.User>();
  Stream<app_user.User?> get currentUserControllerStream => _currentUserController.stream;

  final _userCollection = FirebaseFirestore.instance.collection('users').withConverter(
        fromFirestore: (snapshot, _) =>
            app_user.User.fromJson(withId(snapshot.data()!, snapshot.id)),
        toFirestore: (value, _) => withoutId(value.toJson()),
      );

  // manage logged/registered user constructor
  UserService() {
    manageUser();
  }

  Future<void> manageUser() async {
    _firebaseAuth.authStateChanges().listen((User? user) async {
      if (user != null) {
        _currentUserId = user.uid;

        var userData = await getUser(user.uid);
        if (userData != null) {
          _currentUserController.add(userData);
        }
      }
    });
  }

  Future<void> changeUsername(String userId, String newUsername) async {
    await _userCollection.doc(userId).update({"username": newUsername});
  }

  Future<void> updateEmail(String oldEmail, String newEmail, String password) async {
    final emailCredential = EmailAuthProvider.credential(email: oldEmail, password: password);
    await _firebaseAuth.currentUser?.reauthenticateWithCredential(emailCredential);
    await _firebaseAuth.currentUser?.verifyBeforeUpdateEmail(newEmail);
    await _firebaseAuth.currentUser?.updateEmail(newEmail);
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final userEmail = _firebaseAuth.currentUser!.email;

    if (userEmail != null) {
      final emailCredential = EmailAuthProvider.credential(email: userEmail, password: oldPassword);
      await _firebaseAuth.currentUser?.reauthenticateWithCredential(emailCredential);
      await _firebaseAuth.currentUser?.updatePassword(newPassword);
    }
  }

  Future<app_user.User?> getUser(String userId) async {
    var docSnapshot = await _userCollection.doc(userId).get();
    return docSnapshot.data();
  }

  Future<void> createUser(app_user.User user) async {
    var newUser = app_user.User(user.username, user.id, []);
    await _userCollection.doc(newUser.id).set(newUser);
    await _planService.createPlan(newUser.id, "Personal plan", true, 30, true);
  }

  Stream<app_user.User> observeUser(String userId) {
    return _userCollection.where(FieldPath.documentId, isEqualTo: userId).snapshots().map(
        (querySnapshot) =>
            querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList().first);
  }

  Future<void> assignGroup(String groupId, String userId) async {
    var userDoc = _userCollection.doc(userId);
    await userDoc.update({
      'groups': FieldValue.arrayUnion([groupId])
    });
  }

  void userLogin(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      _errMessageStreamController.add("");
    } on FirebaseAuthException catch (err) {
      _errMessageStreamController.add(err.message!);
    }
  }

  Future<void> userRegister(
      String email, String password, String confirmPassword, String userName) async {
    try {
      if (password == confirmPassword) {
        var newUser =
            await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

        if (newUser.user != null) {
          await createUser(app_user.User(userName, newUser.user!.uid, []));
        }
      }
      _errMessageStreamController.add("");
    } on FirebaseAuthException catch (err) {
      _errMessageStreamController.add(err.message!);
    }
  }

  Future<void> handlePlanInvitation(app_user.User user, Plan plan, {bool isAccept = true}) async {
    if (isAccept) {
      await _planService.addUser(user, plan);
    }

    user.invitations.remove(plan.id);
    await _userCollection.doc(user.id).update({"invitations": user.invitations});
  }

  Future<void> inviteUserToPlan(String username, Plan plan) async {
    if (username == "") return;

    // retrieve data and add user
    var querySnapshot =
        await _userCollection.limit(1).where(("username"), isEqualTo: username).get();

    if (querySnapshot.docs.isNotEmpty) {
      String userId = querySnapshot.docs.map((e) => e.data().id).first;

      // get reference to user document
      var docRef = _userCollection.doc(userId);
      var docSnapshot = await docRef.get();
      var data = docSnapshot.data();

      if (docSnapshot.exists && data != null) {
        // check if user is not part of the list already
        if (plan.users.contains(data.id)) {
          _commonService.throwToastNotification("User is already a part of the plan");
          return;
        }

        if (data.invitations.contains(plan.id)) {
          _commonService.throwToastNotification("The user has already been invited");
        } else {
          _commonService.throwToastNotification("The user has been invited");
          data.invitations.add(plan.id);
          await docRef.update({"invitations": data.invitations});
        }
      }
    } else {
      _commonService.throwToastNotification("User does not exist");
    }
  }

  void userLogout() {
    _firebaseAuth.signOut();
  }
}
