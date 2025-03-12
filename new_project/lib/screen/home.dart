import 'package:flutter/material.dart';
import 'package:new_project/constants/colors.dart';
import 'package:new_project/widgets/add_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<String>> _todos;

  @override
  void initState() {
    super.initState();
    _todos = _loadTodos();
  }

  //fungsi memuat daftar todo dari sharedpreferences
  Future<List<String>> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('todos') ?? [];
  }

  //fungsi untuk menghapus list dari sharedpreferences
  Future<void> _removeTodo(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todos = prefs.getStringList('todos') ?? [];
    todos.removeAt(index);
    await prefs.setStringList('todos', todos);
    setState(() {
      _todos = _loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 20),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Semua Catatan',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                    child: FutureBuilder<List<String>>(
                  future: _todos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("Tidak ada catatan di temukan"),
                      );
                    } else {
                      final todos = snapshot.data!;
                      return ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(todos[index]),
                            trailing: IconButton(
                                onPressed: () => _removeTodo(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: tdRed,
                                )),
                          );
                        },
                      );
                    }
                  },
                ))
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddListPage()),
                  );
                  setState(() {
                    _todos = _loadTodos();
                  });
                },
                backgroundColor: tdBlue,
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'cari catatan',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBgColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/avatar.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
