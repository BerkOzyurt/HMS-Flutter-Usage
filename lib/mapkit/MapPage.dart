import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huawei/mapkit/LocationCard.dart';
import 'package:huawei_map/components/cameraPosition.dart';
import 'package:huawei_map/components/latLng.dart';
import 'package:huawei_map/constants/mapType.dart';
import 'package:huawei_map/map.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();

}

class _MapPageState extends State<MapPage> {

  HuaweiMapController _huaweiMapController;

  static const LatLng _centerPoint = const LatLng(41.043982, 29.014333);
  static const double _zoom = 12;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Polygon> _polygons = {};
  final Set<Circle> _circles = {};

  bool _cameraPosChanged = false;
  bool _trafficEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  void onMapCreated(HuaweiMapController controller) {
    _huaweiMapController = controller;
  }

  void clearMap() {
    setState(() {
      _markers.clear();
      _polylines.clear();
      _polygons.clear();
      _circles.clear();
    });
  }

  void log(msg) {
    print(msg);
  }

  void markersButtonOnClick() {
    if (_markers.length > 0) {
      setState(() {
        _markers.clear();
      });
    } else {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId('normal_marker'),
          position: LatLng(40.997802, 28.994978),
          infoWindow: InfoWindow(
              title: 'Normal Marker Title',
              snippet: 'Description Here!',
              onClick: () {
                log("Normal Marker InfoWindow Clicked");
              }),

          onClick: () {
            log('Normal Marker Clicked!');
          },
          icon: BitmapDescriptor.defaultMarker,
        ));
        _markers.add(Marker(
          markerId: MarkerId('draggable_marker'),
          position: LatLng(41.027335, 29.002359),
          draggable: true,
          flat: true,
          rotation: 0.0,
          infoWindow: InfoWindow(
            title: 'Draggable Marker Title',
            snippet: 'Hi! Description Here!',
          ),
          clickable: true,
          onClick: () {
            log('Draggable Marker Clicked!');
          },
          onDragEnd: (pos) {
            log("Draggable onDragEnd position : ${pos.lat}:${pos.lng}");
          },
          icon: BitmapDescriptor.defaultMarker,
        ));
        _markers.add(Marker(
          markerId: MarkerId('angular_marker'),
          rotation: 45,
          position: LatLng(41.043974, 29.028881),
          infoWindow: InfoWindow(
              title: 'Angular Marker Title',
              snippet: 'Hey! Why can not I stand up straight?',
              onClick: () {
                log("Angular marker infoWindow clicked");
              }),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
        _markers.add(Marker(
          markerId: MarkerId('colorful_marker'),
          position: LatLng(41.076009, 29.054630),
          infoWindow: InfoWindow(
              title: 'Colorful Marker Title',
              snippet: 'Yeap, as you know, description here!',
              onClick: () {
                log("Colorful marker infoWindow clicked");
              }),
          onClick: () {
            log('Colorful Marker Clicked');
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        ));
    }
  }

  void polygonsButtonOnClick() {
    if (_polygons.length > 0) {
      setState(() {
        _polygons.clear();
      });
    } else {
      List<LatLng> points1 = [
        LatLng(40.989306, 29.021242),
        LatLng(40.980753, 29.024590),
        LatLng(40.982632, 29.031885),
        LatLng(40.991273, 29.024676)
      ];
      List<LatLng> points2 = [
        LatLng(41.090321, 29.025598),
        LatLng(41.085146, 29.018045),
        LatLng(41.077124, 29.016844),
        LatLng(41.075441, 29.026285),
        LatLng(41.079582, 29.036928),
        LatLng(41.086828, 29.031435)
      ];

      setState(() {
        _polygons.add(Polygon(
            polygonId: PolygonId('polygon1'),
            points: points1,
            fillColor: Color.fromARGB(100, 129, 95, 53),
            strokeColor: Colors.brown[900],
            strokeWidth: 1,
            zIndex: 2,
            clickable: true,
            onClick: () {
              log("Polygon 1 Clicked");
            }));
        _polygons.add(Polygon(
            polygonId: PolygonId('polygon2'),
            points: points2,
            fillColor: Color.fromARGB(190, 242, 195, 99),
            strokeColor: Colors.yellow[900],
            strokeWidth: 1,
            zIndex: 1,
            clickable: true,
            onClick: () {
              log("Polygon 2 Clicked");
            }));
      });
    }
  }

  void polylinesButtonOnClick() {
    if (_polylines.length > 0) {
      setState(() {
        _polylines.clear();
      });
    } else {
      List<LatLng> line1 = [
        LatLng(41.068698, 29.030855),
        LatLng(41.045916, 29.059351),
      ];
      List<LatLng> line2 = [
        LatLng(40.999551, 29.062441),
        LatLng(41.025975, 29.069651),
      ];

      setState(() {
        _polylines.add(Polyline(
            polylineId: PolylineId('firstLine'),
            points: line1,
            color: Colors.pink,
            zIndex: 2,
            endCap: Cap.roundCap,
            startCap: Cap.squareCap,
            clickable: true,
            onClick: () {
              log("First Line Clicked");
            }));
        _polylines.add(Polyline(
            polylineId: PolylineId('secondLine'),
            points: line2,
            width: 2,
            patterns: [PatternItem.dash(20)],
            jointType: JointType.bevel,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            color: Color(0x900072FF),
            zIndex: 1,
            clickable: true,
            onClick: () {
              log("Second Line Clicked");
            }));
      });
    }
  }

  void circlesButtonOnClick() {
    if (_circles.length > 0) {
      setState(() {
        _circles.clear();
      });
    } else {
      LatLng point1 = LatLng(40.986595, 29.025362);
      LatLng point2 = LatLng(41.023644, 29.014032);

      setState(() {
        _circles.add(Circle(
            circleId: CircleId('firstCircle'),
            center: point1,
            radius: 1000,
            fillColor: Color.fromARGB(100, 249, 195, 53),
            strokeColor: Color(0xFFF9C335),
            strokeWidth: 3,
            zIndex: 2,
            clickable: true,
            onClick: () {
              log("First Circle clicked");
            }));
        _circles.add(Circle(
            circleId: CircleId('secondCircle'),
            center: point2,
            zIndex: 1,
            clickable: true,
            onClick: () {
              log("Second Circle Clicked");
            },
            radius: 2000,
            fillColor: Color.fromARGB(50, 230, 20, 50),
            strokeColor: Color.fromARGB(50, 230, 20, 50),
        ));
      });
    }
  }

  void moveCameraButtonOnClick() {
    if (!_cameraPosChanged) {
      _huaweiMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            bearing: 270.0,
            target: LatLng(41.889228, 12.491780),
            tilt: 45.0,
            zoom: 17.0,
          ),
        ),
      );
      _cameraPosChanged = !_cameraPosChanged;
    } else {
      _huaweiMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            bearing: 0.0,
            target: _centerPoint,
            tilt: 0.0,
            zoom: 12.0,
          ),
        ),
      );
      _cameraPosChanged = !_cameraPosChanged;
    }
  }

  void trafficButtonOnClick() {
    if (_trafficEnabled) {
      setState(() {
        _trafficEnabled = false;
      });
    } else {
      setState(() {
        _trafficEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final huaweiMap = HuaweiMap(
      onMapCreated: onMapCreated,

      mapType: MapType.normal,
      tiltGesturesEnabled: true,
      buildingsEnabled: true,
      compassEnabled: true,
      zoomControlsEnabled: true,
      rotateGesturesEnabled: true,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      trafficEnabled: _trafficEnabled,
      markers: _markers,
      polylines: _polylines,
      polygons: _polygons,
      circles: _circles,
      onClick: (LatLng latLng) {
        log("Map Clicked at $latLng");
      },
      onLongPress: (LatLng latlng) {
        log("Map LongClicked at $latlng");
      },
      initialCameraPosition: CameraPosition(
        target: _centerPoint,
        zoom: _zoom,
      ),
    );

    final markerButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: markersButtonOnClick,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Color(0xFFF9C335),
        child: const Icon(Icons.add_location, size: 36.0, color: Colors.black),
      ),
    );

    final circlesButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: circlesButtonOnClick,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Color(0xFFF9C335),
        child: const Icon(Icons.adjust, size: 36.0, color: Colors.black),
      ),
    );

    final polylinesButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: polylinesButtonOnClick,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Color(0xFFF9C335),
        child: const Icon(Icons.waterfall_chart, size: 36.0, color: Colors.black),
      ),
    );

    final polygonsButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: polygonsButtonOnClick,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Color(0xFFF9C335),
        tooltip: "Polygons",
        child: const Icon(Icons.crop_square, size: 36.0, color: Colors.black),
      ),
    );

    final clearButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: () => clearMap(),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Color(0xFFF9C335),
        tooltip: "Clear",
        child: const Icon(Icons.refresh, size: 36.0, color: Colors.black),
      ),
    );

    final moveCamreButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: () => moveCameraButtonOnClick(),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Color(0xFFF9C335),
        tooltip: "CameraMove",
        child:
        const Icon(Icons.airplanemode_active, size: 36.0, color: Colors.black),
      ),
    );

    final trafficButton = Padding(
        padding: EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () => trafficButtonOnClick(),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: Color(0xFFF9C335),
          tooltip: "Traffic",
          child: const Icon(Icons.traffic, size: 36.0, color: Colors.black),
            ),
        );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map Kit', style: TextStyle(
              color: Colors.black
          )),
          backgroundColor: Color(0xFFF9C335),
        ),
        body: Stack(
          children: <Widget>[
            huaweiMap,
             Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: <Widget>[
                        clearButton,
                        trafficButton,
                        moveCamreButton,
                        markerButton,
                        circlesButton,
                        polylinesButton,
                        polygonsButton
                        ],
                    ),
                ),
             ),
          ],
        ),
      ),
    );
  }
}