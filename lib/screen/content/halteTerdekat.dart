import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

class Halteterdekat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   child: IsiMap(),
    // ); 

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DraggableBottomSheet(
          anak: Column(
            children: [
              Text("Hai")
            ],
          )
        ),
      ),
    );
  }
}

class IsiMap extends StatefulWidget {
  @override
  _KontenMap createState() => _KontenMap();
}

class _KontenMap extends State<IsiMap>{
  // fungsi async await buat return currentposisi
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

    //fungsi async await yg d buat diatas.
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
  
  // referensi ada didokumentasi flutter_osm_plugin
  // install di pubspec.yaml : 
  // flutter_osm_plugin: ^1.3.2
  // geolocator: ^9.0.2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

// referensi : 
// https://www.youtube.com/watch?v=mI3QwwwZrn4
// baru sampai ke menit 9:10. akan d lanjutkan
class DraggableBottomSheet extends StatefulWidget {
  final Widget anak;
  const DraggableBottomSheet({super.key, required this.anak});

  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onChanged);
  }

  void onChanged(){
    final currentSize = controller.size;
    if(currentSize <= 0.05) collapse();
  }

  void collapse() => animateSheet(getSheet.snapSizes!.first);
  void anchor() => animateSheet(getSheet.snapSizes!.last);
  void expand() => animateSheet(getSheet.maxChildSize);
  void hide() => animateSheet(getSheet.minChildSize);

  void animateSheet(double size){
    controller.animateTo(
      size, 
      duration: const Duration(microseconds: 50), 
      curve: Curves.easeInOut
    );
  }

  DraggableScrollableSheet get getSheet => (sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    // you can use a Stack widget. This allows you to layer widgets on top of each other
    return Stack(
      children: [
        // buat jadikan ini background dari scrollablesheet
        Positioned.fill(
          child: IsiMap()
        ),
        LayoutBuilder(
          builder: (builder, constraint) {
            return DraggableScrollableSheet(
              key: sheet,
              initialChildSize: 0.5,
              maxChildSize: 0.7, //ubah jd 1 klo mw cover 1 screen
              minChildSize: 0,
              expand: true,
              snap: true,
              snapSizes: [
                60 / constraint.maxHeight,
                0.5 
              ],
              builder: (BuildContext context, ScrollController scrollController){
                return DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 1)
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22)
                    )
                  ),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: widget.anak,
                      )
                    ],
                  ),
                );
              }
            );
          }
        )
      ],
    );
  }
}