import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constant.dart';
import 'database.dart';
import 'home.dart';

class Map1 extends StatefulWidget {
  @override
  _Map1State createState() => _Map1State();
}

class _Map1State extends State<Map1>
    with SingleTickerProviderStateMixin {
  AnimationController _controllerr;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(12.916807, 80.233653);
  final Set<Marker> _markers = {};
  LatLng lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;



  String currentLocName;
  String currentLocCat;
  String currentLocDesc;
  String currentLocHash;
  LatLng get loc => loc;
    final _formkey= GlobalKey<FormState>();
  final List<String> cats=["restrant","house","shop","work","others"];


  @override
  void initState() {
    super.initState();
    _controllerr = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerr.dispose();
  }

  void _onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  //void _onMapCreated(GoogleMapController controller) {
  //  _controller.complete(controller);
 // }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  

  void onAddMarkerButtonPressed(String name,String hashtag) {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(lastMapPosition.toString()),
        position: lastMapPosition,
        infoWindow: InfoWindow(
          title: name,
          snippet: hashtag,
          onTap: () {
          Scaffold.of(context).showSnackBar( SnackBar(content: Text("Hello"),));
        }
        ),
        icon: BitmapDescriptor.defaultMarker,
        
      ));
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context)=>Home()));
            }),
        title: Text("location saver"),
      ),
      body: Stack(
        children: <Widget>[

          _buildGoogleMap(context),
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.center,
                    child: 
                    Stack(
                      children: <Widget>[
                        Icon(Icons.adjust, size: 50.0),
                        //Icon(Icons.donut_large, size: 50.0)
                      ],
                    ),
                    
                    ),
            ),
            _centerReight(context),
        ],
      ),
    );
  }
  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType:_currentMapType,
        initialCameraPosition:  CameraPosition(target: LatLng(12.917425, 80.233403), zoom: 16.0),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        onCameraMove: _onCameraMove,
      ),
    );
  }

  Widget _centerReight(BuildContext context) {

    void _showAddLocation(){
      showModalBottomSheet(context: context, builder: (context){
       return Container(
          color: Colors.yellow[200],
         padding: EdgeInsets.symmetric(vertical:10.0, horizontal:40.0),
         child: locationForm(context),
       ); 
      });
    }
    return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget> [
                        FloatingActionButton(
                          onPressed: _onMapTypeButtonPressed,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.map, size: 36.0,color: Colors.yellow),
                        ),
                        SizedBox(height: 16.0),
                        FloatingActionButton(
                          onPressed:_showAddLocation,//_onAddMarkerButtonPressed,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.add_location, size: 36.0,color: Colors.yellow),
                        ),
                        
                      ],
                    ),
                ),
              );
  }
  Widget locationForm(BuildContext context) {
    return Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Add New Location',
                  style: TextStyle(fontSize: 18.0),
                  ),
                  
                  SizedBox(height:20.0,),
                  TextFormField(
                    //initialValue: 'Name',
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (val) =>val.isEmpty ?'Project' :null,
                    onChanged: (val) =>setState(() => currentLocName = val),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                      //  initialValue: userData.name,
                        decoration: textInputDecoration.copyWith(hintText: '#ashtag'),
                        validator: (val) =>val.isEmpty ? 'Domain':null,
                        onChanged: (val) =>setState(() => currentLocHash = val),
                      ),
                  SizedBox(height: 20.0,),
                   
                  //dropDown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: currentLocCat ?? "others",
                    items: cats.map((cat){
                      return DropdownMenuItem(
                        value: cat,
                        child: Text("$cat"),
                        );
                  }).toList(), 
                  onChanged: (val) =>setState(() => currentLocCat = val),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                         child: TextFormField(
                          //initialValue: "description",
                          maxLines: 3,
                          decoration: textInputDecoration.copyWith(hintText: 'Description'),
                          onChanged: (val) =>setState(() => currentLocDesc = val),
                              ),
                        ) ,
                  SizedBox(height: 10.0,),
                  RaisedButton(
                    color: Colors.green,
                    child: Text(
                      'Add',
                       style: TextStyle(color: Colors.white)
                    ),
                    onPressed: () async{
                      if(_formkey.currentState.validate()) {
                        print(lastMapPosition);
                         onAddMarkerButtonPressed(currentLocName,currentLocHash);
                         DatabaseService().updateUserData(currentLocName,currentLocHash,currentLocCat,currentLocDesc,lastMapPosition.latitude,lastMapPosition.longitude);
                         
                         Navigator.pop(context);
                      }
                    },
                  ),
                  //slider
                ],
              ),
            ],
          ), 
        );
  }
}

