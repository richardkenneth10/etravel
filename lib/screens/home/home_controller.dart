import 'dart:developer' as dev;
import 'dart:math';

import 'package:etravel/models/location/location.dart' as e;
import 'package:etravel/services/auth_service.dart';
import 'package:etravel/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as p;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class HomeController extends GetxController {
  final extent = 0.0.obs;

  final extentDiff = 0.0.obs;

  final dragController = DraggableScrollableController();

  double minModalSize = 96.5 / Get.height;

  double get topPosition => (extentDiff() * Get.height) - 175.0;

  final pickUpTextCtl = TextEditingController();

  final destinationTextCtl = TextEditingController();

  final isInfoSheetShowing = false.obs;

  final timeToBeDeleted = ''.obs;
  final priceToBeDeleted = 0.obs;

  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  List<LatLng> polylineCoordinates = [];

  late double startLatitude;
  late double startLongitude;
  double? destinationLatitude;
  double? destinationLongitude;
  late String startAddress;
  String? destinationAddress;

  final _location = Get.find<LocationService>();

  Position? get currentLocation => _location.currentPosition();

  Position? get lastKnownLocation => _location.lastKnownPosition();

  bool get isLoadingMap => _location.isLoading();

  get permissionDenied => !_location.permissionGranted;

  GoogleMapController? mapController;
  Future<void> logout() async {
    await Get.find<AuthService>().logout();
  }

  void dragUpDown(double newExtent, double initialExtent) {
    // extent(newExtent);
    // topPosition(
    //   (newExtent * Get.height) - (initialExtent * Get.height) - 175,
    // );
  }

  void closeModal() {
    dragController.animateTo(
      minModalSize,
      duration: 1.seconds,
      curve: Curves.easeInOut,
    );
    // extentDiff(0);
  }

  void openModal() {
    dragController.animateTo(
      1.0,
      duration: 1.seconds,
      curve: Curves.easeInOut,
    );
    // extentDiff(0);
  }

  Future<void> openPlacesList(BuildContext context, e.Location location) async {
    final place = await PlacesAutocomplete.show(
      context: context,
      apiKey: FlutterConfig.get('GOOGLE_MAPS_API_KEY'),
      mode: Mode.overlay, // Mode.fullscreen
      language: "en", strictbounds: false, types: [],
      components: [
        Component(Component.country, "ng"),
      ],
    );

    if (place != null) {
      if (location == e.Location.pickup) {
        pickUpTextCtl.text = place.description.toString();
      } else if (location == e.Location.destination) {
        destinationTextCtl.text = place.description.toString();
      }

      final plist = GoogleMapsPlaces(
        apiKey: FlutterConfig.get('GOOGLE_MAPS_API_KEY'),
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      String placeid = place.placeId ?? "0";
      final detail = await plist.getDetailsByPlaceId(placeid);
      final geometry = detail.result.geometry!;
      final lat = geometry.location.lat;
      final long = geometry.location.lng;
      var newlatlong = LatLng(lat, long);
// Retrieving placemarks from addresses
      // List<g.Location> startPlacemark =
      //     await locationFromAddress(pickUpTextCtl.text);
      // List<g.Location> destinationPlacemark =
      //     await locationFromAddress(destinationTextCtl.text);

// Storing latitude & longitude of start and destination location

      switch (location) {
        case e.Location.pickup:
          startLatitude = lat;
          startLongitude = long;
          if (destinationLatitude != null && destinationLongitude != null) {
            setUpPostLocationsSelections();
          }

          break;
        case e.Location.destination:
          destinationLatitude = lat;
          destinationLongitude = long;
          setUpPostLocationsSelections();

          break;
      }
    }
  }

  Future<void> setUpPostLocationsSelections() async {
    addMarkers();

    closeModal();
    panAndZoomCameraToAccomodateMarkers();
    await drawRoute();

    final distance = _calculateTotalDistance();
    final distanceStr = distance.toStringAsFixed(2);
    final timeInMins = (distance * 16).round();
    timeToBeDeleted.value = '$timeInMins mins';
    final price = timeInMins * 45;
    priceToBeDeleted.value = price;
    dev.log(distanceStr + ' km');

    isInfoSheetShowing(true);
  }

  void addMarkers() {
    String startCoordinatesString = '($startLatitude, $startLongitude)';
    String destinationCoordinatesString =
        '($destinationLatitude, $destinationLongitude)';

// Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId(startCoordinatesString),
      position: LatLng(startLatitude, startLongitude),
      infoWindow: InfoWindow(
        title: 'Start $startCoordinatesString',
        snippet: startAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

// Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId(destinationCoordinatesString),
      position: LatLng(destinationLatitude!, destinationLongitude!),
      infoWindow: InfoWindow(
        title: 'Destination $destinationCoordinatesString',
        snippet: destinationAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    markers.clear();
// Add the markers to the list
    markers.add(startMarker);
    markers.add(destinationMarker);
  }

  void panAndZoomCameraToAccomodateMarkers() {
    // Calculating to check that the position relative
// to the frame, and pan & zoom the camera accordingly.
    double miny = (startLatitude <= destinationLatitude!)
        ? startLatitude
        : destinationLatitude!;
    double minx = (startLongitude <= destinationLongitude!)
        ? startLongitude
        : destinationLongitude!;
    double maxy = (startLatitude <= destinationLatitude!)
        ? destinationLatitude!
        : startLatitude;
    double maxx = (startLongitude <= destinationLongitude!)
        ? destinationLongitude!
        : startLongitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

// Accommodate the two locations within the
// camera view of the map
    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
  }

  Future<void> drawRoute() async {
    polylines.clear();
    polylineCoordinates.clear();

    // Initializing PolylinePoints
    PolylinePoints polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      FlutterConfig.get('GOOGLE_MAPS_DIRECTIONS_API_KEY'),
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude!, destinationLongitude!),
      travelMode: p.TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        );
      }
    }

    // Defining an ID
    PolylineId id = const PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  double _calculateTotalDistance() {
    double totalDistance = 0.0;
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _calculateCoordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    return totalDistance;
  }

  double _calculateCoordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Future<void> onInit() async {
    super.onInit();

    startLatitude = currentLocation?.latitude ?? 23.5;
    startLongitude = currentLocation?.longitude ?? 23.5;

    // log(Get.find<FirebaseAuthService>().userData.toString());
    List<Placemark> placemarks = await placemarkFromCoordinates(
      startLatitude,
      startLongitude,
    );

    Placemark place = placemarks[0];
    // log(place.toString() ?? 'nil');

    final userCurrentAddress =
        "${place.street}, ${place.locality}, ${place.country}";
    startAddress = userCurrentAddress;

    final l = await locationFromAddress(userCurrentAddress);
    // log("${l[0].latitude}: : : ${l[0].longitude}");
    // log("${currentLocation?.latitude}: : : ${currentLocation?.longitude}");

    Future.delayed(5.seconds, (() => pickUpTextCtl.text = userCurrentAddress));
  }

  goToLocationOnMap(e.Location location) {
    switch (location) {
      case e.Location.pickup:
        closeModal();
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(startLatitude, startLongitude),
              zoom: 17,
            ),
          ),
        );

        break;
      case e.Location.destination:
        if (destinationLatitude == null || destinationLongitude == null) return;
        closeModal();
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(destinationLatitude!, destinationLongitude!),
              zoom: 17,
            ),
          ),
        );

        break;
    }
  }
}
