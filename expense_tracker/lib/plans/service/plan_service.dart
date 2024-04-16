import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/budget/model/budget.dart';
import 'package:expense_tracker/common/service/common_service.dart';
import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/purchases/model/purchase.dart';
import 'package:expense_tracker/savings/model/saving.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import '../../user/model/user.dart';
import '../model/plan.dart';
import '../../common/utils/firebase_id.dart';

class SelectedPlan {
  final Plan plan;
  final bool isNew;

  SelectedPlan(this.plan, this.isNew);

  SelectedPlan copyWith({Plan? plan, bool? isNew}) {
    return SelectedPlan(plan ?? this.plan, isNew ?? this.isNew);
  }
}

class PlanService {
  final _commonService = get<CommonService>();

  final _planCollection = FirebaseFirestore.instance.collection('plans').withConverter(
        fromFirestore: (snapshot, _) => Plan.fromJson(withId(snapshot.data()!, snapshot.id)),
        toFirestore: (value, _) => withoutId(value.toJson()),
      );

  Stream<List<Plan>> observeUserPlans(String userId) {
    if (userId.isNotEmpty) {
      return _planCollection.where('users', arrayContains: userId).snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
    }

    return Stream.value([]);
  }

  Stream<Plan> observeSelectedPlan(String planId) {
    if (planId.isNotEmpty) {
      return _planCollection.where(FieldPath.documentId, isEqualTo: planId).snapshots().map(
          (querySnapshot) =>
              querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList().first);
    }

    return const Stream.empty();
  }

  // pre-select non existing plan
  final _selectedPlanController = BehaviorSubject<SelectedPlan>.seeded(SelectedPlan(
      Plan([], 0, 0, [], "", "", DateTime.now(), [], false, [], DateTime.now(), 0, 0, ""), false));

  // make sure there is plan pre-selected on load
  bool isPlanSelected = false;

  // stream selected plan based on user selection
  get selectedPlanStream => _selectedPlanController.stream;

  void selectPersonalPlan(Plan plan, bool isNew) {
    _selectedPlanController.add(SelectedPlan(plan, isNew));
  }

  Future<void> getPlanById(String id) async {
    var docSnapshot = await _planCollection.doc(id).get();
    var data = docSnapshot.data();
    if (data != null) {
      _selectedPlanController.add(SelectedPlan(data, false));
    } else {
      _commonService.throwToastNotification("Error retrieving plan data, try again");
    }
  }

  Future<void> editPlan(Plan plan) async {
    var docRef = await _planCollection.doc(plan.id);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      docRef.update(plan.toJson());
    } else {
      _commonService.throwToastNotification("Error retrieving plan data, try again");
    }
  }

  Future<bool> addPurchase(Purchase purchase) async {
    var docRef = _planCollection.doc(_selectedPlanController.stream.value.plan.id);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data == null) {
      _commonService.throwToastNotification("Error retrieving plan data, try again");
      return false;
    }

    data.purchases.add(purchase.id);
    docRef.update({"purchases": data.purchases});
    return true;
  }

  Future<void> addSaving(Saving saving) async {
    var docRef = _planCollection.doc(_selectedPlanController.stream.value.plan.id);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data != null) {
      data.savings.add(saving.id);
      docRef.update({"savings": data.savings});
    } else {
      _commonService.throwToastNotification("Error retrieving plan data, try again");
    }
  }

  Future<bool> addCategoryBudget(Budget budget) async {
    // TODO unify docRef and data in an object
    var docRef = _planCollection.doc(_selectedPlanController.stream.value.plan.id);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data != null) {
      // edit the remaining budget
      if (data.budget >= budget.value) {
        docRef.update({"budget": data.budget - budget.value});
      } else {
        _commonService.throwToastNotification("Insufficient saving plan budget");
        return false;
      }

      data.categoryBudgets.add(budget.id);
      docRef.update({"categoryBudgets": data.categoryBudgets});
    } else {
      _commonService.throwToastNotification("Error retrieving plan data, try again");
    }
    return true;
  }

  Future<bool> updateExtraBudget(double value, Plan plan) async {
    var docRef = _planCollection.doc(plan.id);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      docRef.update({"extraBudget": value});
      return true;
    }
    return false;
  }

  Future<bool> updatePlanInterval(Plan plan) async {
    final currentDate = DateTime.now();
    final difference = currentDate.difference(plan.intervalStart!).inDays;

    if (difference > plan.intervalDuration) {
      // check how many intervals should we shift
      int shiftValue = difference ~/ plan.intervalDuration;

      var docRef = _planCollection.doc(plan.id);
      await docRef.update({
        "intervalStart":
            plan.intervalStart!.add(Duration(days: plan.intervalDuration * shiftValue)),
        "intervalCount": plan.intervalCount + 1,
      });
      return true;
    }

    return false;
  }

  Future<bool> addBudget(double amount) async {
    bool isAdded = false;
    var docRef = _planCollection.doc(_selectedPlanController.stream.value.plan.id);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data != null) {
      if (data.budget + amount > 0) {
        await docRef.update({"budget": data.budget + amount});
        isAdded = true;
      } else {
        _commonService.throwToastNotification("Insufficient budget");
      }
    } else {
      _commonService.throwToastNotification("Error retrieving plan data, try again");
    }

    return isAdded;
  }

  Future<bool> addUser(User user, Plan plan) async {
    var docRef = _planCollection.doc(plan.id);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data != null && user.id != "") {
      data.users.add(user.id);
      await docRef.update({"users": data.users});
      return true;
    }

    _commonService.throwToastNotification("Error retrieving plan data, try again");
    return false;
  }

  // TODO zjednotit
  Future<bool> deleteUser(User user, Plan plan) async {
    var docRef = _planCollection.doc(plan.id);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data != null && user.id != "") {
      data.users.removeWhere((userId) => userId == user.id);
      await docRef.update({"users": data.users});
      return true;
    }

    _commonService.throwToastNotification("Error retrieving plan data, try again");
    return false;
  }

  Future<bool> deletePlan(String planId, {bool forceDelete = false}) async {
    bool isDeleted = false;
    var docRef = _planCollection.doc(planId);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data != null) {
      if (!data.isPersonal && !forceDelete) {
        docRef.delete();
        isDeleted = true;
      } else {
        _commonService.throwToastNotification("Cannot delete personal plan");
        isDeleted = false;
      }
    } else {
      _commonService.throwToastNotification("Error retrieving plan data, try again");
    }

    return isDeleted;
  }

  Future<void> createPlan(
      String userId, String planNam, bool isSelected, int intervalLength, bool isPersonal) async {
    var newPlan = Plan([userId], 0.0, 0.0, [], planNam, const Uuid().v4(), DateTime.now(), [],
        isPersonal, [], DateTime.now(), intervalLength, 0, userId);
    await _planCollection.doc(newPlan.id).set(newPlan);
    _selectedPlanController.add(SelectedPlan(newPlan, true));
  }
}
