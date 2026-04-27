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
import 'package:order_notebook/widgets/app_download_card.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox.shrink(), // Top spacer for centering
                            Card(
                              margin: const EdgeInsets.symmetric(horizontal: 20.0),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: FormBuilder(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                        'https://res.cloudinary.com/dsrfkeh1v/image/upload/v1761938027/logo_iu6voj.jpg',
                                        height: screenHeight * 0.35 > 350 ? 350 : screenHeight * 0.35,
                                        width: double.maxFinite,
                                        filterQuality: FilterQuality.medium,
                                        fit: BoxFit.contain, // Ensure the image covers the entire space
                                        color: const Color.fromARGB(
                                          255,
                                          236,
                                          236,
                                          236,
                                        ).withValues(alpha: 0.7), // Adjust opacity
                                        colorBlendMode: BlendMode.dstATop,
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                          FormBuilderValidators.equalLength(10),
                                        ]),
                                        onChanged: (value) {
                                          if (value.isNotEmpty && value.length == 10) {
                                            Future.delayed(const Duration(milliseconds: 100), () {
                                              if (_formKey.currentState?.validate() ?? false) {
                                                onNextClicked();
                                              }
                                            });
                                          }
                                        },
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        controller: mobileNoController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                          contentPadding: const EdgeInsets.all(15),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(19),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(19),
                                          ),
                                          label: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Enter Mobile No.',
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).hintColor,
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: ' *',
                                                  style:  TextStyle(color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ),
                                          labelStyle: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      if (!isConsumerExist)
                                        TextFormField(
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          validator: FormBuilderValidators.required(),
                                          controller: nameController,
                                          inputFormatters: [
                                            UppercaseTextInputFormatter(),
                                            LengthLimitingTextInputFormatter(50),
                                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                          ],
                                          decoration: InputDecoration(
                                            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                            filled: true,
                                            contentPadding: const EdgeInsets.all(15),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(19),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(19),
                                            ),
                                            label: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Enter Your Name',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).hintColor,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: ' *',
                                                    style:  TextStyle(color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            labelStyle: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ),
                                      if (!isConsumerExist) const SizedBox(height: 15),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(double.infinity, 50), // Full width button
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                        onPressed: () {
                                          Future.delayed(const Duration(milliseconds: 100), () {
                                            if (_formKey.currentState?.validate() ?? false) {
                                              onNextClicked();
                                            }
                                          });
                                        },
                                        child: const Text(
                                          'Next',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const AppDownloadCard(),
                            Container(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 16.0, right: 16.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 17,
                                  ),
                                  children: const <TextSpan>[
                                    TextSpan(text: 'For any help whatsapp or call '),
                                    TextSpan(
                                      text: '7414040042',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
