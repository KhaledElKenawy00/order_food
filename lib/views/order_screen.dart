import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2/views/summary_order.dart';
import 'package:task2/widgets/button.dart';
import '../provider/user_provider.dart';
import '../widgets/food_card.dart';
import '../widgets/selectable_card.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final List<Map<String, dynamic>> veggies = [
    {
      "food_name": "Broccoli",
      "calories": 55,
      "price": 5.0,
      "image_url":
          "https://cdn.britannica.com/25/78225-050-1781F6B7/broccoli-florets.jpg",
    },
    {
      "food_name": "Spinach",
      "calories": 23,
      "price": 3.0,
      "image_url":
          "https://www.daysoftheyear.com/cdn-cgi/image/dpr=1%2Cf=auto%2Cfit=cover%2Cheight=650%2Cq=40%2Csharpen=1%2Cwidth=956/wp-content/uploads/fresh-spinach-day.jpg",
    },
    {
      "food_name": "Carrot",
      "calories": 41,
      "price": 2.0,
      "image_url":
          "https://cdn11.bigcommerce.com/s-kc25pb94dz/images/stencil/1280x1280/products/271/762/Carrot__40927.1634584458.jpg?c=2",
    },
    {
      "food_name": "Bell Pepper",
      "calories": 31,
      "price": 4.0,
      "image_url":
          "https://i5.walmartimages.com/asr/5d3ca3f5-69fa-436a-8a73-ac05713d3c2c.7b334b05a184b1eafbda57c08c6b8ccf.jpeg?odnHeight=768&odnWidth=768&odnBg=FFFFFF",
    },
  ];

  final List<Map<String, dynamic>> carbs = [
    {
      "food_name": "Brown Rice",
      "calories": 111,
      "price": 8.0,
      "image_url":
          "https://assets-jpcust.jwpsrv.com/thumbnails/k98gi2ri-720.jpg",
    },
    {
      "food_name": "Oats",
      "calories": 389,
      "price": 6.0,
      "image_url":
          "https://media.post.rvohealth.io/wp-content/uploads/2020/03/oats-oatmeal-732x549-thumbnail.jpg",
    },
    {
      "food_name": "Sweet Corn",
      "calories": 86,
      "price": 4.0,
      "image_url":
          "https://m.media-amazon.com/images/I/41F62-VbHSL._AC_UF1000,1000_QL80_.jpg",
    },
    {
      "food_name": "Black Beans",
      "calories": 132,
      "price": 5.0,
      "image_url":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwxSM9Ib-aDXTUIATZlRPQ6qABkkJ0sJwDmA&usqp=CAU",
    },
  ];

  final List<Map<String, dynamic>> meats = [
    {
      "food_name": "Chicken Breast",
      "calories": 165,
      "price": 15.0,
      "image_url":
          "https://www.savorynothings.com/wp-content/uploads/2021/02/airy-fryer-chicken-breast-image-8.jpg",
    },
    {
      "food_name": "Salmon",
      "calories": 206,
      "price": 20.0,
      "image_url":
          "https://cdn.apartmenttherapy.info/image/upload/f_jpg,q_auto:eco,c_fill,g_auto,w_1500,ar_1:1/k%2F2023-04-baked-salmon-how-to%2Fbaked-salmon-step6-4792",
    },
    {
      "food_name": "Lean Beef",
      "calories": 250,
      "price": 18.0,
      "image_url":
          "https://www.mashed.com/img/gallery/the-truth-about-lean-beef/l-intro-1621886574.jpg",
    },
    {
      "food_name": "Turkey",
      "calories": 135,
      "price": 12.0,
      "image_url":
          "https://fox59.com/wp-content/uploads/sites/21/2022/11/white-meat.jpg?w=2560&h=1440&crop=1",
    },
  ];

  List<Map<String, dynamic>> selectedItems = [];
  String? selectedGender;

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
          const SizedBox(height: 10),
          // buildGenderSelector(),
          const Divider(),
          Expanded(child: buildCategory('Vegetables', veggies)),
          Expanded(child: buildCategory('Meat', meats)),
          Expanded(child: buildCategory('Carbs', carbs)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildSummaryRow(
                  '$totalCalories cal of ${caloriesNeeded.toStringAsFixed(0)}',
                  "Cal",
                ),
                buildSummaryRow(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  "Price",
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

  // Widget buildGenderSelector() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SelectableCard(
  //           text: 'Male',
  //           isSelected: selectedGender == 'Male',
  //           onTap: () {
  //             setState(() {
  //               selectedGender = 'Male';
  //             });
  //           },
  //         ),
  //         const SizedBox(width: 20),
  //         SelectableCard(
  //           text: 'Female',
  //           isSelected: selectedGender == 'Female',
  //           onTap: () {
  //             setState(() {
  //               selectedGender = 'Female';
  //             });
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  Widget buildSummaryRow(String value, String text, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 1), // No label
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
