import 'package:day_12/login.dart';
import 'package:day_12/share_preferences.dart';
import 'package:day_12/splash.dart';
import 'package:day_12/tasks.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        // backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Home Page",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              LocalStorage.getString(SplashState.USERKEY) ?? "Guest",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Theme.of(context).primaryColor),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    overlayColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 243, 19, 94))),
                onPressed: () {
                  showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            //Logout button
                            TextButton(
                              onPressed: () async {
                                await LocalStorage.initialize();
                                LocalStorage.setBool(
                                    SplashState.KEYNAME, false);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                    (route) => false);
                              },
                              child: const Text("Logout"),
                            ),
                            //Cancel button
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                          ],
                        );
                      });
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
            const SizedBox(height: 30),
            const Tasks(),
          ],
        ),
      ),
    );
  }
}
