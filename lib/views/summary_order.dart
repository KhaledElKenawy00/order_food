import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task2/widgets/button.dart';

class OrderSummaryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;

  const OrderSummaryScreen({super.key, required this.selectedItems});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  // Group items by unique food name and sum quantity
  List<Map<String, dynamic>> get uniqueItems {
    final Map<String, Map<String, dynamic>> grouped = {};

    for (var item in widget.selectedItems) {
      final name = item['food_name'];
      if (grouped.containsKey(name)) {
        grouped[name]!['quantity'] += 1;
      } else {
        grouped[name] = {...item, 'quantity': 1};
      }
    }

    return grouped.values.toList();
  }

  double get totalPrice => uniqueItems.fold(
    0,
    (sum, item) => sum + (item['price'] * item['quantity']),
  );

  int get totalCalories => uniqueItems.fold(
    0,
    (sum, item) =>
        sum + ((item['calories'] as int) * (item['quantity'] as int)),
  );

  void addItem(Map<String, dynamic> item) {
    setState(() {
      widget.selectedItems.add({
        'food_name': item['food_name'],
        'calories': item['calories'],
        'price': item['price'],
        'image_url': item['image_url'],
      });
    });
  }

  void removeItem(Map<String, dynamic> item) {
    setState(() {
      final index = widget.selectedItems.indexWhere(
        (i) => i['food_name'] == item['food_name'],
      );
      if (index != -1) {
        widget.selectedItems.removeAt(index);
      }
    });
  }

  Future<void> placeOrder() async {
    final url = Uri.parse('https://uz8if7.buildship.run/placeOrder');

    final orderItems = uniqueItems
        .map(
          (item) => {
            "name": item['food_name'],
            "total_price": (item['price'] * item['quantity']).toInt(),
            "quantity": item['quantity'],
          },
        )
        .toList();

    final body = jsonEncode({"items": orderItems});

    try {
      var request = http.Request('POST', url);
      request.headers.addAll({'Content-Type': 'text/plain'});
      request.body = body;

      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 && responseBody.contains("true")) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order placed successfully!')),
          );
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to place order: $responseBody')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Summary"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: uniqueItems.length,
                itemBuilder: (context, index) {
                  final item = uniqueItems[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Image.network(
                        item['image_url'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.fastfood),
                      ),
                      title: Text(item['food_name']),
                      subtitle: Text(
                        '${item['calories'] * item['quantity']} cal',
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "\$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => removeItem(item),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF25700),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  item['quantity'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => addItem(item),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xffF25700),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Calories:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$totalCalories cal',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            OrangeButton(text: "Confirm", onPressed: placeOrder),
          ],
        ),
      ),
    );
  }
}
