import 'package:flutter/material.dart';

class SudokuCell extends StatefulWidget {
  String puzzle;
  SudokuCell({Key key, this.puzzle}) : super(key: key);
  @override
  State<SudokuCell> createState() => _SudokuCellState();
}

class _SudokuCellState extends State<SudokuCell> {
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      enableFeedback: true,
      onTap: () {},
      child: SizedBox(
          width: 30,
          height: 30,
          child:
              Center(child: Text(widget.puzzle != null ? widget.puzzle : ""))),
    );
  }
}
