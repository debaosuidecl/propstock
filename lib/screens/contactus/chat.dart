import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propstock/models/colors.dart';
import 'package:propstock/models/contact_chat_message.dart';
import 'package:propstock/models/user.dart';
import 'package:propstock/providers/auth.dart';
import 'package:propstock/providers/contact.dart';
import 'package:propstock/utils/showErrorDialog.dart';
import 'package:propstock/widgets/propstock_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:math';
import 'dart:convert';

class ChatContactUs extends StatefulWidget {
  const ChatContactUs({super.key});
  static const id = "contact_us_chat";

  @override
  State<ChatContactUs> createState() => _ChatContactUsState();
}

class _ChatContactUsState extends State<ChatContactUs> {
  bool loading = true;
  bool fetchedMessage = false;
  late IO.Socket socket;
  int page = 1;
  String message = "";
  TextEditingController _controller = TextEditingController();

  bool _isMounted = false;

  User? customerService;

  List<ContactChatMessage> messages = [];

  @override
  void initState() {
    _isMounted = true;

    super.initState();
    connectToServer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isMounted = false; // Set the flag to false when disposing the widget
    _controller.dispose();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  Future<String> gettoken() async {
    String token = "";

    try {
      final prefs = await SharedPreferences.getInstance();

      // return true;
      if (!prefs.containsKey('userData')) {
        throw "no user data";
      }
      final extractedUserData =
          json.decode(prefs.getString('userData') as String)
              as Map<String, dynamic>;

      token = extractedUserData['token'] as String;
    } catch (e) {
      print(e);
    }
    return token;
  }

  void connectToServer() async {
    final token = await gettoken();
    print("connecting to server");
    print(token);
    // socket = IO.io(
    //   'https://jawfish-good-lioness.ngrok-free.app',
    //   IO.OptionBuilder()
    //       .setTransports(['websocket'])
    //       .enableAutoConnect()
    //       // .setPath("blahblahblah")
    //       .setAuth({
    //         'token': token,
    //       })
    //       .setQuery({
    //         'token': token,
    //       })
    //       .build(),
    // );
    socket = IO.io(
        'https://jawfish-good-lioness.ngrok-free.app?token=$token',
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': true,
          // "token": token,
          'query': 'token=$token',
          // "auth": token,
        });
    print("ran connect");
    socket.connect();

    print("waiting for connect to happen");

    socket.on("error", (data) {
      print(data);
      print("error in connection");
    });

    socket.onConnect((_) async {
      print('Connected to server');
      print("join me");
      socket.emit(
          "join_contact_room",
          json.encode({
            "enquirer_id": Provider.of<Auth>(context, listen: false).userId
          }));

      if (_isMounted) {
        socket.on("error_joining_contact_room", (data) {
          print("error happened");
          print(data);
          if (_isMounted) {
            showErrorDialog(data, context);
          }
        });
        socket.on("error_sending_message", (data) {
          print("error happened");
          print(data);
          if (_isMounted) {
            showErrorDialog(data, context);
          }
        });
        socket.on("message_received_by_room", (data) {
          print(data);
          print("message received by room");
          if (data['sentBy']?['_id'] ==
              Provider.of<Auth>(context, listen: false).userId) {
            return print("this is the same user");
          }
          ContactChatMessage newMessage = ContactChatMessage(
            room_id: data["room_id"],
            sentBy: data['sentBy']?['firstName'] != null
                ? User(
                    id: data['sentBy']?['_id'],
                    firstName: data['sentBy']?['firstName'],
                    lastName: data['sentBy']?['lastName'],
                    avatar: data['sentBy']?['avatar'],
                    userName: data['sentBy']?['email'])
                : User(
                    userName: data['sentBy']?['email'],
                    id: "f",
                    firstName: "Deleted",
                    lastName: "User",
                    avatar:
                        "https://xsgames.co/randomusers/assets/avatars/male/46.jpg"),
            message: data["message"],
            date: DateTime.now().millisecondsSinceEpoch,
            sent: true,
            encryptedId: data["room_id"],
          );

          messages.insert(0, newMessage);
          setState(() {});
        });
        socket.on("send_success", (data) {
          print(data);
          print('the encyrpted: ${data["encryptedId"]}');
          print("received sent notifcation");

          if (_isMounted) {
            int index = messages.indexWhere(
                (element) => element.encryptedId == data["encryptedId"]);

            print("index: $index ewo");
            // messages[]  = ContactChatMessage(room_id: data["room_id"], sentBy: , message: message, date: date, sent: sent)
            // if (index != -1) {
            // Update the name of the item at the found index
            print("SET SENT TO TRUE");
            // print(messages[index]);

            print(messages[index].sent);
            setState(() {
              messages[index].sent = true;
            });
            print("it's time to set state before ooo");
            print(messages[index].sent);
          }

          // return myindex;
        });
      }

      if (_isMounted && fetchedMessage == false) {
        _fetchMessages();
      }
    });
  }

  String generateRandomString(int length) {
    const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return String.fromCharCodes(List.generate(
        length, (_) => charset.codeUnitAt(random.nextInt(charset.length))));
  }

