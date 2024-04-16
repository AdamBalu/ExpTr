import 'package:camera/camera.dart';
import 'package:expense_tracker/budget/service/budget_service.dart';
import 'package:expense_tracker/common/service/common_service.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:expense_tracker/purchases/service/purchase_service.dart';
import 'package:expense_tracker/savings/service/savings_service.dart';
import 'package:get_it/get_it.dart';

import '../../plans/service/plan_service.dart';

final get = GetIt.instance;

class IoCContainer {
  IoCContainer._();

  static void initialize(List<CameraDescription> cameras) {
    GetIt.instance.registerSingleton(CommonService(cameras));

    GetIt.instance.registerSingleton(PlanService());
    GetIt.instance.registerSingleton(UserService());
    GetIt.instance.registerSingleton(SavingsService());
    GetIt.instance.registerSingleton(BudgetService());
    GetIt.instance.registerSingleton(PurchaseService());
  }
}
