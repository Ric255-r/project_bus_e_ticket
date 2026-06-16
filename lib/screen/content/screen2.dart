import 'dart:ffi';

import 'package:bus_hub/screen/content/paketWisata.dart';
import 'package:bus_hub/screen/content/panduanBepergian.dart';
import 'package:bus_hub/screen/function/me.dart';
import 'package:flutter/services.dart';
import '../function/ip_address.dart';
import '../menu/menu3.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:bus_hub/main.dart';
import '../menu/menu2.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import '../function/confirmExit.dart';
import './halteTerdekat.dart';
import './pesanTiket.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cherry_toast/cherry_toast.dart';

// referensi carousel slider
// https://stackoverflow.com/questions/78688921/error-carouselcontroller-is-imported-from-both-package-in-flutter

class SecondScreen extends StatelessWidget {
  // harus define sebagai Map. supaya bisa get data kek data['a']['b']
  final Map<String, dynamic> data;
  final int? indexScreen; // buat set halaaman

  String? alertMessage; // buat notif kalo ubah profil atau passwd
  // Ambil parameter dari main.dart
  SecondScreen({required this.data, this.indexScreen, this.alertMessage});
  // end ambil data main.dart

  // anggapannya class ini class pertamakali onload.
  // lalu pas pencet navbar. class ini kena replace kaya innerHTML.
  @override
  Widget build(BuildContext context) {
    if (alertMessage != null) {
      // Widgetbinding ini macam DOMContentLoaded di JS / Onload.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Fluttertoast.showToast(
        //   msg: alertMessage!,
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.BOTTOM,
        //   timeInSecForIosWeb: 1,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(alertMessage!)));
      });
    }

    return SafeArea(
      child: indexScreen != null
          ? IsiNavbar(
              isiData: data,
              indexScreen: indexScreen,
            )
          : IsiNavbar(isiData: data),
    );
  }
}

class IsiBody extends StatefulWidget {
  // Buat Parameter
  final Map<String, dynamic> dataPassing;

  IsiBody({required this.dataPassing});
  // End Parameter

  @override
  _Kontennya createState() => _Kontennya();
}

class _Kontennya extends State<IsiBody> {
  // Taruh Fungsi disini
  double Tinggi = 150;
  bool changes = true;

  final AutoSizeGroup _menuTextGroup = AutoSizeGroup();

  final List<String> imgList = [
    'assets/images/carousel1.jpeg',
    'assets/images/carousel2.png',
    'assets/images/carousel3.jpeg'
  ];

