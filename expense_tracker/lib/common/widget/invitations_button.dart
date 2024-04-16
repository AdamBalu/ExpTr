import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/common/widget/custom_stream_builder.dart';
import 'package:expense_tracker/invitations/widget/Invitations.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:flutter/material.dart';

import '../../user/model/user.dart';

class InvitationsButton extends StatelessWidget {
  InvitationsButton({Key? key}) : super(key: key);

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilder(
        stream: _userService.observeUser(_userService.currentUserId),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          final user = snapshot.data!;

          return Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications,
                    size: 30.0, color: Theme.of(context).colorScheme.tertiary),
                onPressed: () => {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Invitations()))
                },
              ),
              Positioned(
                right: 13,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  constraints:
                      const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    "${user.invitations.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
