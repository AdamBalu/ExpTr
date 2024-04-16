import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/common/widget/custom_stream_builder.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:flutter/material.dart';

import '../../plans/model/plan.dart';
import '../../plans/service/plan_service.dart';
import '../../user/model/user.dart';

class Invitations extends StatelessWidget {
  Invitations({super.key});

  final _userService = get<UserService>();
  final _planService = get<PlanService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invitations"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomStreamBuilder(
            stream: _userService.observeUser(_userService.currentUserId),
            builder: (context, AsyncSnapshot<User> snapshot) {
              final user = snapshot.data!;

              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemBuilder: (context, index) {
                    return CustomStreamBuilder(
                      stream: _planService.observeSelectedPlan(user.invitations[index]),
                      builder: (context, AsyncSnapshot<Plan> snapshot) {
                        var plan = snapshot.data!;
                        return Row(children: [
                          Text(
                            plan.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const Spacer(),
                          MaterialButton(
                              height: 50,
                              onPressed: () => {_userService.handlePlanInvitation(user, plan)},
                              shape: const CircleBorder(),
                              color: const Color.fromRGBO(0, 255, 0, 0.2),
                              elevation: 0,
                              child: const Icon(Icons.check)),
                          MaterialButton(
                              height: 50,
                              onPressed: () =>
                                  {_userService.handlePlanInvitation(user, plan, isAccept: false)},
                              color: const Color.fromRGBO(255, 0, 0, 0.2),
                              shape: const CircleBorder(),
                              elevation: 0,
                              child: const Icon(Icons.close))
                        ]);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 1,
                  ), // Smaller gap
                  itemCount: user.invitations.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
