import 'package:flutter/material.dart';

import '../../common/service/ioc_container.dart';
import '../../plans/model/plan.dart';
import '../../plans/service/plan_service.dart';
import '../../user/model/user.dart';
import '../../user/service/user_service.dart';

class UserListItem extends StatelessWidget {
  final Plan plan;
  final User user;
  UserListItem({super.key, required this.plan, required this.user});

  final _userService = get<UserService>();
  final _planService = get<PlanService>();

  @override
  Widget build(BuildContext context) {
    bool canEdit = plan.ownerId == _userService.currentUserId;
    bool isOwner = plan.ownerId == user.id;

    return Row(
      children: [
        isOwner ? const Icon(Icons.badge_outlined) : const Icon(Icons.account_box_outlined),
        Container(
          width: 10,
        ),
        Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (canEdit && !isOwner)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              child: const Icon(Icons.clear, size: 20.0),
              onTap: () => {_planService.deleteUser(user, plan)},
            ),
          ),
      ],
    );
  }
}
