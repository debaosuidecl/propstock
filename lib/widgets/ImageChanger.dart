import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/utils/showErrorDialog.dart';

class ImageChanger extends StatelessWidget {
  List<dynamic>? images;
  int imageIndex;
  void Function(int) setCurrentImage;
  ImageChanger(
      {super.key,
      required this.images,
      required this.imageIndex,
      required this.setCurrentImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 100),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: Image.network(
            images![imageIndex],
            key: ValueKey<int>(imageIndex),
            // width: double.infinity,
            width: MediaQuery.of(context).size.width,
            height: 430,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 50,
          child: Container(
            // color: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset("images/fi_x.svg")),
                Row(
                  children: [
                    SvgPicture.asset("images/heart2.svg"),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset("images/ShareNetworkWhite.svg"),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 10,
          child: GestureDetector(
            onTap: () {
              showErrorDialog("Virtual Tour Coming soon", context);
            },
            child: Container(
              width: 89,
              height: 32,
              padding: EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.all(Radius.circular(
                    5,
                  ))),
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(
                    "images/PlayCircle.svg",
                    height: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Virtual tour",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          child: Container(
            height: 20,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: images!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setCurrentImage(index);
                    },
                    child: Container(
                      height: index == imageIndex ? 17 : 12,
                      width: index == imageIndex ? 17 : 12,
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: index == imageIndex
                            ? const Color(0xffffffff)
                            : const Color(0xffbbbbbb),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
    ;
  }
}
