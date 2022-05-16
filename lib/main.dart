import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Insta Delivery'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const kStartPosition = LatLng(22.737644210672013, 75.89147898603848);//insta it tech
const kMarkerId = MarkerId('MarkerId1');
const kDuration = Duration(seconds: 2);
const kLocations = [
  kStartPosition,
  LatLng(22.737446309782058, 75.89142534186063),
  LatLng(22.737109877611704, 75.89131805350496),
  LatLng(22.736773444613476, 75.89117857864255),
  LatLng(22.735823511679232, 75.89093181542447),
  LatLng(22.735576132208813, 75.89082452705506),
  LatLng(22.733676243084417, 75.8901056950695),
  LatLng(22.733216109721155, 75.89000913556174),
  LatLng(22.732800504062258, 75.88991257603972),
  LatLng(22.73196434118109, 75.88960143976117),
  LatLng(22.73042064250425, 75.88907572680068),
  LatLng(22.729144109276298, 75.88863584452504),
  LatLng(22.7283722461696, 75.88834616595702),
  LatLng(22.727531108380195, 75.88804575855517),
  LatLng(22.727145172814506, 75.88790628367524),
  LatLng(22.725452981053028, 75.88727328236419),
];

class _MyHomePageState extends State<MyHomePage> {
  Marker? _senderLocation;
  Marker? _recieverLocation;
  final controller = Completer<GoogleMapController>();
  final markers = <MarkerId, Marker>{};
  final stream = Stream.periodic(kDuration, (count) => kLocations[count])
      .take(kLocations.length);

  void _onLongPress(LatLng pos) async {
    if (_senderLocation == null ||
        (_senderLocation != null && _recieverLocation != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _senderLocation = Marker(
          markerId: const MarkerId('senderLocation'),
          infoWindow: const InfoWindow(title: 'Sender Location'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        _recieverLocation = null;

        // Reset info
        //_info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _recieverLocation = Marker(
          markerId: const MarkerId('recieverLocation'),
          infoWindow: const InfoWindow(title: 'Reciever Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // // Get directions
      // final directions =
      //     await DirectionService().getDirections(_origin!.position, pos);
      // setState(() => _info = directions);
    }
  }

  void _onMapCreated(GoogleMapController googleMapController) {
    stream.forEach((value) => newLocationUpdate(value));
    controller.complete(googleMapController);
  }

  void newLocationUpdate(LatLng latLng) {
    var marker = RippleMarker(
        markerId: kMarkerId,
        position: latLng,
        ripple: false,
        onTap: () {
          print('Tapped! $latLng');
        });
    setState(() => markers[kMarkerId] = marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Animarker(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(22.737644210672013, 75.89147898603848),
                  zoom: 10,
                ),
                onLongPress: _onLongPress,
                markers: {
                  if (_senderLocation != null) _senderLocation!,
                  if (_recieverLocation != null) _recieverLocation!
                },
                onMapCreated: _onMapCreated,
              ),
              mapId: controller.future.then<int>((value) => value.mapId),
              useRotation: true,
              duration: Duration(milliseconds: 2300),
              markers: markers.values.toSet(),
            ),
            Positioned(
              child: FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(Icons.directions),
                  backgroundColor: new Color(0xFFE57373),
                  onPressed: () {}),
              bottom: 20,
            )
          ],
        ));
  }
}

// GoogleMap(
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(22.737644210672013, 75.89147898603848),
//                 zoom: 17,
//               ),
//               onLongPress: _onLongPress,
//               markers: {
//                 if (_senderLocation != null) _senderLocation!,
//                 if (_recieverLocation != null) _recieverLocation!
//               },
//             ),

// FloatingActionButton(
//       elevation: 0.0,
//       child: new Icon(Icons.check),
//       backgroundColor: new Color(0xFFE57373),
//       onPressed: (){}
//     )
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_animarker/flutter_map_marker_animation.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// //Setting dummies values
// const kStartPosition = LatLng(18.488213, -69.959186);
// const kSantoDomingo = CameraPosition(target: kStartPosition, zoom: 15);
// const kMarkerId = MarkerId('MarkerId1');
// const kDuration = Duration(seconds: 2);
// const kLocations = [
//   kStartPosition,
//   LatLng(18.488101, -69.957995),
//   LatLng(18.489210, -69.952459),
//   LatLng(18.487307, -69.952759),
//   LatLng(18.487308, -69.952759),
// ];

// class SimpleMarkerAnimationExample extends StatefulWidget {
//   @override
//   SimpleMarkerAnimationExampleState createState() =>
//       SimpleMarkerAnimationExampleState();
// }

// class SimpleMarkerAnimationExampleState
//     extends State<SimpleMarkerAnimationExample> {
//   final markers = <MarkerId, Marker>{};
//   final controller = Completer<GoogleMapController>();
//   final stream = Stream.periodic(kDuration, (count) => kLocations[count])
//       .take(kLocations.length);

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Google Maps Markers Animation Example',
//       home: Animarker(
//         curve: Curves.bounceOut,
//         rippleRadius: 0.2,
//         useRotation: false,
//         duration: Duration(milliseconds: 2300),
//         mapId: controller.future
//             .then<int>((value) => value.mapId), //Grab Google Map Id
//         markers: markers.values.toSet(),
//         child: GoogleMap(
//             mapType: MapType.normal,
//             initialCameraPosition: kSantoDomingo,
//             onMapCreated: (gController) {
//               stream.forEach((value) => newLocationUpdate(value));
//               controller.complete(gController);
//               //Complete the future GoogleMapController
//             }),
//       ),
//     );
//   }

//   void newLocationUpdate(LatLng latLng) {
//     var marker = RippleMarker(
//         markerId: kMarkerId,
//         position: latLng,
//         ripple: true,
//         onTap: () {
//           print('Tapped! $latLng');
//         });
//     setState(() => markers[kMarkerId] = marker);
//   }
// }

// void main() {
//   runApp(SimpleMarkerAnimationExample());
// }