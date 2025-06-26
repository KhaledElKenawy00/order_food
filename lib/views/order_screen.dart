import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2/views/summary_order.dart';
import 'package:task2/widgets/button.dart';
import '../provider/user_provider.dart';
import '../widgets/food_card.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final List<Map<String, dynamic>> veggies = [/* same as your data */];
  final List<Map<String, dynamic>> carbs = [/* same as your data */];
  final List<Map<String, dynamic>> meats = [/* same as your data */];

  List<Map<String, dynamic>> selectedItems = [];

  int get totalCalories => selectedItems.fold<int>(
    0,
    (sum, item) => sum + (item['calories'] as int),
  );

  double get totalPrice =>
      selectedItems.fold<double>(0, (sum, item) => sum + (item['price']));

  int itemQuantity(Map<String, dynamic> item) {
    return selectedItems
        .where((i) => i['food_name'] == item['food_name'])
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final caloriesNeeded = Provider.of<UserProvider>(context).calories ?? 0;
    final lowerLimit = caloriesNeeded * 0.9;
    final upperLimit = caloriesNeeded * 1.1;

    final isOrderAllowed =
        totalCalories >= lowerLimit && totalCalories <= upperLimit;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Your Order'), centerTitle: true),
      body: Column(
        children: [
          const Divider(),
          Expanded(child: buildCategory('Vegetables', veggies)),
          Expanded(child: buildCategory('Meat', meats)),
          Expanded(child: buildCategory('Carbs', carbs)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildSummaryRow(
                  "Calories",
                  '$totalCalories cal out of ${caloriesNeeded.toStringAsFixed(0)}',
                ),
                buildSummaryRow(
                  "Price",
                  '\$${totalPrice.toStringAsFixed(2)}',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: OrangeButton(
              text: "Place Order",
              onPressed: isOrderAllowed
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderSummaryScreen(selectedItems: selectedItems),
                        ),
                      );
                    }
                  : null,
              enabled: isOrderAllowed,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategory(String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final quantity = itemQuantity(item);

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: FoodCard(
                  item: item,
                  quantity: quantity,
                  onAdd: () {
                    setState(() {
                      selectedItems.add(Map.from(item));
                    });
                  },
                  onRemove: () {
                    setState(() {
                      final index = selectedItems.indexWhere(
                        (i) => i['food_name'] == item['food_name'],
                      );
                      if (index != -1) selectedItems.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildSummaryRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
