import 'package:flutter/material.dart';
import 'package:todolist_app/screens/profile/components/passworddata.dart';
import 'package:todolist_app/screens/profile/components/userdata.dart';
import 'package:todolist_app/service/auth_service.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        children: (AuthService.user!.providerData[0].providerId != 'google.com')
            ? [
                ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Profil Information ändern"),
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserData(),
                              ))
                        }),
                ListTile(
                    leading: const Icon(Icons.password),
                    title: const Text("Password ändern"),
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PasswordData(),
                              ))
                        })
              ]
            : [
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                      "Mit Google Account eingeloggt. Für Änderungen gehe auf google.com"),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text("Name: ${AuthService.user!.displayName}"),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text("E-Mail Adresse: ${AuthService.user!.email}"),
                ),
              ],
      ),
    );
  }
}
