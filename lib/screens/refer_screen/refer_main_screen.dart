import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:order_notebook/loading_widgets/loading_widget.dart';
import 'package:order_notebook/notebook_data/order_riverpod.dart';

class ReferPage extends ConsumerStatefulWidget {
  const ReferPage({super.key});

  @override
  ConsumerState<ReferPage> createState() => _ReferPageState();
}

class _ReferPageState extends ConsumerState<ReferPage> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int totalReferal = 0;
  int orderedReferal = 0;
  bool loader = false;

  Future<void> addReferral() async {
    try {
      setState(() {
        loader = true;
      });
      final phone = phoneController.text.trim();

      if (phone.isEmpty || phone.length != 10) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter a valid phone number")),
        );
        setState(() {
          loader = false;
        });
        return;
      }

      final consumersRef = _firestore.collection("consumers");

      // 🔍 Check if phone already exists in consumers collection
      final existing = await consumersRef.doc(phone).get();

      if (existing.exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User with $phone already exists")),
        );
        setState(() {
          loader = false;
        });
        return;
      }

      final userDoc = consumersRef.doc(ref.read(consumerProvider).mobileNo);

      // ✅ Add phone under referredCustomers with hasOrdered=false
      await userDoc.set({
        "referredCustomers": {
          phone: {"hasOrdered": false},
        },
      }, SetOptions(merge: true));

      phoneController.clear();
      setState(() {
        loader = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Referred $phone successfully")));
    } catch (e) {
      setState(() {
        loader = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong !!!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Refer a Friend")),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Refer 5 Friends and get a 300 page notebook absolutely free when they make their first order',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  textAlign: TextAlign.left,
                  '(You will receive the free notebook on your next order)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 200),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FormBuilderTextField(
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.equalLength(10),
                    ]),
                    name: 'Mobile No',

                    style: Theme.of(context).textTheme.bodyMedium,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: phoneController,
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
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: addReferral,
                    icon: const Icon(Icons.send),
                    label: const Text("Add Referral"),
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection("consumers")
                        .doc(ref.read(consumerProvider).mobileNo)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const LoadingWidget();
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      final referrals =
                          data?["referredCustomers"] as Map<String, dynamic>? ??
                          {};

                      return SizedBox(
                        height: 300,
                        child: ListView(
                          children: referrals.entries.map((entry) {
                            final phone = entry.key;

                            totalReferal++;

                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("consumers")
                                  .doc(phone)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const ListTile(
                                    leading: Icon(Icons.phone),
                                    title: Text("Loading..."),
                                    trailing: CircularProgressIndicator(),
                                  );
                                }

                                bool hasOrdered = false;

                                if (snapshot.hasData && snapshot.data!.exists) {
                                  final data =
                                      snapshot.data!.data()
                                          as Map<String, dynamic>;
                                  final totalOrders =
                                      (data["totalOrders"] ?? 0) as int;
                                  hasOrdered = totalOrders > 0;
                                  if (hasOrdered) {
                                    orderedReferal++;
                                  }
                                }

                                return Column(
                                  children: [
                                    SizedBox(height: 2),
                                    ListTile(
                                      leading: const Icon(Icons.phone),
                                      title: Text(phone),
                                      trailing: Chip(
                                        label: Text(
                                          hasOrdered
                                              ? "Ordered"
                                              : "Not Ordered",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: hasOrdered
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (loader) LoadingWidget(),
      ],
    );
  }
}
