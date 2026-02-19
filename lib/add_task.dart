import 'package:exam_tasks/home_page.dart';
import 'package:exam_tasks/manage_http.dart';
import 'package:exam_tasks/profile.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final int _selectedIndex = 1;
  int _selectedPriority = 0;
  int _selectedStatus = 0;
  bool _switchMode = false;
  List<String> _statusList = ["Pending", "In Progress", "Completed", "Cancel"];
  List<String> _priorityList = ["Low", "Medium", "High"];

  // Controladores para los campos de texto
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

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
                    currentIndex == 0 ? HomePage() : ProfileScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
      appBar: AppBar(title: const Text("Create New Task")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              inputText("Task Title", _titleController),
              const SizedBox(height: 16),
              inputText("Description (optional)", _descriptionController),
              const SizedBox(height: 16),
              inputText("Due Date", _dueDateController),
              const SizedBox(height: 16),
              dropDownPriority(),
              const SizedBox(height: 16),
              dropDownStatus(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: inputText("Add Tags", _tagsController)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: saveTag,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF4F5159)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(14),
                      child: Icon(Icons.add, color: const Color(0xFF4F5159)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.repeat),
                  Expanded(child: Text("Recurring Task")),
                  Switch(
                    activeThumbColor: const Color(0xFF2A4BD1),
                    value: _switchMode,
                    onChanged: (currentSwitch) => setState(() {
                      _switchMode = currentSwitch;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  customButton(
                    "Cancel",
                    Colors.transparent,
                    Colors.black,
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  customButton(
                    "Add Task",
                    const Color(0xFF2A4BD1),
                    Colors.white,
                    () {
                      createTask();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector customButton(
    String title,
    Color color,
    Color colorText,
    GestureTapCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: TextStyle(color: colorText, fontSize: 16)),
        ),
      ),
    );
  }

  Widget inputText(String title, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget dropDownPriority() {
    return DropdownButtonFormField(
      decoration: InputDecoration(border: OutlineInputBorder()),
      initialValue: _selectedPriority,
      items: [
        DropdownMenuItem(
          value: 0,
          child: Text("Low", style: TextStyle(fontWeight: FontWeight.w400)),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text("Medium", style: TextStyle(fontWeight: FontWeight.w400)),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text("High", style: TextStyle(fontWeight: FontWeight.w400)),
        ),
      ],
      onChanged: (currentSelected) {
        setState(() {
          _selectedPriority = currentSelected!;
        });
      },
    );
  }

  Widget dropDownStatus() {
    return DropdownButtonFormField(
      decoration: InputDecoration(border: OutlineInputBorder()),
      initialValue: _selectedStatus,
      items: [
        DropdownMenuItem(
          value: 0,
          child: Text("Pending", style: TextStyle(fontWeight: FontWeight.w400)),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text(
            "In Progress",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text(
            "Completed",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        DropdownMenuItem(
          value: 3,
          child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.w400)),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedStatus = value!;
        });
      },
    );
  }

  void createTask() async {
    await TaskHTTPManager().postTask(
      context: context,
      id: '',
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _dueDateController.text,
      priority: _priorityList[_selectedPriority],
      status: _statusList[_selectedStatus],
      recurringTask: _switchMode,
      createdAt: DateTime.now().toString(),
    );
    debugPrint(_selectedPriority.toString());
    debugPrint(_selectedStatus.toString());
    debugPrint(_switchMode.toString());
    debugPrint(_titleController.text);
    debugPrint(_descriptionController.text);
    debugPrint(_dueDateController.text);
    debugPrint(_tagsController.text);
  }

  void saveTag() {}
}