  // POI state variables
  String _selectedCategory = 'kuliner';
  bool _isLoadingPoi = false;
  List<dynamic> _poiList = [];
  String? _poiErrorMessage;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchPOIs();
  }

  Future<void> _fetchPOIs() async {
    if (!mounted) return;
    setState(() {
      _isLoadingPoi = true;
      _poiErrorMessage = null;
    });

    try {
      // 1. Get location with fallback
      double lat = -0.0263; // Fallback Pontianak
      double lon = 109.3425;

      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always) {
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 5),
            );
            lat = position.latitude;
            lon = position.longitude;
          }
        }
      } catch (e) {
        print("Gagal mengambil lokasi live, menggunakan fallback Pontianak: $e");
      }

      // 2. Fetch from backend
      final response = await _dio.get(
        '${myIpAddr()}/poi-terdekat',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'category': _selectedCategory,
          'radius': 3000,
          'limit': 15,
        },
      );

      if (!mounted) return;
      setState(() {
        _poiList = response.data['items'] as List<dynamic>? ?? [];
        _isLoadingPoi = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingPoi = false;
        _poiErrorMessage = "Gagal mengambil data POI: $e";
      });
    }
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _fetchPOIs();
  }

  Future<void> _openMap(double lat, double lon, String name) async {
    final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");
    try {
      final success = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tidak dapat membuka peta")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      }
    }
  }

  Widget _buildCategoryChip(String categoryId, String label) {
    final isSelected = _selectedCategory == categoryId;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            _onCategoryChanged(categoryId);
          }
        },
        selectedColor: Colors.blue.shade100,
        backgroundColor: Colors.grey.shade100,
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue.shade800 : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPoiCard(dynamic poi) {
    final name = poi['name'] ?? 'Tempat tanpa nama';
    final distance = poi['distance_km'] ?? 0.0;
    final lat = poi['latitude'];
    final lon = poi['longitude'];

    // Determine category icon/label
    String typeLabel = 'POI';
    if (poi['amenity'] != null)
      typeLabel = poi['amenity'].toString().replaceAll('_', ' ');
    if (poi['tourism'] != null)
      typeLabel = poi['tourism'].toString().replaceAll('_', ' ');
    if (poi['leisure'] != null)
      typeLabel = poi['leisure'].toString().replaceAll('_', ' ');

    // Capitalize typeLabel
    if (typeLabel.isNotEmpty) {
      typeLabel = typeLabel.substring(0, 1).toUpperCase() + typeLabel.substring(1);
    }

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  typeLabel,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  "${distance} km terdekat",
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 11),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 28,
              child: ElevatedButton.icon(
                onPressed: () => _openMap(lat, lon, name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: const Icon(Icons.directions, size: 14),
                label: const Text(
                  "Rute",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          // 1. Bagian Carousel (Header Background)
          Container(
            color: Colors.blue[400],
            height: 300,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 50, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blueGrey.shade100),
                      ),
                      height: 215,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                        child: Column(
                          children: [
                            cs.CarouselSlider(
                              items: imgList
                                  .map((item) => Center(
                                          child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          item,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      )))
                                  .toList(),
                              options: cs.CarouselOptions(
                                height: 200,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 2.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // 2. Scrollable Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 245), // Overlap offset

              // 3. Menu Card
              Container(
                margin: const EdgeInsets.only(
                  top: 15,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 15),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                text: 'Mau Ngapain Hari Ini? \n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: [
                          // Pesan Tiket
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Pesantiket()));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: const Image(
                                        image: AssetImage('assets/images/tiket.png'),
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Center(
                                      child: AutoSizeText(
                                        "Pesan Tiket",
                                        group: _menuTextGroup,
                                        maxLines: 2,
                                        minFontSize: 8,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Loket Terdekat
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Halteterdekat()));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: const Image(
                                        image: AssetImage('assets/images/halte.png'),
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Center(
                                      child: AutoSizeText(
                                        "Loket Terdekat",
                                        group: _menuTextGroup,
                                        maxLines: 2,
                                        minFontSize: 8,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Paket Wisata
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              paketwisata1(title: "lala")));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: const Image(
                                        image: AssetImage('assets/images/wisata.png'),
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Center(
                                      child: AutoSizeText(
                                        'Paket Wisata',
                                        group: _menuTextGroup,
                                        maxLines: 2,
                                        minFontSize: 8,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Panduan Bepergian
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => panduan()));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: const Image(
                                        image: AssetImage('assets/images/guidebook.png'),
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Center(
                                      child: AutoSizeText(
                                        'Panduan Bepergian',
                                        group: _menuTextGroup,
                                        maxLines: 2,
                                        minFontSize: 8,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(text: const TextSpan(text: '')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. Point of Interests Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tempat Menarik Terdekat",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (_isLoadingPoi)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryChip('kuliner', '🍽️ Kuliner'),
                          _buildCategoryChip('ibadah', '🕌 Ibadah'),
                          _buildCategoryChip('kesehatan', '🏥 Kesehatan'),
                          _buildCategoryChip('wisata', '🏞️ Wisata'),
                          _buildCategoryChip('penginapan', '🏨 Hotel'),
                          _buildCategoryChip('atm', '🏧 ATM/Bank'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isLoadingPoi && _poiList.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_poiErrorMessage != null && _poiList.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            _poiErrorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else if (_poiList.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Text(
                            "Tidak ada tempat ditemukan di sekitar Anda.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 145,
                        margin: const EdgeInsets.only(top: 8),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _poiList.length,
                          itemBuilder: (context, index) {
                            final poi = _poiList[index];
                            return _buildPoiCard(poi);
                          },
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],
          )
        ],
      ),
    );
  }
}

// ini untuk state NavbarBottom.
class IsiNavbar extends StatefulWidget {
  // Buat Parameter. yang ada di SecondScreen.
  final Map<String, dynamic> isiData;
  final int? indexScreen;

  // argumen ini di isi dengan data yg sama dengan body()
  IsiNavbar({required this.isiData, this.indexScreen});
  // End Parameter

  @override
  _KontenNavbar createState() => _KontenNavbar();
}

class _KontenNavbar extends State<IsiNavbar> {
  // Utk Navigasi
  int _currentIndex = 0;
  late List<Widget> _children;
  // End Utk Navigasi

  void onBarTapped(int index) {
    setState(() {
      //set index utk menu children
      _currentIndex = index;
      // khusus menu2 tambah key supaya auto rebuild
      _children[1] = Menu2(
        key: UniqueKey(),
        status: "PENDING",
      );
    });
  }

  // buat track scroll
  int _scrollPosition = 0;

  void _onScrollNotification(ScrollNotification notif) {
    if (notif is ScrollUpdateNotification) {
      //cek kalo dia ngescroll scr vertical
      if (notif.metrics.axis == Axis.vertical) {
        setState(() {
          _scrollPosition = notif.metrics.pixels.toInt();
        });
        // print("Sekarang di posisisi $_scrollPosition");
      }

      // if(notif.metrics.pixels.toInt() >= 4000000){
      //   // cara bodo ini buat exclude posisi carousel.
      //   // posisi carousel bisa smpe 4jt an
      //   // soalny scrollnotification ngebaca posisi carousel jg.
      // }else{
      //   setState(() {
      //     _scrollPosition = notif.metrics.pixels.toInt();
      //   });
      //   print("Sekarang di posisisi $_scrollPosition");
      // }
    }
  }
  // End buat trackscroll

  // Harus pake tipedata ini kalo mau passing data object ke file lain
  late Map<String, dynamic> dataIsiNavbar;
  // Websocket channel
  late WebSocketChannel _channel;
  Timer? _timerWebSocket;
  // buat navigate ke menu 2
  String? status;

  @override
  void initState() {
    super.initState();

    // Delay the WebSocket connection to avoid crashes
    _timerWebSocket = Timer(Duration(milliseconds: 1300), () {
      _connectToWebSocket();
    });

    // widget isiData diambil dari argument class SecondScreen(paling atas codeny).
    dataIsiNavbar = widget.isiData;

    if (widget.indexScreen != null) {
      _currentIndex = widget.indexScreen!;
    }

    _children = [
      IsiBody(dataPassing: dataIsiNavbar),
      Menu2(),
      // Menu2(getDataNya: dataIsiNavbar),
      Menu3()
    ];
  }
  // end passing data

  // Fungsi WebSocket

  Future<void> _connectToWebSocket() async {
    // mesti replace dari http ke ws. krn myIpAddr ini ada http.
    var originalUrl = myIpAddr();
    var replacedUrl = originalUrl.replaceAll("http", "ws");

    // ambil endpoint route websocket yg udh dibuat
    var wsUri = Uri.parse("$replacedUrl/ws-transaksi");

    // buat koneksi websocket
    _channel = IOWebSocketChannel.connect(wsUri);

    // init AwesomeNotifications
    AwesomeNotifications().initialize(
        null, // null for default icon
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance:
                NotificationImportance.High, // Ensure high importance untuk event Tap
          )
        ],
        debug: true);

    // kombinasi dari AwesomeNotifications dan cherry_toast
    // return data status ini isinya Sukses, Ditolak, dan Pending.
    // Hasil Translate dari triggerNotif Websocket Screen2.dart
    void triggerNotif(String id_trans, String status) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Transaksi ${id_trans} anda ${status}',
        body: 'Klik Disini Untuk melihat detail transaksi anda',
      ));

      // Event ketika dipencet. initialize setelah websocket jalan
      AwesomeNotifications().setListeners(
          onActionReceivedMethod: (ReceivedAction receivedAct) async {
        // Handle Notif di Tap
        if (receivedAct.id == 10) {
          // Notif dengan Id ke 10 dipencet
          print("Notif 10 dipencet");

          // Untuk pindah menu ke bagian riwayat
          // key disini untuk force rebuild menu2. incase notif muncul, lalu user tap & posisi user di menu riwayat/history
          setState(() {
            switch (status) {
              case "Sukses":
                _children[1] = Menu2(key: UniqueKey(), status: "Sukses");
                break;
              case "Ditolak":
                _children[1] = Menu2(key: UniqueKey(), status: "Ditolak");
                break;
              default:
                _children[1] = Menu2(key: UniqueKey(), status: "Pending");
                break;
            }
            _currentIndex = 1;
          });
        }
      });

      // Ini dari cherry_toast. bukan punya awesome_notification
      CherryToast.info(
        title: Text('Transaksi ${id_trans} anda ${status}',
            style: TextStyle(color: Colors.black)),
        action: Text("Klik Disini Untuk Melihat Transaksi",
            style: TextStyle(color: Colors.black)),
        actionHandler: () {
          // Untuk pindah menu ke bagian riwayat
          // key disini untuk force rebuild menu2. incase notif muncul, lalu user tap & posisi user di menu riwayat/history
          setState(() {
            switch (status) {
              case "Sukses":
                _children[1] = Menu2(key: UniqueKey(), status: "Sukses");
                break;
              case "Ditolak":
                _children[1] = Menu2(key: UniqueKey(), status: "Ditolak");
                break;
              default:
                _children[1] = Menu2(key: UniqueKey(), status: "Pending");
                break;
            }
            _currentIndex = 1;
          });
        },
      ).show(context);
    }

    // ambil pesan dari server
    _channel.stream.listen((message) async {
      // parse message yg akan datang. asumsinya json.
      final data = jsonDecode(message);
      var status = "";
      // get datauser
      var jwt = await getStoredJwt();
      var thisUser = await getMyData(jwt);

      // Supaya dia hanya ketrigger dgn user yg login saja
      if (thisUser['email'] == data['email_cust']) {
        switch (data['status_trans']) {
          case 'COMPLETED':
            setState(() {
              status = "Sukses";
            });
            triggerNotif(data['id_trans'], status);

            break;
          case 'CANCELLED':
            setState(() {
              status = "Ditolak";
            });
            triggerNotif(data['id_trans'], status);
            break;
        }
      }

      print(data);
      print("Hai Dari Websocket");
    }, onError: (err) {
      print("Websocket error: $err");
    }, onDone: () {
      print("Websocket Closed");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _channel.sink.close();
    _timerWebSocket?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // ini bakal nimpa yang class pertamakali (SecondScreen);
    return WillPopScope(
      // widget buat konfirmasi
      onWillPop: () async => await showPopUpExit(context),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[400],
            // backgroundColor: (_scrollPosition >= 10) ? Colors.grey[400] : Colors.blue[400],
            toolbarHeight: (_currentIndex == 0) ? 80 : null,
            title: (_currentIndex == 0)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //rata kiri
                    children: [
                      Text(
                        'Hai ${dataIsiNavbar['usernya']['username']}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 3, bottom: 4),
                        child: Text(
                          'Welcome To Bus_Hub!',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      )
                    ],
                  )
                : (_currentIndex == 2)
                    ? const Column(
                        crossAxisAlignment: CrossAxisAlignment.start, //rata kiri
                        children: [
                          Text(
                            'Menu',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      )
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.start, //rata kiri
                        children: [
                          Text(
                            'History',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ))
            ],
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ));
            }),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: dataIsiNavbar['profile_picture'] != null
                        ? NetworkImage(
                                '${myIpAddr()}/fotoprofile/${dataIsiNavbar['profile_picture']}')
                            as ImageProvider
                        : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                  ),
                  accountName: Text(
                    dataIsiNavbar['username'] ?? 'User',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                  ),
                  accountEmail: Text(
                    dataIsiNavbar['email'] ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.blue),
                  title: const Text("Dashboard",
                      style:
                          TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context);
                    onBarTapped(0);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.confirmation_number, color: Colors.blue),
                  title: const Text("Pesan Tiket",
                      style:
                          TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Pesantiket()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.blue),
                  title: const Text("Halte Terdekat",
                      style:
                          TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Halteterdekat()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.card_travel, color: Colors.blue),
                  title: const Text("Paket Wisata",
                      style:
                          TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => paketwisata1(title: "lala")));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book, color: Colors.blue),
                  title: const Text("Panduan Bepergian",
                      style:
                          TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const panduan()));
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  onTap: () async {
                    Navigator.pop(context);
                    await removeStoredJwt();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                          (Route<dynamic> route) => false);
                    }
                  },
                )
              ],
            ),
          ),
          body: NotificationListener(
              onNotification: (ScrollNotification notif) {
                _onScrollNotification(notif);
                return true;
              },
              child: _children[_currentIndex]),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: onBarTapped,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: 'Profile')
              ])),
    );
  }
}
