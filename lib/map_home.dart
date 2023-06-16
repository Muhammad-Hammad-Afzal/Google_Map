import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui ;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/search_locaation.dart';

class MapHome extends StatefulWidget {
  const MapHome({Key? key}) : super(key: key);

  @override
  State<MapHome> createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {

  Uint8List? markerimage;

  //This function get current position of user.
  Future<Position> getusercurrentposition()async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace){
      var snackbar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    });
    return await Geolocator.getCurrentPosition();
  }

  final Completer<GoogleMapController> _controller = Completer();

  //initial camera position for map
  final CameraPosition _cameraPosition = CameraPosition(target: LatLng(31.514626, 74.281697),
    zoom: 14
  );

  //list of images that will use as custom maker icon
  List images = ['assets/car.png', 'assets/bycicle.png'];

  //list of places that are highlight in map
  List<LatLng> places = <LatLng>[
    LatLng(31.514626, 74.281697),
    LatLng(31.505209, 74.276841),
    LatLng(31.506140, 74.288251),
    LatLng(31.512039, 74.293713),
  ];

  List<Marker> _marker = [];
  

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AddMarkers();
  }

  //this function put makers on map on different places
  AddMarkers()async{
    for(var i = 0; i<places.length; i++){
      final Uint8List caricon = await Add_custom_icon(images[0], 50);
      final Uint8List bickeicon = await Add_custom_icon(images[1], 50);
      _marker.add(
        Marker(
          markerId: MarkerId('this is $i location'),
          position: places[i],
          infoWindow: InfoWindow(
            title: 'This is $i location'
          ),
          icon: i % 2 == 0 ? BitmapDescriptor.fromBytes(caricon) :await BitmapDescriptor.fromBytes(bickeicon)
        ),
      );
      setState(() {

      });
    }
  }

  //function for custom icon
  Future<Uint8List> Add_custom_icon(String path, int width)async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
              })
        ],
      ),
      
      
      body: GoogleMap(
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          initialCameraPosition: _cameraPosition,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
        markers: Set<Marker>.of(_marker),

      ),
      floatingActionButton: FloatingActionButton(
          child:Icon(Icons.my_location),
          onPressed: (){
            getusercurrentposition().then((value)async{
              _marker.add(
                Marker(
                  markerId: MarkerId('Current position'),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(
                    title: 'current location'
                  )

                )
              );
              CameraPosition _cameraposition = CameraPosition(
                target: LatLng(value.latitude, value.longitude),
                zoom: 14

              );
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(_cameraposition));

              setState(() {

              });

            }).onError((error, stackTrace){
              var snackbar = SnackBar(content: Text('Error'));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            });

            // GoogleMapController controller = await _controller.future;
            // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(35.6762, 139.6503),
            // zoom: 14)));
          }),
    );
  }
}
