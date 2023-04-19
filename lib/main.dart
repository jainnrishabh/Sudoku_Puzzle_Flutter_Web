import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:project2website/ac3.dart';
import 'package:project2website/csp.dart';
import 'package:project2website/sudokuCell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> puzzles = [
    '700400086051080400040307090309006100000020000004900708080102060006050910210003005',
    '100203800082060100700001640300095020070000010090310006053600001007020390004109005',
    '100840050500900803700060100010502030075000260030609040007050006401006007060094002',
    '000090075001200000070000180300600900100050004006002003032000040000006500790010000',
    '000006080300002700705100600009400000080090020000008300004007805002800006050900000'
  ];

  String selectedValue;
  CSP csp;

  var finalResult;

  @override
  void initState() {
    super.initState();
  }

  solvePuzzle() {
    try {
      csp = CSP(selectedValue);
      finalResult = AC3Fucntions().backtrackingSearch(csp);
      print(finalResult);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sudoku Puzzle - Programming assignment 2",
        ),
      ),
      body: Column(
        children: [
          selectedValue == null || selectedValue == ""
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: puzzles
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    "Puzzle " +
                                        (puzzles.indexOf(item).toString()),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                          solvePuzzle();
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.redAccent,
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.yellow,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          padding: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.redAccent,
                          ),
                          elevation: 8,
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Table(
              border: TableBorder(
                left: BorderSide(width: 3.0, color: Colors.black),
                top: BorderSide(width: 3.0, color: Colors.black),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: getTableRows(""),
            ),
          ),
          selectedValue != ""
              ? Container(
                  margin: EdgeInsets.all(25),
                  child: FlatButton(
                    child: Text(
                      'Start Again',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      selectedValue = null;
                      setState(() {});
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  List<TableRow> getTableRows(String puzzle) {
    return List.generate(9, (int rowNumber) {
      return TableRow(
        key: Key(
          "C" + rowNumber.toString(),
        ),
        children: getRow(rowNumber),
      );
    });
  }

  List<Widget> getRow(int rowNumber) {
    return List.generate(9, (int colNumber) {
      return Container(
        key: Key(
          "C" + (rowNumber + 1).toString() + (colNumber + 1).toString(),
        ),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: (colNumber % 3 == 2) ? 3.0 : 1.0,
              color: Colors.black,
            ),
            bottom: BorderSide(
              width: (rowNumber % 3 == 2) ? 3.0 : 1.0,
              color: Colors.black,
            ),
          ),
        ),
        child: SudokuCell(
          puzzle: finalResult != null
              ? finalResult[
                  "C" + (rowNumber + 1).toString() + (colNumber + 1).toString()]
              : "",
        ),
      );
    });
  }
}
