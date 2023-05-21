import 'package:etravel/config/app_colors.dart';
import 'package:etravel/config/routes.dart';
import 'package:etravel/models/location/location.dart';
import 'package:etravel/screens/home/home_controller.dart';
import 'package:etravel/widgets/etravel_elevated_button.dart';
import 'package:etravel/widgets/etravel_nav_drawer.dart';
import 'package:etravel/widgets/etravel_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static String name = '/home';

  @override
  Widget build(BuildContext context) {
    final _ = Get.find<HomeController>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(
              () => Container(
                child: _.isLoadingMap
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : _.permissionDenied
                        ? const Center(
                            child: Text(
                                'We will need location permission to coninue'))
                        : GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _.currentLocation!.latitude,
                                _.currentLocation!.longitude,
                              ),
                              zoom: 20,
                            ),
                            myLocationEnabled: true,
                            onMapCreated: (GoogleMapController controller) {
                              _.mapController = controller;
                            },
                            markers: Set<Marker>.from(_.markers),
                            polylines: Set<Polyline>.of(_.polylines.values),
                          ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Stack(
                children: [
                  //temp buttons
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        const Text('Welcome to Home'),
                        ElevatedButton(
                          onPressed: _.logout,
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  ),
                  //menu icon
                  Positioned(
                    top: 20,
                    left: 10,
                    child: Builder(
                      builder: (context) => InkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Stack(
              children: [
                //bottom draggable
                SizedBox.expand(
                  child: NotificationListener<DraggableScrollableNotification>(
                    onNotification:
                        (DraggableScrollableNotification DSNotification) {
                      // log(DSNotification.extent.toString());
                      if (DSNotification.extent > (96.5 / Get.height)) {
                        // _.dragUpDown(
                        //     DSNotification.extent, DSNotification.initialExtent);
                        _.extentDiff(DSNotification.extent -
                            DSNotification.initialExtent);
                        // log(_.extentDiff().toString());

                        _.extent(DSNotification.extent);
                      }
                      return true;
                    },
                    child: DraggableScrollableSheet(
                        controller: _.dragController,
                        snap: true,
                        minChildSize: _.minModalSize,
                        maxChildSize: 1,
                        initialChildSize: 96.5 / Get.height,
                        builder: (context, scrollController) => Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, -3),
                                    color: Colors.black.withOpacity(
                                      0.15 *
                                          (_.extentDiff() +
                                                  (_.minModalSize) -
                                                  1)
                                              .abs(),
                                    ),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: ListView(
                                controller: scrollController,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                children: [
                                  //drag header button
                                  Center(
                                    child: Container(
                                      height: 5.5,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.inputField,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 7),
                                    ),
                                  ),
                                  //text field
                                  AnimatedOpacity(
                                    duration: 350.milliseconds,
                                    opacity:
                                        (_.extentDiff() + (_.minModalSize) - 1)
                                            .abs(),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: ETravelTextField(
                                        focusNode: AlwaysDisabledFocusNode(),
                                        onTap: _.openModal,
                                        prefixIcon: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDFDFDF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: 'Where to?',
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ),
                ),
                //top draggable
                Obx(
                  () => Positioned(
                    left: 0,
                    right: 0,
                    top: _.topPosition >= 0 ? 0 : _.topPosition,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: SafeArea(
                        child: SizedBox(
                          height: 175,
                          child: ListView(
                            padding: const EdgeInsets.all(15),
                            shrinkWrap: true,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: _.closeModal,
                                      child: const Icon(
                                        Icons.close,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 35),
                                    const Text(
                                      'Your route',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.add,
                                      size: 30,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              ETravelTextField(
                                height: 50,
                                onTap: () =>
                                    _.openPlacesList(context, Location.pickup),
                                focusNode: AlwaysDisabledFocusNode(),
                                prefixIcon: Radio(
                                  value: true,
                                  fillColor: MaterialStateProperty.all(
                                    const Color(0xFF4527B0),
                                  ),
                                  groupValue: true,
                                  onChanged: null,
                                ),
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                showSuffixIcon: true,
                                suffixIcon: InkWell(
                                  onTap: () =>
                                      _.goToLocationOnMap(Location.pickup),
                                  child: const Icon(
                                    Icons.map,
                                    color: Color(0xFF4527B0),
                                  ),
                                ),
                                controller: _.pickUpTextCtl,
                                hintText: 'Search pick-up location',
                                hintStyle: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Obx(
                                () => ETravelTextField(
                                  key: ValueKey(_.extent() == 1.0),
                                  height: 50,
                                  autofocus: _.extent() == 1.0 ? true : false,
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () => _.goToLocationOnMap(
                                        Location.destination),
                                    child: const Icon(
                                      Icons.map,
                                      color: Color(0xFF4527B0),
                                    ),
                                  ),
                                  showSuffixIcon: true,
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  controller: _.destinationTextCtl,
                                  onTap: () => _.openPlacesList(
                                      context, Location.destination),
                                  focusNode: AlwaysDisabledFocusNode(),
                                  hintText: 'Destination',
                                  hintStyle: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //bottom info sheet
                Obx(
                  () => AnimatedPositioned(
                    left: 0,
                    right: 0,
                    bottom: _.isInfoSheetShowing() ? 0 : -250,
                    duration: 500.milliseconds,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      height: 250,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shrinkWrap: true,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () => _.isInfoSheetShowing(false),
                              child: const Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.car_rental,
                                  size: 32,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Lite',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text('${_.timeToBeDeleted()}   4 seats')
                                      ],
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Obx(
                                  () => Text(
                                    '#${_.priceToBeDeleted()}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.paymentScreen),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                  child: Row(
                                children: [
                                  Icon(
                                    Icons.money,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    children: [],
                                  ),
                                ],
                              )),
                            ),
                          ),
                          ETravelElevatedButton(
                            text: 'Select Lite',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //top Modal
        ],
      ),
      drawer: const ETravelNavDrawer(),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
