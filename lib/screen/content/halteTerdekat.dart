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
              UiBottomSheet(),
              UiBottomSheet(),
              UiBottomSheet(),
              UiBottomSheet(),
              UiBottomSheet(),
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
  bool _isLoading = true;
  bool _isRefreshed = false;

  Future<void> _drawUserCircle(double radiusnya) async {
    if (controller != null && _isLoading == false) {
      // Remove previous circle before drawing a new one
      await controller?.removeCircle('circle0');

      await controller?.drawCircle(
        CircleOSM(
          key: "circle0",
          centerPoint: GeoPoint(latitude: latitudenya, longitude: longitudenya),
          radius: radiusnya, //adjust disini
          color: Colors.blue.withOpacity(0.3),
          borderColor: Colors.blue,
          strokeWidth: 0.1,
        ),
      );
    }
  }

  var prevLatitude = [];
  var prevLongitude = [];

  Future<void> _determineAndSetPosition({String? isUpdated}) async {
    try {
      var posisi = await _determinePosition();

      //if(!_isSetLocation){
        setState(()  {
          latitudenya = posisi.latitude;
          longitudenya = posisi.longitude;

          if(isUpdated == "ya"){
            if (prevLatitude.isNotEmpty && prevLongitude.isNotEmpty) {
                print("Latitude lama ${prevLatitude[0]}");

              // controller!.changeLocationMarker(
              //   oldLocation: GeoPoint(latitude: prevLatitude[0], longitude: prevLongitude[0]), 
              //   newLocation: GeoPoint(latitude: latitudenya, longitude: longitudenya)
              // );

              controller!.removeMarker(
                GeoPoint(latitude: prevLatitude[0], longitude: prevLongitude[0])
              );

              controller!.changeLocation(
                GeoPoint(latitude: latitudenya, longitude: longitudenya)
              );

              // Update previous location
              prevLatitude[0] = latitudenya;
              prevLongitude[0] = longitudenya;
            } else {
              print("Previous location data is not available.");
            }

          
          }else{
            controller = MapController.withPosition(
              initPosition: GeoPoint(
                latitude: latitudenya, 
                longitude: longitudenya
              )
            );

            prevLatitude.add(latitudenya);
            prevLongitude.add(longitudenya);
          }

          double radius = _calculateRadiusBasedOnLocation(latitudenya, longitudenya);

          _drawUserCircle(radius);
          
          _isLoading = false; // loading kelar.
          // _isSetLocation = true; //set true, biar if ini gk ke eksekusi lagi

        });
      //}
    } catch (e) {
      print("Error Determine Location $e");
    }
  }


  // fungsi update posisi pas onload
  @override
  void initState(){
    super.initState();

    _determineAndSetPosition();

    //fungsi yg d buat di _determinePosition.
    // fungsi ini sudah diconvert jadi async await.
    // _determinePosition().then((posisi) {
    //   if(!_isSetLocation){ //buat boolean supaya cmn setLocation 1x aja, gk ush auto refresh
    //     setState(() {
    //       latitudenya = posisi.latitude;
    //       longitudenya = posisi.longitude;

    //       controller = MapController.withPosition(
    //         initPosition: GeoPoint(
    //           latitude: latitudenya, 
    //           longitude: longitudenya
    //         )
    //       );

    //       double radius = _calculateRadiusBasedOnLocation(latitudenya, longitudenya);

    //       _drawUserCircle(radius);
          
    //       _isLoading = false; // loading kelar.
    //       _isSetLocation = true; //set true, biar if ini gk ke eksekusi lagi

    //     });
    //   }
    // }); 
  }

  double _calculateRadiusBasedOnLocation(double latitude, double longitude){
    if (latitude > 0){
      return 1200.0; // set a bigger radius for positive latitudes
    }else{
      return 800.0; //set a smaller radius for negative latitudes
    }
  }

  bool buatEnableTracking = true;
  bool buatUnfollowUser = false;
  
  // referensi ada didokumentasi flutter_osm_plugin
  // install di pubspec.yaml : 
  // flutter_osm_plugin: ^1.3.2
  // geolocator: ^9.0.2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator()) : SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            if(controller != null)
              Container(
                child: OSMFlutter(
                  controller: controller!,
                  osmOption: OSMOption(
                    userTrackingOption: UserTrackingOption(
                      enableTracking: buatEnableTracking,
                      unFollowUser: buatUnfollowUser,
                      
                    ),
                    zoomOption:  ZoomOption(
                      initZoom: 8,
                      minZoomLevel: 12,
                      maxZoomLevel: 19,
                      stepZoom: 1.0
                    ),
                    // userLocationMarker: (!_isRefreshed) ? UserLocationMaker(
                    //   personMarker: const MarkerIcon(
                    //     icon: Icon(
                    //         Icons.location_history_rounded,
                    //         color: Colors.red,
                    //         size: 48,
                    //     ),
                    //   ),
                    //   directionArrowMarker: const MarkerIcon(
                    //     icon: Icon(
                    //         Icons.location_on,
                    //         size: 48,
                    //         color: Colors.blue,
                    //     ),
                    //   )
                    // ) : null,
                    roadConfiguration: RoadOption(
                      roadColor: Colors.yellowAccent,
                    ),

                  ),
                  onMapIsReady: (isReady) {
                    if(isReady){
                      double radius = _calculateRadiusBasedOnLocation(latitudenya, longitudenya);
                      _drawUserCircle(radius);
                    }
                  },
                ),
              ),
            //end if
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future.delayed(const Duration(milliseconds: 800), () {
            _isLoading = true;
            


            buatEnableTracking = false;
            buatUnfollowUser = true;

            _determineAndSetPosition(isUpdated: "ya");

            // setState(() {
            //   buatEnableTracking = false;
            // });


            // _determinePosition().then((posisi) {
            //   setState(() {
            //     latitudenya = posisi.latitude;
            //     longitudenya = posisi.longitude;
                // controller!.changeLocation(
                //   GeoPoint(latitude: latitudenya, longitude: longitudenya)
                // );

            //     double radius = _calculateRadiusBasedOnLocation(latitudenya, longitudenya);

            //     _isRefreshed = true;

            //     _drawUserCircle(radius);
            //   });
            //});
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

// shortcut buat state : stful

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
                      topButtonIndicator(),
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

  SliverToBoxAdapter topButtonIndicator(){
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Center(
                child: Wrap(
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(
                        top: 10, bottom: 10
                      ),
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class UiBottomSheet extends StatelessWidget {
  const UiBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.only(
          left: 30,
          right: 30
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    color: Colors.black12,
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        color: Colors.black12,
                        height: 20,
                        width: 240,
                      ),
                    ),
                    SizedBox(height: 5,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        color: Colors.black12,
                        height: 20,
                        width: 180,
                      ),
                    ),
                    SizedBox(height: 50)
                  ],
                )
              ],
            ),
            SizedBox(height: 10)
          ],
        ),

      ),
    );
  }
}