import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'CartController.dart';
import 'Product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Shopping Cart Management'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> products = List.generate(
      10,
      (index) => Product(
            id: index + 1,
            name: 'Product $index',
            price: index * 10,
            image: 'https://picsum.photos/id/$index/200/300',
          ));

  CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            //cart icon with stacked count
            IconButton(
              icon: Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Obx(()=>Text(
                          controller.products.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            )
          ],
        ),
        //grid view builder
        body: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Image.network(
                    product.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )),
                  Text(
                    product.name!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${product.price.toString()}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonHeight: 35,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          controller.decreaseQuantity(product);
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          child: Icon(CupertinoIcons.minus),
                        ),
                      ),
                      Obx(() => Text("${controller.getQuantity(product)}",
                          style: TextStyle(fontSize: 24))),
                      InkWell(
                        onTap: () {
                          controller.increaseQuantity(product);
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          child: Icon(CupertinoIcons.plus),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
