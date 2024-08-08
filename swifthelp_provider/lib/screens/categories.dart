import 'package:flutter/material.dart';
import 'package:swifthelp_provider/consts/constants.dart';
import 'package:swifthelp_provider/services/utils.dart';
import 'package:swifthelp_provider/widgets/buttons.dart';
import 'package:swifthelp_provider/widgets/text_widget.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/DashboardScreen';
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, String>> _acceptedItems = [];
  final List<Map<String, String>> _rejectedItems = [];
  final List<Map<String, String>> _finishedItems = [];

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextWidget(
                text: 'SwiftHelp Provider Panel',
                textSize: 30,
                color: Colors.red),
            const SizedBox(height: 15),
            TextWidget(
                text: 'View Your Orders',
                textSize: 20,
                color: Color.fromARGB(255, 15, 98, 131)),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ButtonsWidget(
                      onPressed: () {},
                      text: 'View All',
                      icon: Icons.view_agenda,
                      backgroundColor: Colors.blue),
                ],
              ),
            ),
            ..._buildOrderCards(),
            const SizedBox(height: 20),
            TextWidget(
                text: 'Accepted Services:',
                textSize: 18,
                color: Colors.green),
            ..._acceptedItems.map((item) => _buildOrderCard(
              image: item['image']!,
              title: item['title']!,
              by: item['by']!,
              date: item['date']!,
              color: color,
              showFinishButton: true,
              itemId: item['id']!,
            )),
            const SizedBox(height: 20),
            TextWidget(
                text: 'Rejected Services:',
                textSize: 18,
                color: Colors.red),
            ..._rejectedItems.map((item) => _buildOrderCard(
              image: item['image']!,
              title: item['title']!,
              by: item['by']!,
              date: item['date']!,
              color: color,
              showFinishButton: false,
              itemId: item['id']!,
            )),
            const SizedBox(height: 20),
            TextWidget(
                text: 'Finished Services:',
                textSize: 18,
                color: Colors.blue),
            ..._finishedItems.map((item) => _buildOrderCard(
              image: item['image']!,
              title: item['title']!,
              by: item['by']!,
              date: item['date']!,
              color: color,
              showFinishButton: false,
              itemId: item['id']!,
            )),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOrderCards() {
    final orders = [
      {'id': '1', 'image': 'assets/images/cooking.jpg', 'title': 'Cooker 3 DAYS For Rs.10 000', 'by': 'Ishini De Silva', 'date': '27/07/2024'},
      {'id': '2', 'image': 'assets/images/rfclean.jpg', 'title': 'Roof Clean 3 Hours For Rs.2000', 'by': 'Nathasha Varshani', 'date': '26/07/2024'},
      {'id': '3', 'image': 'assets/images/gardnings.jpg', 'title': 'Gardning 2 DAYS For Rs.5000', 'by': 'Pasindu Bishan', 'date': '27/07/2024'},
    ];

    return orders.map((order) {
      final itemId = order['id'] as String;
      final isAccepted = _acceptedItems.any((item) => item['id'] == itemId);
      final isRejected = _rejectedItems.any((item) => item['id'] == itemId);
      final isFinished = _finishedItems.any((item) => item['id'] == itemId);

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Visibility(
          visible: !(isAccepted || isRejected || isFinished),
          child: Material(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).cardColor.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: MediaQuery.of(context).size.width < 650 ? 3 : 1,
                    child: Image.asset(
                      order['image'] as String,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: order['title'] as String,
                          color: Utils(context).color,
                          textSize: 16,
                          isTitle: true,
                        ),
                        FittedBox(
                          child: Row(
                            children: [
                              TextWidget(
                                text: 'By',
                                color: Colors.blue,
                                textSize: 16,
                                isTitle: true,
                              ),
                              Text('  ${order['by'] as String}')
                            ],
                          ),
                        ),
                        Text(order['date'] as String),
                        const SizedBox(height: 10),
                        if (!isAccepted && !isRejected && !isFinished) ...[
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _acceptedItems.add({
                                      'id': itemId,
                                      'image': order['image']!,
                                      'title': order['title']!,
                                      'by': order['by']!,
                                      'date': order['date']!,
                                    });
                                  });
                                },
                                child: const Text('Accept'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _rejectedItems.add({
                                      'id': itemId,
                                      'image': order['image']!,
                                      'title': order['title']!,
                                      'by': order['by']!,
                                      'date': order['date']!,
                                    });
                                  });
                                },
                                child: const Text('Reject'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ] else if (isAccepted && !isFinished) ...[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _finishedItems.add({
                                  'id': itemId,
                                  'image': order['image']!,
                                  'title': order['title']!,
                                  'by': order['by']!,
                                  'date': order['date']!,
                                });
                                _acceptedItems.removeWhere((item) => item['id'] == itemId);
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FinishedJobsScreen(
                                    finishedItems: _finishedItems,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Finished'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildOrderCard({
    required String image,
    required String title,
    required String by,
    required String date,
    required Color color,
    required bool showFinishButton,
    required String itemId,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: MediaQuery.of(context).size.width < 650 ? 3 : 1,
                child: Image.asset(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: title,
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'By',
                            color: Colors.blue,
                            textSize: 16,
                            isTitle: true,
                          ),
                          Text('  $by')
                        ],
                      ),
                    ),
                    Text(date),
                    const SizedBox(height: 10),
                    if (showFinishButton) ...[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _finishedItems.add({
                              'id': itemId,
                              'image': image,
                              'title': title,
                              'by': by,
                              'date': date,
                            });
                            _acceptedItems.removeWhere((item) => item['id'] == itemId);
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FinishedJobsScreen(
                                finishedItems: _finishedItems,
                              ),
                            ),
                          );
                        },
                        child: const Text('Finished'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Finished Jobs Screen
class FinishedJobsScreen extends StatelessWidget {
  final List<Map<String, String>> finishedItems;

  const FinishedJobsScreen({Key? key, required this.finishedItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finished Jobs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: finishedItems.map((item) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).cardColor.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: MediaQuery.of(context).size.width < 650 ? 3 : 1,
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: item['title']!,
                              color: Colors.black,
                              textSize: 16,
                              isTitle: true,
                            ),
                            FittedBox(
                              child: Row(
                                children: [
                                  TextWidget(
                                    text: 'By',
                                    color: Colors.blue,
                                    textSize: 16,
                                    isTitle: true,
                                  ),
                                  Text('  ${item['by']!}')
                                ],
                              ),
                            ),
                            Text(item['date']!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}