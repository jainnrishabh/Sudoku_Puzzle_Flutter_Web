import 'dart:collection';
import 'package:project2website/csp.dart';

class SolverFunction {
  bool revise(CSP csp, String xi, String xj) {
    try {
      bool revised = false;
      Set<String> values = csp.values[xi].split('').toSet();

      for (String x in values) {
        if (!isConsistent(csp, x, xi, xj)) {
          csp.values[xi].replaceAll(x, '');
          revised = true;
        }
      }

      return revised;
    } catch (e) {
      print(e);
    }
  }

  bool isConsistent(CSP csp, String x, String xi, String xj) {
    try {
      for (String y in csp.values[xj].split('')) {
        bool checkInConstraint = false;
        if (csp.constraints['$xi,$xj']?.firstWhere(
                (list) => list[0] == int.parse(x) && list[1] == int.parse(y),
                orElse: () => null) ==
            null) {
          if (csp.constraints['$xj,$xi']?.firstWhere(
                  (list) => list[0] == int.parse(x) && list[1] == int.parse(y),
                  orElse: () => null) ==
              null) {
            checkInConstraint = false;
          } else {
            checkInConstraint = true;
          }
        } else {
          checkInConstraint = true;
        }

        if (csp.neighbors[xi].contains(xj) && checkInConstraint) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  bool ac3(CSP csp) {
    try {
      //q = queue.Queue()
      Queue<List<String>> q = Queue();

      // for arc in csp.constraints:
      for (String arc in csp.constraints.keys) {
        // q.put(arc)
        q.add([arc]);
      }

      // while not q.empty():
      while (q.isNotEmpty) {
        // 	(Xi, Xj) = q.get()
        List<String> arc = q.removeFirst();
        String Xi = arc[0].split(",")[0];
        String Xj = arc[0].split(",")[1];

        // if Revise(csp, Xi, Xj):
        if (revise(csp, Xi, Xj)) {
          //if len(csp.values[Xi]) == 0:
          if (csp.values[Xi].isEmpty) {
            // return False
            return false;
          }

          csp.neighbors[Xi].remove(Xj);

          // for Xk in (csp.neighbors[Xi] - set(Xj)):
          for (String xk in csp.neighbors[Xi]) {
            // q.put((Xk, Xi))
            q.add(["$xk,$Xi"]);
          }
        }
      }
      // return True
      return true;
    } catch (e) {
      print(e);
    }
  }

  String minimumRemainingValue(Map<String, String> assignment, CSP csp) {
    //   unassigned_variables = dict((squares, len(csp.values[squares])) for squares in csp.values if squares not in assignment.keys())
    // mrv = min(unassigned_variables, key=unassigned_variables.get)
    // return mrv
    List<String> unassignedVariables = csp.values.keys
        .toList()
        .where((square) => !assignment.containsKey(square))
        .toList();
    Map<String, int> unassignedVariablesCount = Map.fromEntries(
        unassignedVariables
            .map((square) => MapEntry(square, csp.values[square].length)));
    String mrv = unassignedVariablesCount.keys.reduce((a, b) =>
        unassignedVariablesCount[b] < unassignedVariablesCount[a] ? b : a);

    return mrv;
  }

  backtrackingSearch(CSP csp) {
    var result = backtrack({}, csp);
    return result;
  }

  // The recursive function which assigns value using backtracking.
  Map<String, dynamic> backtrack(Map<String, String> assignment, CSP csp) {
    try {
      csp.finalAssignments.insert(csp.finalAssignments.length, {...assignment});

      if (assignment.keys.length == csp.squares.length) {
        return assignment;
      }

      String mrv = minimumRemainingValue(assignment, csp);
      Map<String, dynamic> domain = new Map.from(csp.values);

      for (var value in csp.values[mrv].split("")) {
        if (isConsistentBackTrack(mrv, value, assignment, csp)) {
          assignment[mrv] = value;
          Map<String, String> inferences = {};
          inferences = inference(assignment, inferences, csp, mrv, value);
          // if (inferences != null) {
          var result = backtrack(assignment, csp);
          if (result != null) {
            return result;
          }
          // }
          assignment.remove(mrv);
          csp.values = domain;
        }
      }
      return null;
    } catch (e) {
      print(e);
    }
  }

  bool isConsistentBackTrack(
      String mrv, String value, Map<String, String> assignment, CSP csp) {
    try {
      for (String neighbor in csp.neighbors[mrv]) {
        if (assignment.containsKey(neighbor) && assignment[neighbor] == value) {
          return false;
        }
      }
      return true;
    } catch (E) {
      print(E);
    }
  }

  // def Inference(assignment, inferences, csp, var, value):
  Map<String, String> inference(Map<String, String> assignment,
      Map<String, String> inferences, CSP csp, String mrv, String value) {
    //inferences[var] = value
    inferences[mrv] = value;

    //for neighbor in csp.neighbors[var]:
    for (var neighbor in csp.neighbors[mrv]) {
      // if neighbor not in assignment and value in csp.values[neighbor]:
      if (assignment.containsKey(neighbor) == false &&
          csp.values[neighbor].contains(value) == true) {
        // if len(csp.values[neighbor])==1:
        if (csp.values[neighbor].length == 1) {
          // return "FAILURE"
          return null;
        }

        // remaining = csp.values[neighbor] = csp.values[neighbor].replace(value, "")
        var remaining = csp.values[neighbor].replaceFirst(value, '');
        csp.values[neighbor] = remaining;

        // if len(remaining)==1:
        if (remaining.length == 1) {
          // flag = Inference(assignment, inferences, csp, neighbor, remaining)
          var flag =
              inference(assignment, inferences, csp, neighbor, remaining);
          // if flag=="FAILURE":
          if (flag == null) {
            // return "FAILURE"
            return null;
          }
        }
      }
    }
    // return inferences
    return inferences;
  }
}
