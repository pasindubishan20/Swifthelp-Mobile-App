import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swifthelp_admin_panel/services/utils.dart';
import 'text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({
    Key? key,
    required this.price,
    required this.totalPrice,
    required this.productId,
    required this.userId,
    required this.imageUrl,
    required this.userName,
    required this.quantity,
    required this.orderDate,
  }) : super(key: key);

  final double price, totalPrice;
  final String productId, userId, imageUrl, userName;
  final int quantity;
  final Timestamp orderDate;

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  String selectedDateTimeStr = 'Fetching date...'; // Default value

  @override
  void initState() {
    super.initState();
    _fetchSelectedDateTime();
  }

  Future<void> _fetchSelectedDateTime() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('productSelections')
          .where('productId', isEqualTo: widget.productId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        Timestamp timestamp = data['selectedDateTime'];
        DateTime selectedDateTime = timestamp.toDate();
        setState(() {
          selectedDateTimeStr = '${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} ${selectedDateTime.hour}:${selectedDateTime.minute}';
        });
      } else {
        setState(() {
          selectedDateTimeStr = 'Date not available';
        });
      }
    } catch (e) {
      print('Error fetching selected DateTime: $e');
      setState(() {
        selectedDateTimeStr = 'Error fetching date';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: '${widget.quantity}X For Rs.${widget.price.toStringAsFixed(2)}',
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
                          Text('  ${widget.userName}'),
                        ],
                      ),
                    ),
                    Text(selectedDateTimeStr), // Displaying the selected DateTime
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
