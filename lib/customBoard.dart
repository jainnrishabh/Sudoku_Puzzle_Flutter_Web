import 'package:flutter/material.dart';
import 'package:project2website/main.dart';

class SudokuBoard extends StatefulWidget {
  @override
  _SudokuBoardState createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {
  List<List<TextEditingController>> controllers =
      List.generate(9, (i) => List.generate(9, (j) => TextEditingController()));

  Map<String, String> valuesSet = {};

  @override
  void initState() {
    super.initState();
    setValues();
  }

  setValues() {
    for (int i = 1; i <= 9; i++) {
      for (int j = 1; j <= 9; j++) {
        valuesSet.addAll({"C$i$j": "123456789"});
      }
    }
  }

  @override
  void dispose() {
    for (var row in controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom user input')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 500,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9),
                itemBuilder: (context, index) {
                  final row = index ~/ 9;
                  final col = index % 9;
                  return TextField(
                    controller: controllers[row][col],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      valuesSet["C${row + 1}${col + 1}"] = _;
                      setState(() {});
                    },
                  );
                },
                itemCount: 81,
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: ElevatedButton(
                child: const Text(
                  'Lets solve',
                  style: TextStyle(fontSize: 20.0),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  minimumSize: Size(160, 50),
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
                onPressed: () {
                  String userInput = "";
                  for (int i = 1; i <= 9; i++) {
                    for (int j = 1; j <= 9; j++) {
                      userInput += valuesSet["C$i$j"] == "123456789"
                          ? "0"
                          : valuesSet["C$i$j"];
                    }
                  }
                  Navigator.pushNamed(context, '/homePage',
                      arguments: userInput);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
