import 'package:flutter/material.dart';

class ConfirmPage extends StatefulWidget {
  final String filePath;

  const ConfirmPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Page"),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {},
          )
        ],
      ),
      body: Center(child: Text(widget.filePath)),
    );
  }
}
