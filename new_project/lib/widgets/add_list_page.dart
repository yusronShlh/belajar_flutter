import 'package:flutter/material.dart';
import 'package:new_project/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddListPage extends StatefulWidget {
  const AddListPage({super.key});

  @override
  _AddListPageState createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addTodo() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todos = prefs.getStringList('todos') ?? [];
    todos.add(_controller.text);
    await prefs.setStringList('todos', todos);
    Navigator.pop(context); // Kembali ke halaman Home setelah menambahkan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan baru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  label: Text('Masukkan catatan'), hintText: "eg: Flutter"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Teks tidak boleh kosong'),
                        backgroundColor: tdRed,
                      ));
                    } else {
                      _addTodo();
                    }
                  },
                  child: const Text('Tambahkan catatan')),
            )
            // ElevatedButton(
            //   onPressed: _addTodo,
            //   child: Text('Add Todo'),
            // ),
          ],
        ),
      ),
    );
  }
}
