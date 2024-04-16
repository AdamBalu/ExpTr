import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/budget/service/budget_service.dart';
import 'package:expense_tracker/common/enums/saving_category.dart';
import 'package:expense_tracker/common/service/common_service.dart';
import 'package:uuid/uuid.dart';

import '../../common/service/ioc_container.dart';
import '../../common/utils/firebase_id.dart';
import '../../plans/model/plan.dart';
import '../../plans/service/plan_service.dart';
import '../model/purchase.dart';

class PurchaseService {
  final _budgetService = get<BudgetService>();
  final _planService = get<PlanService>();
  final _commonService = get<CommonService>();

  final _purchaseCollection = FirebaseFirestore.instance.collection('purchases').withConverter(
        fromFirestore: (snapshot, _) => Purchase.fromJson(withId(snapshot.data()!, snapshot.id)),
        toFirestore: (value, _) => withoutId(value.toJson()),
      );

  Stream<List<Purchase>> observeGroupPurchases(List<String> purchaseIds) {
    if (purchaseIds.isNotEmpty) {
      return _purchaseCollection.where(FieldPath.documentId, whereIn: purchaseIds).snapshots().map(
          (querySnapshot) => querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
    } else {
      return Stream.value([]);
    }
  }

  Future<List<Purchase>> getPurchasesFromList(List<String> purchaseIds) async {
    if (purchaseIds.isNotEmpty) {
      final querySnapshot =
          await _purchaseCollection.where(FieldPath.documentId, whereIn: purchaseIds).get();
      return querySnapshot.docs.map((e) => e.data()).toList();
    }

    return [];
  }

  Future<bool> deletePurchase(String purchaseId) async {
    bool isDeleted = false;
    var docRef = _purchaseCollection.doc(purchaseId);
    var docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      docRef.delete();
      isDeleted = true;
    }

    return isDeleted;
  }

  Future<void> createPurchase(String name, String description, double cost, ItemCategory category,
      DateTime date, Plan plan) async {
    String location = _commonService.path != ""
        ? await _commonService.uploadImage(File(_commonService.path))
        : "";

    var newPurchase =
        Purchase(name, description, cost, category, const Uuid().v4(), date, location);

    bool isBudgetSet = false;
    var budgets = await _budgetService.getBudgetsFromList(plan.categoryBudgets);

    for (int i = 0; i < budgets.length; i++) {
      if (budgets[i].itemCategory == category) {
        if (budgets[i].usedValue >= cost) {
          budgets[i] = budgets[i].copyWith(usedValue: budgets[i].usedValue - cost);
          _budgetService.updateBudgetValue(budgets[i]);
          isBudgetSet = true;
          break;
        }
      }
    }

    if (isBudgetSet) {
      await _planService.addPurchase(newPurchase);
      await _purchaseCollection.doc(newPurchase.id).set(newPurchase);
    } else {
      _commonService.throwToastNotification("Insufficient budget");
      return;
    }

    // set path to empty string for next purchases
    _commonService.path = "";
  }
}
