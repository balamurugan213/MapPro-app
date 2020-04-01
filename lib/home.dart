  
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapPRO/homepage.dart';
import 'package:mapPRO/mapa.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: Center(child: Text("MAPPRO")),
              actions: <Widget>[
                IconButton(
                    icon: Icon(FontAwesomeIcons.search),
                    onPressed: () {
                      //
                    }),
              ],
            ),
            body:  Container(
              decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/back.png"),
              fit: BoxFit.cover,
              )
              ),
              child: Center(
                child: Container(
                  child: Column(
          children: <Widget>[
                  SizedBox(height:40.0,),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (context)=>Map1()));
                              },
                      child: Container(       
                        child: new FittedBox(
                          child: Material(
                              color: Colors.white,
                              elevation: 14.0,
                              borderRadius: BorderRadius.circular(24.0),
                              shadowColor: Color(0x802196F3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 280,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: new BorderRadius.circular(24.0),
                                      child: Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage("assets/h2.jpg"),
                                      ),
                                    ),),
                                    Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: myDetailsContainer1("Save Location"),
                                    ),
                                  ),
                                ],
                                
                                )
                          ),
                        ), 
                      ),
                    ),
                  ),
           SizedBox(height:40.0,),
           Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, new MaterialPageRoute(builder: (context)=>HomePage()));
                              },
                      child: Container(       
                        child: new FittedBox(
                          child: Material(
                              color: Colors.white,
                              elevation: 14.0,
                              borderRadius: BorderRadius.circular(24.0),
                              shadowColor: Color(0x802196F3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 280,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: new BorderRadius.circular(24.0),
                                      child: Image(
                                        fit: BoxFit.fill,
                                        image:AssetImage("assets/h1.png"), //NetworkImage("assets/h1.jpg"),
                                      ),
                                    ),),
                                    Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: myDetailsContainer1("View Location"),
                                    ),
                                  ),
                                ],)
                          ),
                        ), 
                      ),
                    ),
                  ),
                  SizedBox(height:40.0,)
          ],
        ),
      ),
    ),
            ),
    );
  }
  Widget myDetailsContainer1(String restaurantName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(restaurantName,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height:5.0),
      ],
    );
  }
}