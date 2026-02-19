import 'package:exam_tasks/add_task.dart';
import 'package:exam_tasks/home_page.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (currentIndex) {
          if (currentIndex != (_selectedIndex)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    currentIndex == 0 ? HomePage() : AddTaskScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Agregar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
      appBar: AppBar(title: const Text("Perfil")),
      body: const Center(child: Text("Perfil")),
    );
  }
}
