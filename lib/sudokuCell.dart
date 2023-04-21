import 'package:flutter/material.dart';

class SudokuCell extends StatefulWidget {
  String puzzle;
  SudokuCell({Key key, this.puzzle}) : super(key: key);
  @override
  State<SudokuCell> createState() => _SudokuCellState();
}

class _SudokuCellState extends State<SudokuCell> {
  getColor(int index) {
    switch (index) {
      case 0:
        return Colors.black;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.pink;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 40,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int i = 0; i < widget.puzzle.split('').length; i++)
          Text(
            widget.puzzle.split('')[i],
            style: TextStyle(
                fontSize: i > 0 ? 20 : 20,
                color: getColor(i),
                fontWeight: i == 0 ? FontWeight.bold : null,
                decoration:
                    i > 0 ? TextDecoration.lineThrough : TextDecoration.none),
          )
      ]),
    );
  }

  textValues(String cell) {
    return List.generate(cell.split('').length, (index) {
      return Text(cell.split('')[index]);
    });
  }
}
