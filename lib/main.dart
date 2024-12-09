import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TaskModel {
  String title;
  String detail;
  TaskModel(this.title, this.detail);
}

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Stream.periodic(Duration(seconds: 1)),
        builder: (context, snapshot) {
          return Text(DateFormat('hh:mm:ss').format(DateTime.now()),
            style: TextStyle(color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.bold),);
        }
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<TaskModel> taskList=[];
  final taskNameController=TextEditingController();
  final taskDescController=TextEditingController();
  int op=1;

  addTaskToList(TaskModel t) {
    taskList.add(t);
  }

  deleteTaskInList(int i) {
    taskList.removeAt(i);
  }

  updateTaskInList(int i, TaskModel t) {
    taskList[i]=t;
  }

  Future modifyList(BuildContext context, int i, int op) {
    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text('Task', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16,
              color: Colors.brown,
              fontWeight: FontWeight.bold),),
        content: SizedBox(
          height: h*0.25,
          width: w,
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: taskNameController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    hintText: taskList.length==0?"Task":taskList[i].title,
                    hintStyle: TextStyle(fontSize: 14),
                    icon: Icon(Icons.square_rounded, color: Colors.brown,),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: taskDescController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    hintText: taskList.length==0?"Detail":taskList[i].detail,
                    hintStyle: TextStyle(fontSize: 14),
                    icon: Icon(Icons.abc_outlined, color: Colors.brown,),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blueGrey,
            ),
            onPressed: ()=>Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () {
              final taskName=taskNameController.text;
              final taskDesc=taskDescController.text;
              if (op==1) { //add
                addTaskToList(TaskModel(taskName, taskDesc));
                taskNameController.text="";
                taskDescController.text="";
              }
              else if (op==2) { //update
                updateTaskInList(i, TaskModel(taskName, taskDesc));
                taskNameController.text="";
                taskDescController.text="";
              }
              setState(() {});
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(title: Text('Todo APP', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.purple[200],),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              ClockWidget(),
              Text('Current time', style: TextStyle(color: Colors.white, fontSize: 16,),),
              SizedBox(height: 20,),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(60),
                ),
                color: Colors.white,
              ),
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: UniqueKey(),
                    startActionPane: ActionPane(
                      motion: ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        modifyList(context, index, 2);
                        setState(() {});
                      }),
                      children: [
                        SlidableAction(
                          backgroundColor: Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                          onPressed: (context) {
                            modifyList(context, index, 2);
                            setState(() {});
                          },),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        deleteTaskInList(index);
                        setState(() {});
                      }),
                      children: [
                        SlidableAction(
                          backgroundColor: Color(0xFF0392CF),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (context) {
                            deleteTaskInList(index);
                            setState(() {});
                          },),
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8, left:16, right: 16),
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                        title: Text(taskList[index].title, style: TextStyle(color: Colors.black,
                            fontWeight: FontWeight.bold),),
                        subtitle: Text(taskList[index].detail, style: TextStyle(color: Colors.black54,
                            fontWeight: FontWeight.bold),),
                        trailing: Column(
                          children: [
                            Expanded(child: IconButton(
                              onPressed: () { modifyList(context, index, 2); setState(() {});},
                              icon: Icon(Icons.check_circle),)),
                            Expanded(child: IconButton(
                              onPressed: () { deleteTaskInList(index); setState(() {});},
                              icon: Icon(Icons.delete),)),
                          ],
                        ),
                        onTap: ()=>print(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>modifyList(context, 0, 1),),
    );
  }
}