  Future<void> _sendMessage() async {
    User sentBy = User(
      firstName: Provider.of<Auth>(context, listen: false).firstname.toString(),
      lastName: Provider.of<Auth>(context, listen: false).lastname.toString(),
      userName: Provider.of<Auth>(context, listen: false).email.toString(),
      id: Provider.of<Auth>(context, listen: false).userId.toString(),
    );
    final String encryptedId = generateRandomString(30);
    ContactChatMessage newMessage = ContactChatMessage(
        room_id: "${customerService!.id}-roomid-${sentBy.id}",
        sentBy: sentBy,
        message: message,
        date: DateTime.now().millisecondsSinceEpoch,
        sent: false,
        encryptedId: encryptedId);
    messages.insert(0, newMessage);

    setState(() {});

    try {
      // await Provider.of<ContactProvider>(context, listen: false)
      //     .sendMessage(newMessage);

      if (!socket.connected) {
        return showErrorDialog(
            "You have lost your connection to the room. Please leave and enter the page again",
            context);
      }
      socket.emit(
          "message_contact_room",
          json.encode({
            "enquirer_id": sentBy.id,
            "room": newMessage.room_id,
            "encryptedId": encryptedId,
            "message": newMessage.message,
            "sender_id": sentBy.id,
          }));
    } catch (e) {
      showErrorDialog(e.toString(), context);
    }
  }

  Future<void> _fetchMessages() async {
    try {
      dynamic messageObj =
          await Provider.of<ContactProvider>(context, listen: false)
              .getMessages(page);

      print(messageObj);

      setState(() {
        customerService = messageObj["customer_service"];
        messages = messageObj["messages"];
        fetchedMessage = true;
      });

      // print("This is the avatar: ${customerService!.avatar}");
    } catch (e) {
      if (_isMounted) {
        showErrorDialog(e.toString(), context);
      }
      showErrorDialog(e.toString(), context);
    } finally {
      if (_isMounted) {
        // Check if the widget is mounted before calling setState()

        setState(() {
          loading = false;
        });
      }
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
            child: Container(
              height: MediaQuery.of(context).size.height * .9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 69,
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SvgPicture.asset("images/mdi_close.svg"),
                            )),
                        Text(
                          "Leave us a message",
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Color(0xffffffff)),
                        ),
                        Text("")
                      ],
                    ),
                  ),
                  if (loading)
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ],
                    ),
                  if (customerService != null && !loading)
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            "${customerService!.firstName} ${customerService!.lastName}",
                            style: const TextStyle(
                              color: Color(0xff1D3354),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text("Online"),
                          leading: CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  NetworkImage("${customerService!.avatar}")
                              // height: 48,
                              ),
                        ),
                        Divider(
                          color: Color(
                              0xffeeeeee), // Customize the color of the divider
                          thickness: 1, // Adjust the thickness of the divider
                          height: 20, // Adjust the height of the divider
                        ),
                      ],
                    ),
                  if (!loading && messages.isEmpty)
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info,
                          color: Color(0xffeeeeee),
                          size: 84,
                        ),
                        // if ()
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Send us an enquiry!",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // if(messages.isEmpty)
                      ],
                    )),
                  if (!loading && messages.isNotEmpty)
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (ctx, index) {
                              ContactChatMessage contactChatMessage =
                                  messages[index];

                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      contactChatMessage.sentBy.id ==
                                              customerService?.id
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (contactChatMessage.sentBy.id ==
                                        customerService?.id)
                                      Container(
                                        height: 32,
                                        width: 32,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: Image.network(
                                            "${customerService?.avatar}"),
                                      ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 16),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: contactChatMessage
                                                        .sentBy.id !=
                                                    customerService?.id
                                                ? Color(0xff2286FE)
                                                    .withOpacity(.2)
                                                : Color(0xffEBEDF0),
                                            borderRadius:
                                                contactChatMessage.sentBy.id !=
                                                        customerService?.id
                                                    ? BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                      )
                                                    : BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(20),
                                                      )),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              contactChatMessage.message,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                                color: MyColors.neutralblack,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                if (contactChatMessage.sent)
                                                  SvgPicture.asset(
                                                      "images/Union.svg"),
                                                if (!contactChatMessage.sent)
                                                  Icon(
                                                    Icons.timer_sharp,
                                                    size: 15,
                                                    color: MyColors.neutralGrey,
                                                  )
                                              ],
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              );
                              // return ListTile(
                              //   title: Text(contactChatMessage.message),
                              //   trailing: Text(contactChatMessage.sent
                              //       ? "Sent"
                              //       : "Processing"),
                              // );
                            })),
                  if (!loading)
                    // chat box
                    Column(
                      children: [
                        Divider(
                          color: Color(
                              0xffeeeeee), // Customize the color of the divider
                          thickness: 1, // Adjust the thickness of the divider
                          height: 20, // Adjust the height of the divider
                        ),
                      ],
                    ),
                  if (!loading)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              // padding: const EdgeInsets.symmetric(horizontal: 20),
                              // width: MediaQuery.of(context).size.width,
                              child: TextField(
                                controller: _controller,
                                // keyboardType: TextInputType.text,
                                onChanged: (String val) {
                                  setState(() {
                                    message = val;
                                    // search = val;
                                    // _fetchFaq();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Type your message",

                                  // prefixIcon: Padding(
                                  //   padding: const EdgeInsets.all(15.0),
                                  //   child: SvgPicture.asset(
                                  //     "images/MagnifyingGlassb.svg",
                                  //     height: 1,
                                  //   ),
                                  // ),
                                  prefixIconColor: Color(0xffB0B0B0),
                                  filled: true,
                                  fillColor: Color(0xffffffff),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  // label: Text('First Name'),
                                  hintStyle: TextStyle(
                                    color: Color(0xffB0B0B0),
                                    fontSize: 14,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffEBEDF0),
                                    ), // Use the hex color
                                    borderRadius: BorderRadius.circular(
                                        20), // You can adjust the border radius as needed
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffEBEDF0),
                                    ), // Use the hex color
                                    borderRadius: BorderRadius.circular(
                                        20), // You can adjust the border radius as needed
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              // send message
                              print("sending messsage");
                              _controller.clear();
                              _sendMessage();
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.primary,
                              ),
                              child: SvgPicture.asset("images/send.svg"),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
