import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

class Halteterdekat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IsiHalte(),
    ); 
  }
}

class IsiHalte extends StatefulWidget {
  @override
  _KontenHalte createState() => _KontenHalte();
}

class _KontenHalte extends State<IsiHalte>{
  // fungsi buat posisi
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error("Location Service Blm di Enable");
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied){
        return Future.error("Location Service di TOlak");
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error("Layanan Lokasi di disable selamanya, ga bs operasi");
    }

    return await Geolocator.getCurrentPosition();
  }


  double latitudenya = 0.0;
  double longitudenya = 0.0;
  MapController? controller;
  bool _isSetLocation = false;

  // fungsi update posisi pas onload
  @override
  void initState(){
    super.initState();

    _determinePosition().then((posisi) {
      if(!_isSetLocation){ //buat boolean supaya cmn setLocation 1x aja, gk ush auto refresh
        setState(() {
          latitudenya = posisi.latitude;
          longitudenya = posisi.longitude;

          controller = MapController.withPosition(
            initPosition: GeoPoint(
              latitude: latitudenya, 
              longitude: longitudenya
            )
          );
        });

        _isSetLocation = true; //set true, biar if ini gk ke eksekusi lagi
      }
    }); 
  }
  
  @override
  Widget build(BuildContext context) {
    double _top = 1000;
    double _height = 100;

    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            if(controller != null)
              Container(
                child: OSMFlutter(
                  controller: controller!,
                  osmOption: OSMOption(
                    userTrackingOption: const UserTrackingOption(
                      enableTracking: true,
                      unFollowUser: false
                    ),
                    zoomOption: const ZoomOption(
                      initZoom: 8,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                      stepZoom: 1.0
                    ),
                    userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 120,
                        ),
                      ), 
                      directionArrowMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.location_on,
                          size: 1,
                        ),
                      ),

                    ),
                    roadConfiguration: RoadOption(
                      roadColor: Colors.yellowAccent,
                    ),
                    markerOption: MarkerOption(
                      defaultMarker: MarkerIcon(
                          icon: Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 56,
                          ),
                      )
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: _top,
              //   left: 20,
              //   right: 20,
              //   child: ModalBottomWidget()
              // )
            //end if
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future.delayed(const Duration(milliseconds: 800), () {
            _determinePosition().then((posisi) {
              setState(() {
                latitudenya = posisi.latitude;
                longitudenya = posisi.longitude;
                controller!.changeLocation(
                  GeoPoint(latitude: latitudenya, longitude: longitudenya)
                );
              });
            });
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class ModalBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context, 
          builder: (BuildContext context){
            return SizedBox(
              height: 400,
              child: Center(
                child: Text("Ini Modal Bottom"),
              ),
            );
          }
        );
      }, 
      child: Text("Show Modal")
    );
  }
}