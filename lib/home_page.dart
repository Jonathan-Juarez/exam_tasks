import 'package:exam_tasks/add_task.dart';
import 'package:exam_tasks/manage_http.dart';
import 'package:exam_tasks/profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;
  int _selectedTabBar = 0;
  Future<List<TaskTable>>? futureTasksRecurring, futureTakskCompleted;
  @override
  void initState() {
    super.initState();
    futureTasksRecurring = TaskHTTPManager().getTasksRecurring(
      context: context,
    );
    futureTakskCompleted = TaskHTTPManager().getTasksCompleted(
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (currentIndex) {
          if (currentIndex != (_selectedIndex)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    currentIndex == 1 ? AddTaskScreen() : ProfileScreen(),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "My Tasks",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Tabbar
              DefaultTabController(
                initialIndex: _selectedTabBar,
                length: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      indicatorColor: const Color(0xFF2A4BD1),
                      labelColor: Colors.black, // Texto activo
                      unselectedLabelColor: Colors.black26, // Texto inactivo
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      onTap: (index) {
                        setState(() {
                          _selectedTabBar = index;
                        });
                      },
                      tabs: const [
                        Tab(text: "Active"),
                        Tab(text: "Completed"),
                      ],
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: _selectedTabBar == 0
                    ? futureTasksRecurring
                    : futureTakskCompleted,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 16);
                      },
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        TaskTable task = snapshot.data![index];
                        return containerTask(
                          task.id,
                          task.title,
                          task.description,
                          task.dueDate,
                          task.priority,
                          task.status,
                          "Prueba 1",
                          task.recurringTask,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFF2A4BD1),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerTask(
    String id,
    String title,
    String description,
    String dueDate,
    String priority,
    String status,
    String tags,
    bool isRecurring,
  ) {
    // removed invalid local bool logic because isRecurring is already a bool

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Text(id),
              IconButton(
                onPressed: () => deleteTask(id),
                icon: Icon(Icons.delete, size: 20),
              ),
              IconButton(
                onPressed: () {
                  editTask(id, !isRecurring);
                },
                icon: Icon(Icons.edit, size: 20),
              ),
              Text(priority),
            ],
          ),
          Text(description),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(tags),
                ),
              ),
              Text(isRecurring == false ? "In Progress" : "Completed"),
            ],
          ),

          const Divider(color: Colors.black12),
          Row(
            children: [
              Expanded(child: Text(status)),
              Text("Due Date: $dueDate"),
            ],
          ),
        ],
      ),
    );
  }

  void deleteTask(String id) async {
    await TaskHTTPManager().deleteTask(context: context, id: id);
    // Si el contexto ya no está montado, no hace nada. Esto evita errores de memoria.
    if (!mounted) return;
    setState(() {
      _selectedTabBar == 0
          ? futureTasksRecurring = TaskHTTPManager().getTasksRecurring(
              context: context,
            )
          : futureTakskCompleted = TaskHTTPManager().getTasksCompleted(
              context: context,
            );
    });
  }

  void editTask(String id, bool isRecurring) async {
    int isRecurringInt = isRecurring == true ? 1 : 0;
    await TaskHTTPManager().updateTask(
      context: context,
      id: id,
      recurringTask: isRecurringInt,
    );
    if (!mounted) return;
    setState(() {
      _selectedTabBar == 0
          ? futureTasksRecurring = TaskHTTPManager().getTasksRecurring(
              context: context,
            )
          : futureTakskCompleted = TaskHTTPManager().getTasksCompleted(
              context: context,
            );
    });
  }
}
