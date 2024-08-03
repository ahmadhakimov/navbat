import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:livotj/utilities/constant.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {


  @override
  void initState() {
    super.initState();
    categoryMethod(context);
  }
  Future <void> categoryMethod(BuildContext context)async{
String? token = await storage.read(key: 'token');
isLoading=true;
    var response= await http.get(Uri.parse('https://test.api.navbat.tj/api/client/v1/categories'),
    headers: <String,String>{
         "Accept": 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
         'Authorization': 'Bearer $token',

      },
    );
    if(response.statusCode==200){

      setState(() {
        ImageGrid=jsonDecode(response.body)['data'];
        isLoading=false;
      });
    }
  }
  List ImageGrid = [
    
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Scaffold(
        appBar: AppBar(
          title: Text(
            "Navbat",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(30, 49, 72, 1),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: ImageGrid.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.5),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6 ),
                child: Container(decoration: BoxDecoration(image: DecorationImage(image: NetworkImage('https://test.api.navbat.tj/public${ImageGrid[index]['image']}'))),
                 // child: Text(ImageGrid[index]['name']),
                ),
              );
            },
            
          ),
        ),
      ),
      
       if (isLoading)
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Container(
              height: 78,
              width: 78,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(238, 111, 66, 1)),
                backgroundColor: Color.fromRGBO(238, 111, 66, 0.25),
              ),
            ),
          ),
        ),

      
      ]


    );
  }
}
