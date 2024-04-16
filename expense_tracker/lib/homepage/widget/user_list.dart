import 'package:expense_tracker/homepage/widget/user_list_item.dart';
import 'package:flutter/material.dart';

import '../../budget/service/budget_service.dart';
import '../../common/service/ioc_container.dart';
import '../../common/widget/custom_stream_builder.dart';
import '../../common/widget/custom_text_field.dart';
import '../../plans/model/plan.dart';
import '../../plans/service/plan_service.dart';
import '../../user/model/user.dart';
import '../../user/service/user_service.dart';

class UserList extends StatelessWidget {
  final Plan plan;
  UserList({super.key, required this.plan});

  final _userService = get<UserService>();
  final _planService = get<PlanService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Column(
          children: [
            CustomStreamBuilder<Plan>(
                stream: _planService.observeSelectedPlan(plan.id),
                builder: (context, snapshot) {
                  final planData = snapshot.data!;
                  return Container(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      itemBuilder: (context, index) {
                        final user = planData.users[index];

                        return CustomStreamBuilder(
                          stream: _userService.observeUser(user),
                          builder: (context, AsyncSnapshot<User> snapshot) {
                            final userData = snapshot.data!;
                            return UserListItem(
                              plan: planData,
                              user: userData,
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Container(
                        height: 15,
                      ),
                      itemCount: planData.users.length,
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: () => {_showGroupNameDialog(context, plan)},
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupNameDialog(BuildContext context, Plan plan) {
    TextEditingController username = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            CustomTextField(label: "username", hint: "janko123", controller: username),
            Container(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () => {
                      _userService.inviteUserToPlan(username.text, plan),
                      Navigator.of(context).pop()
                    },
                child: const Center(child: Text("Invite")))
          ],
        );
      },
    );
  }
}
