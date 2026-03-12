import 'package:flutter/material.dart';
import 'dart:async';
import 'puzzle_logic.dart';

class PuzzleScreen extends StatefulWidget {
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {

  List<int> puzzle = [];
  List<int> solved = [1,2,3,4,5,6,7,8,0];

  int steps = 0;
  int seconds = 0;

  int bestMoves = 0;
  int bestTime = 0;

  bool gameStarted = false;

  Timer? timer;

  void startGame(){

    timer?.cancel();

    setState(() {
      puzzle = PuzzleLogic.shuffle();
      steps = 0;
      seconds = 0;
      gameStarted = true;
    });

    startTimer();
  }

  void startTimer(){

    timer?.cancel();

    timer = Timer.periodic(Duration(seconds:1),(timer){

      setState(() {
        seconds++;
      });

    });
  }

  void shufflePuzzle(){

    timer?.cancel();

    setState(() {
      puzzle = PuzzleLogic.shuffle();
      steps = 0;
      seconds = 0;
    });

    startTimer();
  }

  void showHint(){

    int hintIndex = PuzzleLogic.getHint(puzzle);

    if(hintIndex == -1){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No hint available"))
      );
      return;
    }

    int tile = puzzle[hintIndex];

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hint: Move tile $tile"))
    );
  }

  void autoSolve(){

    setState(() {
      puzzle = solved;
    });

    timer?.cancel();

    showDialog(
        context: context,
        builder:(context)=>AlertDialog(
          title: Text("AI Solver"),
          content: Text("Puzzle solved automatically!"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("OK"),
            )
          ],
        )
    );
  }

  void checkWin(){

    if(puzzle.toString()==solved.toString()){

      timer?.cancel();

      if(bestMoves == 0 || steps < bestMoves){
        bestMoves = steps;
      }

      if(bestTime == 0 || seconds < bestTime){
        bestTime = seconds;
      }

      showDialog(
          context: context,
          builder:(context)=>AlertDialog(
            title: Text("Congratulations 🎉"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text("Solved in $steps moves"),
                Text("Time: $seconds seconds"),

                SizedBox(height:15),

                Text("🏆 Best Game"),
                Text("Best Moves: $bestMoves"),
                Text("Best Time: $bestTime sec")

              ],
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  shufflePuzzle();
                },
                child: Text("Play Again"),
              )
            ],
          )
      );
    }
  }

  void moveTile(int index){

    setState(() {

      PuzzleLogic.moveTile(puzzle,index);

      steps++;

      checkWin();

    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(!gameStarted){
      return Scaffold(
        appBar: AppBar(title: Text("AI 8 Puzzle Game")),
        body: Center(
          child: ElevatedButton(
            onPressed: startGame,
            child: Text(
              "Start Game",
              style: TextStyle(fontSize:22),
            ),
          ),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(title: Text("AI 8 Puzzle Game")),

      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Text(
            "Steps: $steps   Time: $seconds s",
            style: TextStyle(fontSize:20,fontWeight:FontWeight.bold),
          ),

          SizedBox(height:20),

          Center(

            child: Container(

              width:300,
              height:300,

              child: GridView.builder(

                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:3,
                ),

                itemCount:puzzle.length,

                itemBuilder:(context,index){

                  return GestureDetector(

                    onTap:(){
                      moveTile(index);
                    },

                    child: Container(

                      margin:EdgeInsets.all(5),

                      decoration: BoxDecoration(
                          color:puzzle[index]==0?Colors.white:Colors.blue,
                          borderRadius:BorderRadius.circular(10)
                      ),

                      child:Center(

                        child:Text(

                          puzzle[index]==0?"":puzzle[index].toString(),

                          style:TextStyle(
                              fontSize:28,
                              color:Colors.white,
                              fontWeight:FontWeight.bold
                          ),

                        ),

                      ),

                    ),

                  );
                },

              ),

            ),

          ),

          SizedBox(height:20),

          Row(

            mainAxisAlignment:MainAxisAlignment.spaceEvenly,

            children:[

              ElevatedButton(
                onPressed:shufflePuzzle,
                child:Text("Shuffle"),
              ),

              ElevatedButton(
                onPressed:showHint,
                child:Text("Hint"),
              ),

              ElevatedButton(
                onPressed:autoSolve,
                child:Text("Solve"),
              ),

            ],

          )

        ],

      ),

    );
  }
}