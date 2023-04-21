import 'package:project2website/constraints.dart';

class CSP {
  List variables;
  Map<String, dynamic> domain;
  Map<String, dynamic> values;
  List<dynamic> unitlist;
  Map<dynamic, dynamic> units;
  Map<dynamic, dynamic> neighbors;
  List finalAssignments;
  var constraints;

  String rows = "123456789";
  String cols = "123456789";
  List squares = [];

  cross(A, B) {
    List result = [];
    for (int i = 0; i < A.length; i++) {
      for (int j = 0; j < B.length; j++) {
        result.add("C" + A[i] + B[j]);
      }
    }
    return result;
  }

  getUnitList() {
    var arr1 = [];
    var arr2 = [];
    var arr3 = [];

    for (int i = 0; i < cols.length; i++) {
      var char = cols[i];
      arr1.add(cross(rows, char));
    }

    for (int i = 0; i < rows.length; i++) {
      var char = rows[i];
      arr2.add(cross(char, cols));
    }

    List<String> strs = ['123', '456', '789'];

    for (int i = 0; i < strs.length; i++) {
      for (int j = 0; j < strs.length; j++) {
        arr3.add(cross(strs[i], strs[j]));
      }
    }

    var unitList = (arr1 + arr2 + arr3);

    return unitList;
  }

  getUnits() {
    Map<dynamic, dynamic> units = {
      for (var s in squares)
        s: [
          for (var u in unitlist)
            if (u.contains(s)) u
        ]
    };
    return units;
  }

  getNeighbors() {
    Map<String, Set<String>> neighbors = {
      for (var s in squares)
        s: {
          for (var u in units[s])
            for (var t in u)
              if (t != s) t,
        },
    };

    return neighbors;
  }

  Map<String, dynamic> getDict(String grid) {
    var i = 0;
    var values = <String, dynamic>{};
    for (var cell in squares) {
      if (grid.isNotEmpty && grid[i] != '0') {
        values[cell] = grid[i];
      } else {
        values[cell] = rows;
      }
      i++;
    }
    return values;
  }

  CSP(String grid) {
    squares = cross(rows, cols);
    variables = squares;
    domain = getDict(grid);
    values = getDict(grid);
    unitlist = getUnitList();
    units = getUnits();
    finalAssignments = [];
    neighbors = getNeighbors();
    constraints = Constants.constraints;
  }
}
