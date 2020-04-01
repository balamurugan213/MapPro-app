import 'card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class DatabaseService{



  //collection referance
  final CollectionReference mcollection = Firestore.instance.collection("card");

  Future updateUserData(String name,String hashtag,String catagory, String desc,double lact,double long) async{
    return await mcollection.document().setData({
    'name':name,
    'hashtag':hashtag,
    'catagory':catagory,
    'descreption':desc,
    'lat':lact,
    'long':long
    });
  }

//movie list from dnapshot
List<Cards> _movieListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.documents.map((doc){
    return Cards(
     name: doc.data['name'],
     hashtag: doc.data['hashtag'],
     catagory: doc.data['catagory'],
     description: doc.data['descreption'],
     lat: doc.data['lat'] ?? '',
     long: doc.data['long'] ??''     
    );
  }).toList();
}


Stream<List<Cards>> get card {
  return mcollection.snapshots()
 .map(_movieListFromSnapshot);
}

}