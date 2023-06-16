import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/map_home.dart';

class CustominfoWindow extends StatefulWidget {
  const CustominfoWindow({Key? key}) : super(key: key);

  @override
  State<CustominfoWindow> createState() => _CustominfoWindowState();
}

class _CustominfoWindowState extends State<CustominfoWindow> {

  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(31.514626, 74.281697),zoom: 14);

  List<Marker> _marker = [];
  List<LatLng> _places = [
    LatLng(31.514626, 74.281697),
    LatLng(31.505209, 74.276841),
    LatLng(31.506140, 74.288251),
    LatLng(31.512039, 74.293713),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AddMarkers();
  }
  AddMarkers(){
    for(int i=0; i<_places.length; i++){
      _marker.add(Marker
        (markerId: MarkerId(i.toString()),
        position: _places[i],
        //icon: BitmapDescriptor.defaultMarker
        onTap: (){
          _customInfoWindowController.addInfoWindow!(
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey
              ),
              child: Container(
                child:const Image(image:
                NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUHY-ebakF2D-YwIIy-kzjfVSipzumsZwAKA&usqp=CAU'),
                  height: 50,
                  width: 200,
                  fit: BoxFit.fitWidth,),
              )
            ),
           _places[i],
          );
      }
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Custom_infowindow'),
            MaterialButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => MapHome()));},child: Text('Next'))
          ],
        )
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            markers: Set<Marker>.of(_marker),
            onTap: (position){
              _customInfoWindowController.hideInfoWindow;
            },
            onCameraMove: (position){
              _customInfoWindowController.onCameraMove;
            },
            onMapCreated: (GoogleMapController controler){
              _customInfoWindowController.googleMapController = controler;
            },
        ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 200,
            offset: 2,
          )
        ]
      ),
    );
  }
}
