import 'package:flutter/material.dart';

class FilterSelector extends StatelessWidget {
  List<String> options;
  List<String> selected_options;
  String title;
  Function selectOptionHandler;
  FilterSelector({
    super.key,
    required this.options,
    required this.title,
    required this.selected_options,
    required this.selectOptionHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green,
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      // height: MediaQuery.of(context).size.height,
      child: Column(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xff1D3354),
                fontSize: 18,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: options.map((item) {
                return GestureDetector(
                  onTap: () {
                    selectOptionHandler(item);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 23, vertical: 14),
                    // width: 10,
                    margin: EdgeInsets.only(right: 10, bottom: 20),
                    decoration: BoxDecoration(
                        color: selected_options.contains(item)
                            ? Color(0xff2286FE)
                            : Color(0xffE0EAF6),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Text(
                      item,
                      style: TextStyle(
                          color: selected_options.contains(item)
                              ? Colors.white
                              : Color(0xff5E6D85),
                          fontSize: 14,
                          fontFamily: "Inter"),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        )
      ]),
    );
  }
}
