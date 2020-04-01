import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapPRO/database.dart';
import 'package:mapPRO/home.dart';
import 'package:provider/provider.dart';
import 'card.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }
  String img;
  double zoomVal=5.0;
  final Set<Marker> _markers = {};


   onAddMarkerButtonPressed(String name,String hashtag,double lat,double long) {
    setState(() 
    {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(name),
        position: LatLng(lat,long),
        infoWindow: InfoWindow(
          title: name,
          snippet: hashtag,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet),
       // onTap: () {
        //  Scaffold.of(context).showSnackBar( SnackBar(content: Text("Hello"),));
      //  }
      ));
    });
  }

  
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<List<Cards>>(
      stream: DatabaseService().card,
      builder: (context, snapshot) {
        List<Cards> car=snapshot.data;
        return StreamProvider<List<Cards>>.value(
           value:DatabaseService().card,
              child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (context)=>Home()));
                  }),
              title: Text("Saved Location"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(FontAwesomeIcons.search),
                    onPressed: () {
                      //
                    }),
              ],
            ),
            body: Stack(
              children: <Widget>[
                _buildGoogleMap(context),
                info1(car),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:  CameraPosition(target: LatLng(12.917425, 80.233403), zoom: 15.0),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);   
        },
          markers: _markers,
       // onCameraMove: _onCameraMove,
       // markers: {
         // newyork1Marker,newyork2Marker,newyork3Marker,gramercyMarker,bernardinMarker,blueMarker
        //},
      ),
    );
  }

  Future<void> _gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 19,tilt: 50.0,
      bearing: 45.0,)));
  }

  Widget info1(List<Cards> cardsa) {
    return  Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView.builder( 
          scrollDirection: Axis.horizontal,
          itemCount: cardsa.length,
          itemBuilder:(context,index) {
          return infoCard(cardsa[index]);     
         },
        ),
      ),
    );
  }
  Widget infoCard(Cards cardss) {
    String imgc=cardss.catagory;
    
    if(imgc=="house")
    {
      img='assets/house.jpg';
    }
    else if(imgc=='shop')
    {
      img='assets/shop.jpg';
    }
    else if(imgc=='restrant')
    {
      img='assets/rest.png';
    }
    else if(imgc=='work')
    {
      img='assets/work.jpg';
    }
    else
    {
      img='assets/others.jpg';
    }
    //onAddMarkerButtonPressed(cardss.name,cardss.hashtag,cardss.lat,cardss.long);
    return Column(
      children: <Widget>[
        
        Padding(
                padding: const EdgeInsets.all(8.0),
                
                child: _boxes(img,cardss.name,cardss.hashtag,cardss.catagory,cardss.description,cardss.lat,cardss.long),
                ),
                SizedBox(width: 10.0),
                
      ],
    );
                   
  } 

  Widget _boxes(String _image,String name,String hashtag,String catagory,String desctiption, double lat,double long) {
    return  GestureDetector(
        onTap: () {
          onAddMarkerButtonPressed(name,hashtag,lat,long);
          _gotoLocation(lat,long);
          
        },
        child:Container(
              child: new FittedBox(
                child: Material(
                    color: Colors.white,
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(24.0),
                    shadowColor: Color(0x802196F3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(24.0),
                            child: Image(
                              fit: BoxFit.fill,
                              image: AssetImage(img),
                            ),
                          ),),
                          Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: myDetailsContainer1(name,hashtag,catagory,desctiption,lat,long),
                          ),
                        ),

                      ],)
                ),
              ),
            ),
    );
  }

  Widget myDetailsContainer1(String name,String hashtag,String catagory,String desctiption, double lat,double long) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(name,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height:5.0),
        Container(
                  child: Text(hashtag,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
          SizedBox(height:5.0),
        Container(
                  child: Text(
                catagory,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18.0,
                ),
              )),
              SizedBox(height:5.0),
        Container(
            child: Text(
          desctiption,
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }
}

