import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buddy/routes/app_pages.dart';

class AuthDemoPage extends StatelessWidget {
  const AuthDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Demo - Choose Implementation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose Authentication Implementation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            
            // GetX Implementation
            Card(
              child: ListTile(
                leading: Icon(Icons.speed, color: Colors.blue),
                title: Text('GetX Implementation'),
                subtitle: Text('Current implementation using GetX controllers'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Get.offNamed(Routes.LOGIN);
                },
              ),
            ),
            
            SizedBox(height: 20),
            
            // BLoC Implementation
            Card(
              child: ListTile(
                leading: Icon(Icons.architecture, color: Colors.green),
                title: Text('BLoC Implementation'),
                subtitle: Text('New implementation using BLoC pattern'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Get.offNamed(Routes.LOGIN_BLOC);
                },
              ),
            ),
            
            SizedBox(height: 40),
            
            Text(
              'Both implementations provide the same functionality but use different state management approaches.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
