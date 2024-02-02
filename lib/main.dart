import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Proposlisando APP"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SizedBox(
                //height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    backgroundColor: Colors.amber
                  ),
                  onPressed: (){},
                  child: const Text("ORIGEM",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                //height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    backgroundColor: Colors.grey
                  ),
                  onPressed: (){},
                  child: const Text("PRODUÇÃO",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                //height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      ),
                      backgroundColor: Colors.green
                  ),
                  onPressed: (){},
                  child: const Text("ENTREPOSTO DE VENDAS",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
  