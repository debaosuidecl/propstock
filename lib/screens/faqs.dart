import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propstock/providers/faqs.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:provider/provider.dart';

class FAQs extends StatefulWidget {
  const FAQs({super.key});
  static const id = "faqs";

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  final TextEditingController _controller = TextEditingController();
  String search = "";
  bool loading = true;
  List<dynamic> pfaqs = [];
  List<String> categories = [];
  List<String> expanded = [];
  @override
  void initState() {
    // TODO: implement initState
    _fetchFaq();
    super.initState();
  }

  Future<void> _fetchFaq() async {
    try {
      setState(() {
        loading = true;
        pfaqs = [];
      });

      final List<dynamic> faqs =
          await Provider.of<FaqsProvider>(context, listen: false)
              .fetchFaqs(search);
      // print(faqs.keys.toList());
      setState(() {
        pfaqs = faqs;
        // categories = pfaqs.keys.toList();
      });
    } catch (e) {
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // height: 30,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.2),
                      offset: Offset(0, 1),
                    )
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset("images/close_icon.svg")),
                      const Text(
                        "FAQs",
                        style: TextStyle(
                          color: Color(0xff011936),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Inter",
                        ),
                      ),
                      Image.asset("images/close_icon_white.png")
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SvgPicture.asset("images/chartb.svg"),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Color(0xffCBDFF7)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Looking for answers?",
                        style: TextStyle(
                            color: Color(0xff011936),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Inter"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Find all the answers to your question here ",
                        style: TextStyle(
                            color: Color(0xff5E6D85),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter"),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _controller,
                          // keyboardType: TextInputType.text,
                          onChanged: (String val) {
                            setState(() {
                              // firstName = val;
                              search = val;
                              _fetchFaq();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Search",

                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SvgPicture.asset(
                                "images/MagnifyingGlassb.svg",
                                height: 1,
                              ),
                            ),
                            prefixIconColor: Color(0xffB0B0B0),
                            filled: true,
                            fillColor: Color(0xffffffff),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            // label: Text('First Name'),
                            hintStyle: TextStyle(
                              color: Color(0xffB0B0B0),
                              fontSize: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffCBDFF7),
                              ), // Use the hex color
                              borderRadius: BorderRadius.circular(
                                  8), // You can adjust the border radius as needed
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffCBDFF7),
                              ), // Use the hex color
                              borderRadius: BorderRadius.circular(
                                  8), // You can adjust the border radius as needed
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                if (loading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CircularProgressIndicator(),
                  ),
                if (pfaqs.isNotEmpty)
                  Container(
                    height: MediaQuery.of(context).size.height * 1.5,
                    child: ListView.builder(
                        itemCount: pfaqs.length,
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable scrolling

                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((index == 0) ||
                                  index != 0 &&
                                      pfaqs[index]['category'] !=
                                          pfaqs[index - 1]['category'])
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 30),
                                  child: Text(
                                    pfaqs[index]['category'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      fontFamily: "Inter",
                                    ),
                                  ),
                                ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      pfaqs[index]["title"],
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        print(expanded);
                                        if (expanded
                                            .contains(pfaqs[index]["title"])) {
                                          expanded
                                              .remove(pfaqs[index]["title"]);
                                        } else {
                                          expanded.add(pfaqs[index]["title"]);
                                        }

                                        setState(() {});
                                      },
                                      child:
                                          SvgPicture.asset("images/Plus.svg"),
                                    ),
                                  )),
                              if (expanded.contains(pfaqs[index]["title"]))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    pfaqs[index]["subtitle"],
                                  ),
                                )
                            ],
                          );
                        }),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
