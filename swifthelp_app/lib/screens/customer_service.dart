import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package
import '../widgets/dialogflow_service.dart'; // Adjust path if necessary

class CustomerServiceScreen extends StatefulWidget {
  static const routeName = '/CustomerServiceScreen';

  const CustomerServiceScreen({Key? key}) : super(key: key);

  @override
  _CustomerServiceScreenState createState() => _CustomerServiceScreenState();
}

class _CustomerServiceScreenState extends State<CustomerServiceScreen> {
  final messageController = TextEditingController();
  late final DialogflowService dialogflowService;
  List<Map<String, String>> messages = [];
  final String sessionId = Uuid().v4(); // Generate a unique session ID

  @override
  void initState() {
    super.initState();
    dialogflowService = DialogflowService(
      '', // Replace with your Dialogflow project ID
      sessionId,         // Use the generated session ID
    );
  }

  Widget buildMessageTile(String message, bool isUserMessage) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUserMessage ? Colors.blueAccent : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isUserMessage ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SwiftHelp Agent"),
        backgroundColor: Color.fromARGB(255, 95, 243, 243),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                "Today, ${DateFormat("Hm").format(DateTime.now())}",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final messageData = messages[index];
                final message = messageData['message']!;
                final isUserMessage = messageData['sender'] == 'User';
                return buildMessageTile(message, isUserMessage);
              },
            ),
          ),
          Divider(
            height: 5,
            color: Colors.greenAccent,
          ),
          Container(
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 95, 243, 243),
                  size: 35,
                ),
                onPressed: () {
                  // Add camera functionality if needed
                },
              ),
              title: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color.fromRGBO(220, 220, 220, 1),
                ),
                padding: EdgeInsets.only(left: 15),
                child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "How can we help you today?",
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.send,
                  size: 30,
                  color: Color.fromARGB(255, 95, 243, 243),
                ),
                onPressed: () async {
                  if (messageController.text.isEmpty) {
                    print("Empty message");
                  } else {
                    final userMessage = messageController.text;
                    setState(() {
                      messages.insert(0, {'message': userMessage, 'sender': 'User'});
                      messageController.clear();
                    });
                    try {
                      final botReply = await dialogflowService.sendMessage(userMessage);
                      setState(() {
                        messages.insert(0, {'message': botReply, 'sender': 'Bot'});
                      });
                    } catch (e) {
                      setState(() {
                        messages.insert(0, {'message': 'Sorry, something went wrong.', 'sender': 'Bot'});
                      });
                      print('Error: $e');
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
