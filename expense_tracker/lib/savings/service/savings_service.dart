import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/common/service/common_service.dart';
import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:uuid/uuid.dart';

import '../../common/utils/firebase_id.dart';
import '../../plans/model/plan.dart';
import '../model/saving.dart';

class SavingsService {
  final _planService = get<PlanService>();
  final _commonService = get<CommonService>();

  final _savingsCollection = FirebaseFirestore.instance.collection('savings').withConverter(
        fromFirestore: (snapshot, _) => Saving.fromJson(withId(snapshot.data()!, snapshot.id)),
        toFirestore: (value, _) => withoutId(value.toJson()),
      );

  Stream<List<Saving>> observeGroupSavings(List<String> savingsIds) {
    if (savingsIds.isNotEmpty) {
      return _savingsCollection.where(FieldPath.documentId, whereIn: savingsIds).snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
    } else {
      return Stream.value([]);
    }
  }

  Future<void> createSaving(String name, double requiredValue, int color) async {
    var newSaving = Saving(name, const Uuid().v4(), 0, requiredValue, color);
    await _savingsCollection.doc(newSaving.id).set(newSaving);
    await _planService.addSaving(newSaving);
  }

  Future<bool> deleteSaving(String savingId, Plan plan) async {
    bool isDeleted = false;
    var docRef = _savingsCollection.doc(savingId);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data != null) {
      plan.savings.remove(savingId);

      try {
        await _planService.editPlan(plan.copyWith(savings: plan.savings));
        await _planService.updateExtraBudget(plan.extraBudget + data.currentValue, plan);
        await docRef.delete();
      } catch (e) {
        _commonService.throwToastNotification("Could not delete saving");
        isDeleted = true;
      }
    }

    return isDeleted;
  }

  Future<List<Saving>> getSavingsFromList(List<String> savingIds) async {
    if (savingIds.isNotEmpty) {
      final querySnapshot =
          await _savingsCollection.where(FieldPath.documentId, whereIn: savingIds).get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    }

    return [];
  }

  Future<bool> addMoneyToSaving(Saving saving, double value, Plan plan) async {
    var docRef = _savingsCollection.doc(saving.id);
    var docSnapshot = await docRef.get();
    var data = docSnapshot.data();

    if (data != null) {
      double newValue = data.currentValue + value;

      if (newValue > data.requiredValue && data.requiredValue != data.currentValue) {
        _planService.updateExtraBudget(plan.extraBudget - (newValue - data.requiredValue), plan);
        newValue = data.requiredValue;
      } else {
        if (plan.extraBudget >= value) {
          _planService.updateExtraBudget(plan.extraBudget - value, plan);
        } else {
          _commonService.throwToastNotification("Insufficient balance");
          return false;
        }
      }

      await docRef.update({"currentValue": newValue});
      return true;
    }

    _commonService.throwToastNotification("Error retrieving plan data, try again");
    return false;
  }
}
