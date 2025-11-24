import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:order_notebook/loading_widgets/loading_widget.dart';
import 'package:order_notebook/map_widget/get_snapshot.dart';
import 'package:order_notebook/map_widget/map_riverpod.dart';
import 'package:order_notebook/map_widget/select_location_page.dart';
import 'package:order_notebook/methods/add_order.dart';
import 'package:order_notebook/notebook_data/consumer_data.dart';
import 'package:order_notebook/notebook_data/order_data.dart';
import 'package:order_notebook/notebook_data/order_riverpod.dart';
import 'package:order_notebook/screens/checkout_page/widgets/success_dialog.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  bool loader = false;
  final _formKey = GlobalKey<FormBuilderState>();
  // final addressLinkController = TextEditingController();
  final deliveryInstructionController = TextEditingController();
  String mapSnapshotUrl = '';
  double lat = 0.0;
  double long = 0.0;

  @override
  void initState() {
    super.initState();
    // Fetch location as soon as app starts
    Future.microtask(() async {
      try {
        await ref.read(locationProvider.notifier).fetchCurrentLocation();
      } catch (e) {
        // if (!mounted) return;
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Please Turn on your Location....')),
        // );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notebookOrders = ref.watch(selectedVariantListProvider);
    // final totalPrice = ref.watch(totalPriceProvider);
    final orderData = ref.watch(orderProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromRGBO(204, 180, 136, 1),
          appBar: AppBar(
            title: const Text("Your Cart"),
            backgroundColor: Color.fromRGBO(255, 248, 231, 1),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        // ✅ Show cart items
                        Expanded(
                          child: ListView.builder(
                            padding:
                                EdgeInsets.zero, // remove default list padding
                            itemCount: notebookOrders.length,
                            itemBuilder: (context, index) {
                              final order = notebookOrders[index];
                              return Card(
                                shape: Border.symmetric(),
                                color: const Color.fromARGB(255, 255, 239, 202),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 1,
                                ), // tighter spacing
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ), // reduced
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${order.notebookName} - ${order.notebookGrade}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: Color.fromRGBO(
                                                92,
                                                64,
                                                51,
                                                1,
                                              ),
                                            ), // slightly smaller
                                      ),
                                      const Divider(
                                        height: 2, // reduce divider height
                                        thickness: 0.8, // make it thinner
                                      ),
                                      ...order.pageQuantityMap.entries.map((
                                        entry,
                                      ) {
                                        final pages = entry.key;
                                        final quantity =
                                            entry.value["quantity"] ?? 0;
                                        final price = entry.value["price"] ?? 0;
                
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ), // reduce row spacing
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "$pages pages",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                      iconSize:
                                                          20, // smaller icons
                                                      padding: EdgeInsets.all(5),
                                                      constraints:
                                                          const BoxConstraints(), // remove min size
                                                      icon: const Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                      ),
                                                      onPressed: () {
                                                        if (quantity > 0) {
                                                          _updateQuantity(
                                                            ref,
                                                            order,
                                                            pages,
                                                            quantity - 1,
                                                            price,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    Text(
                                                      "$quantity",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    IconButton(
                                                      iconSize: 20,
                                                      padding: EdgeInsets.all(5),
                                                      constraints:
                                                          const BoxConstraints(),
                                                      icon: const Icon(
                                                        Icons.add_circle_outline,
                                                      ),
                                                      onPressed: () {
                                                        _updateQuantity(
                                                          ref,
                                                          order,
                                                          pages,
                                                          quantity + 1,
                                                          price,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "₹${quantity * price}",
                                                  textAlign: TextAlign.right,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                
                        const SizedBox(height: 12),
                
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 255, 239, 202),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                onPressed: selectMapDialog,
                                label: Text(
                                  lat == 0.0
                                      ? 'Select Delivery Location'
                                      : 'Change Location',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                icon: Icon(Icons.location_on),
                              ),
                              if (lat != 0.0)
                                GestureDetector(
                                  onTap: () {
                                    showImageDialog();
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        height: 50,
                                        width: 50,
                                        // Set your desired height
                                        decoration: BoxDecoration(
                                          // Background color if image fails to load
                                          // Optional: Rounded corners
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              getStaticMapUrl(lat, long),
                                            ),
                                            fit: BoxFit
                                                .scaleDown, // Adjust the image to cover the box
                                          ),
                                        ),
                                      ),
                                      // Icon(Icons.location_city , color: Colors.red,),
                                      Text(
                                        'See Your Location',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     showImageDialog();
                              //   },
                              //   child: Text('Show Location'),
                              // ),
                            ],
                          ),
                        ),
                
                        const SizedBox(height: 12),
                
                        // ✅ Delivery Instructions
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: FormBuilderTextField(
                            controller: deliveryInstructionController,
                            style: Theme.of(context).textTheme.bodyMedium,
                
                            name: 'delivery instruction',
                            decoration: InputDecoration(
                              fillColor: Theme.of(
                                context,
                              ).inputDecorationTheme.fillColor,
                              filled: true,
                              hint: Text(
                                'Any Delivery Instruction ?',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).hintColor, // lighter like placeholder
                                    ),
                              ),
                              border: OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(10),
                              // filled: true,
                              label: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Delivery Instruction',
                                      style: Theme.of(context).textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                              122,
                                              106,
                                              83,
                                              0.7,
                                            ), // lighter like placeholder
                                          ),
                                    ),
                                    // const TextSpan(
                                    //   text: ' *',
                                    //   style: TextStyle(color: Colors.red),
                                    // ),
                                  ],
                                ),
                              ),
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                
                        const SizedBox(height: 20),
                
                        // ✅ Total Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Total:",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                              "₹${ref.watch(totalPriceProvider)}",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                
                        const SizedBox(height: 16),
                
                        // ✅ Place Order Button
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text("Place Order"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () {
                            onSavedClicked(orderData);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                // Add some padding so it's not stuck to the edges
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    // Default style for the whole message (subtle)
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 17, // Small font size for subtlety
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: 'For any help whatsapp or call '),
                      TextSpan(
                        text: '7414040042',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        // --- Optional: Make it tappable ---
                        // recognizer: TapGestureRecognizer()
                        //   ..onTap = () {
                        //     launchUrl(Uri.parse('tel:7414040042'));
                        //   },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (loader) LoadingWidget(),
      ],
    );
  }

  // Future<String> getAddressFromLatLong(
  //     double latitude, double longitude) async {
  //   try {
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(latitude, longitude);

  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks[0];
  //       return "${place.name}, ${place.subLocality}, ${place.locality}";
  //     } else {
  //       return "No address found";
  //     }
  //   } catch (e) {
  //     return "No address found";
  //   }
  // }

  void selectMapDialog() {
    AlertDialog alert = AlertDialog(
      title: const Text("Select Location"),
      content: SelectLocationPage(onLocationSelected: onLocationSelected),
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(canPop: false, child: alert);
      },
    );
  }

  void onLocationSelected(LatLng location) async {
    setState(() {
      lat = location.latitude;
      long = location.longitude;
    });
    try {
      // final address = await getAddressFromLatLng(lat, long);
      if (!mounted) return;
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Something went wrong !!!')),
        );
    } finally {
      Navigator.of(context).pop();
    }
  }

  /// ✅ Helper: update quantity and refresh total
  void _updateQuantity(
    WidgetRef ref,
    NotebookOrder order,
    String pages,
    int newQuantity,
    int price,
  ) {
    final orders = [...ref.read(selectedVariantListProvider)];
    final index = orders.indexOf(order);

    if (index != -1) {
      final updatedPageMap = Map<String, Map<String, int>>.from(
        order.pageQuantityMap,
      );
      setState(() {
        updatedPageMap[pages] = {"quantity": newQuantity, "price": price};
      });

      orders[index] = order.copyWith(pageQuantityMap: updatedPageMap);
      ref.read(selectedVariantListProvider.notifier).state = orders;
    }

    // 🔄 Recalculate total
    _updateTotalPrice(ref);
  }

  void showImageDialog() {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // ignore: prefer_interpolation_to_compose_strings
      content: InteractiveViewer(
        panEnabled: true, // Allow panning
        boundaryMargin: EdgeInsets.all(10),
        minScale: 1.0, // Minimum zoom scale
        maxScale: 5.0,
        child: Container(
          height: 350,
          width: 350,

          // Set your desired height
          decoration: BoxDecoration(
            // Background color if image fails to load
            // Optional: Rounded corners
            image: DecorationImage(
              image: NetworkImage(getStaticMapUrl(lat, long)),
              fit: BoxFit.scaleDown, // Adjust the image to cover the box
            ),
          ),
        ),
      ),
    );

    // show the dialog
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  int getTotalSelectedQuantity() {
    final notebookOrders = ref.read(selectedVariantListProvider);
    int total = 0;

    for (final order in notebookOrders) {
      for (final pageData in order.pageQuantityMap.values) {
        total += pageData["quantity"] ?? 0;
      }
    }

    return total;
  }

  void _updateTotalPrice(WidgetRef ref) {
    final notebookOrders = ref.read(selectedVariantListProvider);
    int total = 0;

    for (final order in notebookOrders) {
      for (final pageData in order.pageQuantityMap.values) {
        final qty = pageData["quantity"] ?? 0;
        final price = pageData["price"] ?? 0;
        total += qty * price;
      }
    }

    ref.read(totalPriceProvider.notifier).state = total;
  }

  void onSavedClicked(OrderData orderData) async {
    final quantity = getTotalSelectedQuantity();
    if (quantity < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add minimum 2 quantities !!!')),
      );
      return;
    }
    if (lat == 0.0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Please select location !!!!')),
        );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        loader = true;
      });

      // Update orderProvider with final selections
      ref.read(orderProvider.notifier).state = orderData.copyWith(
        totalAmount: ref.read(totalPriceProvider),
        noteBookOrderList: ref.read(selectedVariantListProvider),
        deliveryInstruction: deliveryInstructionController.text,
        // locationLink: addressLinkController.text,
        lat: lat,
        long: long,
      );

      try {
        await saveOrder(ref.read(orderProvider));

        if (!mounted) return;
        SuccessDialog.show(
          context,
          quantity,
          ref.read(consumerProvider).totalOrders,
        );

        ref.read(orderProvider.notifier).update((_) => OrderData.empty());
        ref.read(selectedVariantListProvider.notifier).update((_) => []);
        ref.read(totalPriceProvider.notifier).update((_) => 0);
        ref.read(consumerProvider.notifier).update((_) => ConsumerData.empty());

        setState(() {
          loader = false;
        });
      } catch (e) {
        setState(() {
          loader = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something Went Wrong... Try Again later'),
          ),
        );
      }
    }
  }
}
