import "package:flutter/material.dart";

import 'package:proposlisando_app/screens/EntrepostoScreen.dart';
import 'package:proposlisando_app/screens/OrigemScreen.dart';
import 'package:proposlisando_app/screens/ProducaoScreen.dart';



class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const OrigemScreen()),
                        );
                    },
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
                    onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const ProducaoScreen()),
                        );
                    },
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
                    onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const EntrepostoScreen()),
                        );
                    },
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