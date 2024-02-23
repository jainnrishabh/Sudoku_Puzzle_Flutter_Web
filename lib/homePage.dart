import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:project2website/solverCode.dart';
import 'package:project2website/csp.dart';
import 'package:project2website/sudokuCell.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.puzzle}) : super(key: key);
  final String puzzle;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> puzzles = [
    '700400086051080400040307090309006100000020000004900708080102060006050910210003005', //puzzle 1
    '100203800082060100700001640300095020070000010090310006053600001007020390004109005', //puzzle 2
    '100840050500900803700060100010502030075000260030609040007050006401006007060094002', //puzzle 3
    '000090075001200000070000180300600900100050004006002003032000040000006500790010000', //puzzle 4
    '000006080300002700705100600009400000080090020000008300004007805002800006050900000', //puzzle 5
  ];

  String selectedValue;
  CSP csp;

  var finalResult;

  @override
  void initState() {
    super.initState();
    if (widget.puzzle != null) {
      selectedValue = widget.puzzle;
      setState(() {});
      solvePuzzle();
    }
  }

  solvePuzzle() {
    try {
      csp = CSP(selectedValue);
      bool isPuzzleSolvable = SolverFunction().ac3(csp);
      if (isPuzzleSolvable) {
        finalResult = SolverFunction().backtrackingSearch(csp);
      }

      for (int i = 0; i < csp.finalAssignments.length; i++) {
        finalResult.forEach((k, v) {
          if (csp.finalAssignments[i].containsKey(k)) {
            if (csp.finalAssignments[i][k] != v) {
              if (!finalResult[k]
                  .split('')
                  .contains(csp.finalAssignments[i][k])) {
                String value = finalResult[k];
                value = value + csp.finalAssignments[i][k];
                finalResult[k] = value;
              }
            }
          }
        });
      }

      finalResult != null
          ? _showMyDialog('Congratulations!!')
          : _showMyDialog('Sorry the puzzle is not solved');
      finalResult == null ? selectedValue = null : null;
      setState(() {});
    } catch (e) {
      _showMyDialog('Sorry the puzzle is not solved');
    }
  }

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(finalResult != null ? 'Hurray!!' : 'Sorry'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  valuesBuilder(var mapData) {
    var finalValuesForCarousel = mapData.value;
    for (int i = 0; i < mapData.key; i++) {
      finalValuesForCarousel.forEach((k, v) {
        if (csp.finalAssignments[i].containsKey(k)) {
          if (csp.finalAssignments[i][k] != v) {
            if (!finalValuesForCarousel[k]
                .split('')
                .contains(csp.finalAssignments[i][k])) {
              String value = finalValuesForCarousel[k];
              value = value + csp.finalAssignments[i][k];
              finalValuesForCarousel[k] = value;
            }
          }
        }
      });
    }
    return finalValuesForCarousel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sudoku Puzzle - Programming assignment 2",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectedValue == null || selectedValue == ""
                    ? Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Row(
                              children: const [
                                Icon(
                                  Icons.list,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    'Select Puzzle',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                                            ((puzzles.indexOf(item) + 1)
                                                .toString()),
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
                              height: 45,
                              width: 160,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.black54,
                              ),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 300,
                              width: 200,
                              padding: null,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.black,
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
                      )
                    : Container(
                        margin: EdgeInsets.all(25),
                        child: ElevatedButton(
                          child: Text(
                            'Reset',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          // color: Colors.blueAccent,
                          // textColor: Colors.white,
                          onPressed: () {
                            selectedValue = null;
                            finalResult = null;
                            csp = null;
                            setState(() {});
                          },
                        ),
                      ),
                selectedValue == null || selectedValue == ""
                    ? Container(
                        margin: EdgeInsets.all(25),
                        child: ElevatedButton(
                          child: const Text(
                            'Enter Custom Puzzle',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black54,
                            minimumSize: Size(160, 50),
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/userInput');
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
            csp?.finalAssignments != null
                ? Container(
                    width: 550,
                    child: FlutterCarousel(
                      options: CarouselOptions(
                        height: 450.0,
                        showIndicator: true,
                        slideIndicator: CircularSlideIndicator(),
                      ),
                      items: csp.finalAssignments.asMap().entries.map((i) {
                        var currentTableValues = valuesBuilder(i);
                        return Builder(
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Table(
                                border: TableBorder(
                                  left: BorderSide(
                                      width: 3.0, color: Colors.black),
                                  top: BorderSide(
                                      width: 3.0, color: Colors.black),
                                ),
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children:
                                    getCustomTableRows(currentTableValues),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  )
                : Container(),
            selectedValue != null ? Text("Final Result:") : Container(),
            Container(
              width: 500,
              height: 500,
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
          ],
        ),
      ),
    );
  }

  List<TableRow> getCustomTableRows(values) {
    return List.generate(9, (int rowNumber) {
      return TableRow(
        key: Key(
          "C" + rowNumber.toString(),
        ),
        children: getCustomRow(rowNumber, values),
      );
    });
  }

  List<Widget> getCustomRow(int rowNumber, var values) {
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
          puzzle: values.keys.contains(
                  "C" + (rowNumber + 1).toString() + (colNumber + 1).toString())
              ? values[
                  "C" + (rowNumber + 1).toString() + (colNumber + 1).toString()]
              : "",
        ),
      );
    });
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
