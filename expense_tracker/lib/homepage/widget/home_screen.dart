import 'package:carousel_slider/carousel_slider.dart';
import 'package:expense_tracker/budget/service/budget_service.dart';
import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/common/widget/custom_stream_builder.dart';
import 'package:expense_tracker/common/widget/invitations_button.dart';
import 'package:expense_tracker/homepage/widget/user_list.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:flutter/material.dart';
import '../../budget/model/budget.dart';
import '../../common/widget/profile_button.dart';
import '../../plans/model/plan.dart';
import '../../plans/widget/plan_item.dart';
import '../../user/model/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userService = get<UserService>();
  final _planService = get<PlanService>();
  final _budgetService = get<BudgetService>();

  final _carouselController = CarouselController();

  bool initLoad = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const ProfileButton(),
          actions: [InvitationsButton()],
        ),
        body: SingleChildScrollView(
          child: CustomStreamBuilder(
            // track selected plan
            stream: _planService.selectedPlanStream,
            builder: (context, AsyncSnapshot<SelectedPlan> snapshot) {
              final selectedPlan = snapshot.data!;
              // observe user groups
              return CustomStreamBuilder(
                stream: _userService.observeUser(_userService.currentUserId),
                builder: (context, snapshot) {
                  final user = snapshot.data!;
                  return CustomStreamBuilder(
                    stream: _planService.observeUserPlans(user.id),
                    builder: (context, AsyncSnapshot<List<Plan>> snapshot) {
                      final plans = snapshot.data!;

                      if (plans.isEmpty) {
                        return const Center(
                            child: Text('No plans yet', style: TextStyle(fontSize: 20)));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(
                            child: Text(
                              "Selected plan",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildPlanView(plans, selectedPlan),
                          const SizedBox(height: 30),
                          const Center(
                            child: Text(
                              "Users",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          UserList(plan: selectedPlan.plan)
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ));
  }

  Widget _buildPlanView(List<Plan> plans, SelectedPlan selectedPlan) {
    // order list by newest entries
    plans.sort((a, b) => (a.isPersonal == b.isPersonal ? 0 : (a.isPersonal ? -1 : 1)));
    final personalPlans = plans.where((plan) => plan.isPersonal == true);

    // index of selected plan
    if (_carouselController.ready && selectedPlan.isNew) {
      final planIndex = plans.indexOf(plans.where((plan) => plan.id == selectedPlan.plan.id).first);
      _carouselController.jumpToPage(planIndex);
    }

    // select personal group
    if (!_planService.isPlanSelected && initLoad && personalPlans.isNotEmpty) {
      _planService.selectPersonalPlan(personalPlans.first, true);
      initLoad = false;
    }
    if (personalPlans.isNotEmpty) {
      return CarouselSlider.builder(
        carouselController: _carouselController,
        options: CarouselOptions(
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            height: 255,
            onPageChanged: (index, _) => {_planService.getPlanById(plans[index].id)}),
        itemCount: plans.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          // check if plan's interval is still valid
          updatePlanInterval(plans[index]);
          return PlanItem(
            plan: plans[index],
            selectedPlan: selectedPlan.plan,
            personalPlan: personalPlans.first,
          );
        },
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  void updatePlanInterval(Plan plan) async {
    final bool isUpdated = await _planService.updatePlanInterval(plan);

    if (isUpdated) {
      final total = await _budgetService.getTotalBudget(plan, isUsedBudget: true);
      await _planService.updateExtraBudget(plan.budget + plan.extraBudget + total, plan);
      await _planService.addBudget(-plan.budget);

      final List<Budget> budgets = await _budgetService.getBudgetsFromList(plan.categoryBudgets);
      for (var budget in budgets) {
        await _budgetService.updateBudgetValue(budget.copyWith(value: 0, usedValue: 0),
            updateTotalValue: true);
      }
    }
  }
}
