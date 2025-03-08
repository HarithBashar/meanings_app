import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:meaning/resources/classes/app_data.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: GetBuilder(
        init: AppData(),
        builder: (controller) {
          return ListView(
            children: [
              ListTile(
                title: Text("Vibration"),
                trailing: Switch(
                  value: controller.useVibration,
                  onChanged: (value) {
                    controller.toggleVibration();
                  },
                ),
                onTap: () => controller.toggleVibration(),
              ),
              ListTile(
                title: Text("Sound"),
                trailing: Switch(
                  value: controller.useSound,
                  onChanged: (value) {
                    controller.toggleSound();
                  },
                ),
                onTap: () => controller.toggleSound(),
              ),
              ListTile(
                title: Text("Colored Today Words"),
                trailing: Switch(
                  value: controller.useColoredTodayWords,
                  onChanged: (value) {
                    controller.toggleColoredTodayWords();
                  },
                ),
                onTap: () => controller.toggleColoredTodayWords(),
              ),
            ],
          );
        },
      ),
    );
  }
}
