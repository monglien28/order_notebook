import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:order_notebook/loading_widgets/loading_widget.dart';
import 'package:order_notebook/main.dart';
import 'package:order_notebook/notebook_data/consumer_data.dart';
import 'package:order_notebook/notebook_data/order_riverpod.dart';
import 'package:order_notebook/utilities/make_text_upper_case.dart';
import 'package:order_notebook/methods/add_consumer.dart';
import 'package:order_notebook/methods/retrieve_notebook_type.dart';
import 'select_notebook_type.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool isConsumerExist = true;
  // late FocusNode mobileFocusNode;
  final mobileNoController = TextEditingController();
  final nameController = TextEditingController();

  bool loader = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Card(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    height: 400,
                    width: double.maxFinite,
                    filterQuality: FilterQuality.medium,
                    "assets/images/logo.jpeg",
                    fit: BoxFit
                        .contain, // Ensure the image covers the entire space
                    color: const Color.fromARGB(
                      255,
                      236,
                      236,
                      236,
                    ).withValues(alpha: 0.7), // Adjust opacity
                    colorBlendMode: BlendMode.dstATop,
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: FormBuilderTextField(
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.equalLength(10),
                      ]),
                      name: 'Mobile No',
                      onChanged: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length == 10) {
                          Future.delayed(Duration(milliseconds: 100), () {
                            if (_formKey.currentState?.validate() ?? false) {
                              onNextClicked();
                            }
                          });
                        }
                      },

                      style: Theme.of(context).textTheme.bodyMedium,
                      // focusNode: mobileFocusNode,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: mobileNoController,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        fillColor: Theme.of(
                          context,
                        ).inputDecorationTheme.fillColor,
                        // filled: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(19)),
                        ),
                        errorBorder: OutlineInputBorder(),
                        label: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Enter Mobile No.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).hintColor, // lighter like placeholder
                                    ),
                              ),
                              const TextSpan(
                                text: ' *',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (!isConsumerExist)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: FormBuilderTextField(
                        name: 'Name',
                        style: Theme.of(context).textTheme.bodyMedium,
                        validator: FormBuilderValidators.required(),
                        controller: nameController,
                        inputFormatters: [
                          UppercaseTextInputFormatter(),
                          LengthLimitingTextInputFormatter(50),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                        decoration: InputDecoration(
                          fillColor: Theme.of(
                            context,
                          ).inputDecorationTheme.fillColor,
                          filled: true,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(),
                          label: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Enter Your Name',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).hintColor, // lighter like placeholder
                                      ),
                                ),
                                const TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 100), () {
                        if (_formKey.currentState?.validate() ?? false) {
                          onNextClicked();
                        }
                      });
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (loader) LoadingWidget(),
      ],
    );
  }

  void onNextClicked() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          loader = true;
        });
        final personExist = await checkConsumerExist(mobileNoController.text);
        final String personName = personExist['name'] ?? '';
        final int totalOrders = personExist['totalOrders'] ?? 0;

        if (personName.isNotEmpty) {
          // final entry = personExist.entries.first;
          // nameController.text = personName;

          ref.read(orderProvider.notifier).state.consumerName = personName;

          ref.read(orderProvider.notifier).state.mobileNo =
              mobileNoController.text;

          ref.read(consumerProvider.notifier).update((order) {
            return ConsumerData(
              mobileNo: mobileNoController.text,
              name: personName,
              totalOrders: totalOrders,
            );
          });
        }

        if (personName.isEmpty && nameController.text.isEmpty) {
          setState(() {
            isConsumerExist = false;
          });
          setState(() {
            loader = false;
          });
          return;
        } else if (personName.isEmpty && nameController.text.isNotEmpty) {
          ref.read(orderProvider.notifier).state.consumerName =
              nameController.text;
          ref.read(orderProvider.notifier).state.mobileNo =
              mobileNoController.text;

          ref.read(consumerProvider.notifier).update((order) {
            return ConsumerData(
              mobileNo: mobileNoController.text,
              name: nameController.text,
              totalOrders: totalOrders,
            );
          });
          await addConsumer(
            nameController.text.trim(),
            mobileNoController.text.trim(),
            totalOrders,

            // addressLinkController.text,
          );
          // setState(() {
          //   isConsumerExist = false;
          // });
        }

        final list = await getNotebookTypes();
        if (!mounted) return;

        // nameController.text = personExist.entries.first.key;
        // notebookCount = personExist.entries.first.value;

        // ref.read(orderProvider.notifier).state.consumerName =
        //     nameController.text;
        // ref.read(orderProvider.notifier).state.mobileNo =
        //     mobileNoController.text;
        setState(() {
          loader = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AppContainer(child: SelectNotebookType(notebookType: list)),
          ),
          (_) => false,
        );
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar
        ..showSnackBar(SnackBar(content: Text('Something went wrong !!!')));
    }
  }
}
