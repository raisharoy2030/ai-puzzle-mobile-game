import 'dart:math';
import 'dart:collection';

class PuzzleLogic {

  static List<int> goal = [1,2,3,4,5,6,7,8,0];

  static List<int> shuffle() {
    List<int> puzzle = List.from(goal);
    Random rand = Random();

    do {
      puzzle.shuffle(rand);
    } while (!isSolvable(puzzle) || puzzle.toString()==goal.toString());

    return puzzle;
  }

  static bool isSolvable(List<int> puzzle) {

    int inv = 0;

    for(int i=0;i<9;i++){
      for(int j=i+1;j<9;j++){
        if(puzzle[i]!=0 && puzzle[j]!=0 && puzzle[i]>puzzle[j]){
          inv++;
        }
      }
    }

    return inv%2==0;
  }

  static List<int> getNeighbors(List<int> puzzle){

    int blank = puzzle.indexOf(0);
    List<int> moves = [];

    if(blank%3!=0) moves.add(blank-1);
    if(blank%3!=2) moves.add(blank+1);
    if(blank>2) moves.add(blank-3);
    if(blank<6) moves.add(blank+3);

    return moves;
  }

  static void moveTile(List<int> puzzle,int index){

    int blank = puzzle.indexOf(0);

    if(getNeighbors(puzzle).contains(index)){

      int temp = puzzle[index];
      puzzle[index] = puzzle[blank];
      puzzle[blank] = temp;

    }
  }

  static String encode(List<int> state){
    return state.join(",");
  }

  static List<List<int>> solve(List<int> start){

    Queue<List<int>> queue = Queue();
    Map<String,String?> parent = {};
    Map<String,List<int>> states = {};

    String startKey = encode(start);

    queue.add(start);
    parent[startKey] = null;
    states[startKey] = start;

    while(queue.isNotEmpty){

      List<int> current = queue.removeFirst();
      String currentKey = encode(current);

      if(current.toString()==goal.toString()){
        return buildPath(parent,states,currentKey);
      }

      for(int move in getNeighbors(current)){

        List<int> next = List.from(current);

        int blank = next.indexOf(0);

        int temp = next[move];
        next[move] = next[blank];
        next[blank] = temp;

        String key = encode(next);

        if(!parent.containsKey(key)){
          parent[key] = currentKey;
          states[key] = next;
          queue.add(next);
        }

      }

    }

    return [];
  }

  static List<List<int>> buildPath(
      Map<String,String?> parent,
      Map<String,List<int>> states,
      String goalKey){

    List<List<int>> path = [];
    String? current = goalKey;

    while(current!=null){
      path.add(states[current]!);
      current = parent[current];
    }

    return path.reversed.toList();
  }

  static int getHint(List<int> puzzle){

    List<List<int>> path = solve(puzzle);

    if(path.length<2){
      return -1;
    }

    List<int> nextState = path[1];

    for(int i=0;i<9;i++){
      if(puzzle[i]!=nextState[i] && puzzle[i]!=0){
        return i;
      }
    }

    return -1;
  }

}