import 'package:flutter/material.dart';
import 'package:homework_app/widgets/profile/item_list.dart';

import '../widgets/auth/password_reset_dialog.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile_screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final variables = ModalRoute.of(context)!.settings.arguments as List;
    final bool isStudent = variables[0];
    final user = variables[1];

    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(isStudent
                        ? 'assets/avatars/3d_avatar_18.png'
                        : 'assets/avatars/3d_avatar_2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                  )),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  user.surname,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(user.uco,
                      style: Theme.of(context).textTheme.headlineSmall),
                  FilledButton.tonal(
                      onPressed: () async => await showDialog(context: context, builder: (context) => const PasswordResetDialog(),), child: const Text('Zmeniť heslo')),
                ],
              ),
              ItemList(user: user, isStudent: isStudent),
            ],
          ),
        ));
  }
}
