import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/database_context.dart';
import 'package:flutterapp/student_model.dart';

class SQFLiteExamples extends StatefulWidget {
  const SQFLiteExamples({Key? key}) : super(key: key);

  @override
  _SQFLiteExamplesState createState() => _SQFLiteExamplesState();
}

class _SQFLiteExamplesState extends State<SQFLiteExamples> {
  final _dbContext = SQFLiteDbContext();
  bool _isActive = false;
  String? _name;
  String? _department;
  List<Student> _students = [];
  String _saveOrUpdate = "Save";
  int? _id;

  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();

  _getList() async {
    await _dbContext.getStudents().then((value) {
      setState(() {
        _students = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQFLite Example"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter First Name",
                  border: OutlineInputBorder()),
              onChanged: (value) {
                _name = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _departmentController,
              decoration: const InputDecoration(
                  labelText: "Department",
                  hintText: "Enter Department Name",
                  border: OutlineInputBorder()),
              onChanged: (value) {
                _department = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SwitchListTile(
              title: const Text("Is he/she an active student?",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 20)),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _saveOrUpdate = "Save";
                        _nameController.clear();
                        _departmentController.clear();
                        _isActive = false;
                      });
                    },
                    child: const Text("Add New Record"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black)),
                  ),*/
                  ElevatedButton(
                    onPressed: () async {
                      if (_saveOrUpdate == "Save") {
                        await _dbContext.insertStudent(Student(
                            _name, _department, _isActive == true ? 1 : 0));
                        _nameController.clear();
                        _departmentController.clear();
                        _isActive = false;
                        _getList();
                      } else {
                        await _dbContext.updateStudent(Student.withId(_id,
                            _name, _department, _isActive == true ? 1 : 0));
                        _saveOrUpdate = "Save";
                        _nameController.clear();
                        _departmentController.clear();
                        _isActive = false;
                        _getList();
                      }
                    },
                    child: Text(_saveOrUpdate),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onLongPress: () {
                        setState(() {
                          _id = _students[index].id;
                          _name = _students[index].name;
                          _department = _students[index].department;
                          _isActive =
                              _students[index].isActive == 1 ? true : false;
                          _nameController.text = _name!;
                          _departmentController.text = _department!;
                          _saveOrUpdate = "Update";
                        });
                      },
                      //enabled: _students[index].isActive == 1 ? true : false,
                      tileColor: (_students[index].isActive == 1)
                          ? Colors.orange
                          : Colors.grey,
                      title: Text(_students[index].name),
                      subtitle: Text(_students[index].department),
                      leading: const Icon(Icons.supervised_user_circle),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text("Please Confirm"),
                                  content: const Text(
                                      "Are you sure to delete the record?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          await _dbContext.deleteStudent(
                                              _students[index].id);
                                          _getList();
                                          _saveOrUpdate = "Save";
                                          _nameController.clear();
                                          _departmentController.clear();
                                          _isActive = false;
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Yes")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("No"))
                                  ],
                                );
                              });
                        },
                        child: const Text("Delete"),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
