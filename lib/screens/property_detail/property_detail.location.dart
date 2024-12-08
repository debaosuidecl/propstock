import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:propstock/models/colors.dart';
import 'package:propstock/models/property.dart';

class PropertyDetailLocation extends StatefulWidget {
  final Property? property;
  const PropertyDetailLocation({super.key, required this.property});

  @override
  State<PropertyDetailLocation> createState() => _PropertyDetailLocationState();
}

class _PropertyDetailLocationState extends State<PropertyDetailLocation> {
  bool truncateAbout = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: const Text(
            "Location",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color(0xff1D3354), fontSize: 18, fontFamily: "Inter"),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          child: Text(
            "${widget.property!.location}",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              color: Color(0xff5E6D85),
              fontSize: 16,
              fontFamily: "Inter",
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // Container(
        //   height: 340,
        //   child: GoogleMap(
        //       initialCameraPosition: CameraPosition(
        //     target: LatLng(48.8698679, 2.3072976),
        //     zoom: 4.5,
        //   )),
        // ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}


//  Container(

//           height: 60,
//           child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//             target: LatLng(2, 120),
//           )),
//         )