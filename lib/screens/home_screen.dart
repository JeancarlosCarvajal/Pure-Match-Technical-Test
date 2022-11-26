import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'dart:math' as math;

import '../providers/movies_provider.dart';
import '../search/search_delegate.dart';


 

class HomeScreen extends StatelessWidget { 
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) { 
    Provider.of<MoviesProvider>(context); 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F), 
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Expanded(child: Text('Add an Admin', textAlign: TextAlign.center, style: TextStyle(fontSize: 25),)),
                const Icon(Icons.handshake, size: 35)
              ],
            ),
          ],
        ),
        elevation: 0,
      ),

      
      backgroundColor: const Color(0xFF0F0F0F),
      body: SingleChildScrollView( 
        child: SizedBox(
          width: double.infinity,
          height: 40, 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () => showSearch(context: context, delegate: MovieSearchDelegate()),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2C),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(Icons.search, color: Color(0xFFC7C7C7),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: const Icon(Icons.add_circle, color: Color(0xFFC7C7C7))
                          ),
                        )
                      ],
                    )  
                  ),
                ),
              ),
              const Text( 'Cancel', style: TextStyle(color: Color(0xFF185093), fontSize: 17, fontWeight: FontWeight.bold), )
            ],
          ),
        ), 
      )
    );
  }
}