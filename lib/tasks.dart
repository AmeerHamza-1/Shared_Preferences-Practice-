import 'package:day_12/share_preferences.dart';
import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => TasksState();
}

class TasksState extends State<Tasks> {
  TextEditingController taskcontroller = TextEditingController();
  List<String> items = [];
  final String taskKey = "taskList";

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  void loadTask() {
    final List<Map<String, dynamic>>? storedTasks =
        LocalStorage.getListMap(taskKey);
    if (storedTasks != null) {
      setState(() {
        items = storedTasks.map((task) => task['task'] as String).toList();
      });
    }
  }

  Future<void> saveTask()async{
     List<Map<String, dynamic>> mappedTasks =
      items.map((task) => {'task': task}).toList();

  await LocalStorage.setListMap(taskKey, mappedTasks);
  }


  void addTask(StateSetter updateModalState) async{
    if (taskcontroller.text.isNotEmpty) {
      setState(() {
        items.add(taskcontroller.text); 
        taskcontroller.clear(); 
      });

      updateModalState(() {});
      await saveTask();  

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task Added")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a task")),
      );
    }
  }

  void deletTask(StateSetter updateModalState, int index){
    if (items.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Task"),
              content: const Text("Are you sure you want to delete the task?"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 41, 27),
                  ),
                  onPressed: () async{
                    setState(() {
                      items.removeAt(index); 

                    });
                      Navigator.of(context).pop();
                      await saveTask(); 
                      updateModalState(() {});

                  },
                  child: const Text("Delete",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          });
    }
  }

  void updateTask(StateSetter updateModelState, int index){
    TextEditingController updateController =
        TextEditingController(text: items[index]);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Task"),
            content: TextField(
              controller: updateController,
              decoration: InputDecoration(
                labelText: "Update Task",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 255, 234)),
                  onPressed: () async{
                    setState(() {
                      items[index] = updateController.text.trim();
                    });
                      await saveTask();
                      updateModelState(() {});
                      Navigator.pop(context);
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).primaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),

          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: taskcontroller,
                              onSubmitted: (value) =>
                                  addTask(setModalState), 
                              decoration: InputDecoration(
                                hintText: "Enter Task",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () =>
                                addTask(setModalState), 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child:
                                const Icon(Icons.forward, color: Colors.white),
                          )
                        ],
                      ),

                      const SizedBox(height: 16),

                      
                      SizedBox(
                        height: 250,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 7),
                          padding: const EdgeInsets.all(8),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                tileColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  items[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                leading: IconButton(
                                  onPressed: () {
                                    updateTask(setModalState, index);
                                  },
                                  icon: const Icon(Icons.edit,
                                      color: Color.fromARGB(255, 0, 255, 234)),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    deletTask(
                                        setModalState, index); // [✨ UPDATED]
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 240, 41, 27),
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: const Text("Bottom Sheet"),
    );
  }
}
