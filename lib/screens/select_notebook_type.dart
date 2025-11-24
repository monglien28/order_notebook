import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:order_notebook/loading_widgets/loading_widget.dart';
import 'package:order_notebook/main.dart';
import 'package:order_notebook/map_widget/map_riverpod.dart';
import 'package:order_notebook/methods/get_notebook_variant_list.dart';
import 'package:order_notebook/notebook_data/notebook_variant.dart';
import 'package:order_notebook/notebook_data/order_riverpod.dart';
import 'package:order_notebook/screens/refer_screen/refer_main_screen.dart';
import 'package:order_notebook/screens/show_notebook_variant.dart';
import 'package:order_notebook/screens/show_orders/show_order_screen.dart';

class SelectNotebookType extends ConsumerStatefulWidget {
  const SelectNotebookType({super.key, required this.notebookType});
  final List<String> notebookType;

  @override
  ConsumerState<SelectNotebookType> createState() => _SelectNotebookTypeState();
}

class _SelectNotebookTypeState extends ConsumerState<SelectNotebookType> {
  List<String> noteBookType = [];
  bool loader = false;

  @override
  void initState() {
    super.initState();
    // Fetch location as soon as app starts
    Future.microtask(() async {
      try {
        await ref.read(locationProvider.notifier).fetchCurrentLocation();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Turn on your Location....')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            actions: [
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromRGBO(204, 180, 136, 1),
                  ),
                ),
                label: Text('Track Your Orders'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppContainer(
                        child: OrdersPage(
                          mobileNo: ref.read(orderProvider).mobileNo,
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.menu_book),
              ),
            ],
            title: Text('Hello ${ref.read(consumerProvider).name}'),
          ),
          backgroundColor: const Color.fromRGBO(204, 180, 136, 1),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Refer 5 friends and get a 300 pages notebook for FREE ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text("Refer Now ( GET FREE NOTEBOOK)"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AppContainer(child: ReferPage()),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 50),
                    Card(
                      color: const Color.fromARGB(255, 156, 127, 70),
                      elevation: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 239, 202),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 40,
                            ),
                            child: FormBuilderCheckboxGroup<String>(
                              onChanged: (value) {
                                if (value != null) {
                                  noteBookType.addAll(value);
                                }
                              },
                              wrapCrossAxisAlignment: WrapCrossAlignment.center,
                              wrapAlignment: WrapAlignment.start,
                              orientation: OptionsOrientation
                                  .vertical, // 👈 makes it vertical
                              wrapDirection: Axis.vertical,
                              name: 'notebook_type', // field name
                              decoration: InputDecoration(
                                fillColor: const Color.fromRGBO(
                                  204,
                                  180,
                                  136,
                                  1,
                                ),
                                label: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      156,
                                      127,
                                      70,
                                    ),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Text(
                                    "Select Notebook Type",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(92, 64, 51, 1),
                                        ),
                                  ),
                                ),
                              ),
                              options: widget.notebookType
                                  .map(
                                    (type) => FormBuilderFieldOption(
                                      value: type,
                                      child: Container(
                                        // ⬇️ FIXED: Removed conditional logic and applied a uniform vertical margin
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),

                                        // ℹ️ NOTE: Your original padding logic was setting it to 0
                                        // for all items, so I've removed it for clarity.
                                        // You can add uniform padding here if you need it, e.g.:
                                        // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          type,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                  88,
                                                  75,
                                                  58,
                                                  1,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(), // ⬅️ Make sure to add .toList() at the end of your .map,

                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText:
                                      "Please select at least one notebook type !!!",
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: onNextClicked,
                            child: Text('Next'),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
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

  void onNextClicked() async {
    try {
      setState(() {
        loader = true;
      });
      if (noteBookType.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select atleast one type')),
        );
        setState(() {
          loader = false;
        });

        return;
      }
      Map<String, List<NotebookVariant>> notebookVariantMap = {};

      for (String a in noteBookType) {
        final list = await getVariantsByTypeName(a);
        notebookVariantMap[a] = list;
      }

      if (notebookVariantMap.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select atleast one type')),
        );
        setState(() {
          loader = false;
        });
        return;
      } else {
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => AppContainer(
              child: ShowNotebookVariant(
                notebookVariantMap: notebookVariantMap,
              ),
            ),
          ),
          (_) => false,
        );
      }
      setState(() {
        loader = false;
      });
    } catch (e) {
      setState(() {
        loader = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong !!!')));
    }
  }
}
