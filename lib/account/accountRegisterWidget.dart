import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jchatapp/account/accountManager.dart';
import 'package:jchatapp/main.dart';

class AccountRegisterScreen extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  AccountRegisterScreen(Map<dynamic, dynamic> given_data) {
    data = given_data;
  }

  @override
  AccountRegisterHome createState() => AccountRegisterHome(data);
}

class AccountRegisterHome extends State<AccountRegisterScreen> {

  late Map<dynamic, dynamic> data;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();

  String CapicatlAlph = "QWERTYUIOPASDFGHJKLZXCVBNM";
  String SmallAlph = "qwertyuiopasdfghjklzxcvbnm";
  String specialAlph = "_-+=!@#\$%^&*()<>?:\\`~<>./,;'\"{}|";
  String numbersAlph = "1234567890";

  String smallLetters = "🔴";
  String capitalLetters = "🔴";
  String numbers = "🔴";
  String specialLetters = "🔴";

  String error = "";
  String suss = "";

  bool _passwordVisible = false;

  AccountRegisterHome(Map<dynamic, dynamic> given_data) {
    data = given_data;
    if (data.containsKey("captcha_stats") && data.containsKey("name") &&
        data.containsKey("email") && data.containsKey("password") && data["captcha_stats"]) {
      Future.delayed(const Duration(microseconds: 1), () async {
          if (!await AccountManager.createAccount(data["name"], data["email"], data["password"])) {
            setState(() {
              error = "Can't create this account";
            });

          } else {
            setState(() {
              suss = "Account created";
            });
          }
          data.remove("captcha_stats");
          data.remove("email");
          data.remove("password");
          data.remove("name");
          data.remove("on_success_path");
          data.remove("on_fail_path");
      });
    }
  }

  void registerUser()  {
    data["on_success_path"] = "/register";
    data["on_fail_path"] = "/register";
    data["name"] = nameController.text;
    data["password"] = passwordController.text;
    data["email"] = emailController.text;
    Navigator.pushNamed(context, "/captcha", arguments: data);
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(54, 54, 54, 100),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ClientConfig.welcome_background),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                    child: Center(
                        child: Column(children: [
                          const SizedBox(height: 100.0),
                          Container(
                              //height: bigBlack,
                              padding: const EdgeInsets.only(bottom: 30),
                              width: Platform.isAndroid || Platform.isIOS ? 300 : 500,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20.0),
                                  top: Radius.circular(20.0),
                                ),
                              ),
                              child: Column(children: [
                            const SizedBox(height: 30.0),
                                Text("Create an account",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Platform.isAndroid || Platform.isIOS ? 20 : 40)),
                            const SizedBox(height: 20.0),
                            Text(error, style: const TextStyle(color: Colors.red)),
                                Text(suss, style: const TextStyle(color: Colors.green)),
                            SizedBox(
                              width: 200.0,
                              child: TextField(
                                  controller: nameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0)
                                      ),
                                      hintText: 'Name',
                                      labelText: "Name",
                                      hintStyle: const TextStyle(color: Color.fromRGBO(54, 54, 54, 100))),
                                )
                            ),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              width: 200.0,
                              child: TextField(
                                controller: emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    labelText: "Email",
                                    hintText: 'Email',
                                    hintStyle: const TextStyle(color: Color.fromRGBO(54, 54, 54, 100))),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              width: 200.0,
                              child: TextField(
                                onChanged: (value) {
                                  for (int i = 0; i < CapicatlAlph.length; i++) {
                                    if (value.contains(CapicatlAlph[i])) {
                                      setState(() {
                                        capitalLetters = "🟢";
                                      });
                                      break;
                                    } else {
                                      setState(() {
                                        capitalLetters = "🔴";
                                      });
                                    }
                                  }
                                  for (int i = 0; i < SmallAlph.length; i++) {
                                    if (value.contains(SmallAlph[i])) {
                                      setState(() {
                                        smallLetters = "🟢";
                                      });
                                      break;
                                    } else {
                                      setState(() {
                                        smallLetters = "🔴";
                                      });
                                    }
                                  }
                                  for (int i = 0; i < specialAlph.length; i++) {
                                    if (value.contains(specialAlph[i])) {
                                      setState(() {
                                        specialLetters = "🟢";
                                      });
                                      break;
                                    } else {
                                      setState(() {
                                        specialLetters = "🔴";
                                      });
                                    }
                                  }
                                  for (int i = 0; i < numbersAlph.length; i++) {
                                    if (value.contains(numbersAlph[i])) {
                                      setState(() {
                                        numbers = "🟢";
                                      });
                                      break;
                                    } else {
                                      setState(() {
                                        numbers = "🔴";
                                      });
                                    }
                                  }
                                },
                                controller: passwordController,
                                style: const TextStyle(color: Colors.white),
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    hintText: 'Password',
                                    labelText: "Password",
                                    hintStyle: const TextStyle(color: Color.fromRGBO(54, 54, 54, 100))),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text("$capitalLetters ABC",
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 5.0),
                            Text("$smallLetters abc",
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 5.0),
                            Text("$specialLetters !.@_", style: const TextStyle(color: Colors.white)),
                            const SizedBox(height: 5.0),
                            Text("$numbers 123",
                                style: const TextStyle(color: Colors.white)),

                            const SizedBox(height: 30.0),
                            ElevatedButton(
                              onPressed: () {
                                if (nameController.text.isEmpty) {
                                  setState(() {
                                    error = "Name required";
                                  });
                                  return;
                                }

                                if (emailController.text.isEmpty) {
                                  setState(() {
                                    error = "Email required";
                                  });
                                  return;
                                }

                                if (passwordController.text.isEmpty) {
                                  setState(() {
                                    error = "Password required";
                                  });
                                  return;
                                }

                                registerUser();

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text('Register',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),

                                const SizedBox(height: 10.0),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/welcome", arguments: data);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyan,
                                    minimumSize: const Size(100, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: const Text('Go Back', style: TextStyle(fontSize: 15.0)),
                                )
                          ])),
                          const SizedBox(height: 30.0)
                ]))))));
  }
}
