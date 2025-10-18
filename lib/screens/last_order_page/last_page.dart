import 'package:flutter/material.dart';
import 'package:order_notebook/main.dart';
import 'package:order_notebook/screens/welcome_screen.dart';

class LastPage extends StatelessWidget {
  const LastPage({
    super.key,
    required this.currentOrderCount,
    required this.totalCount,
  });
  final int currentOrderCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    String count10Message = '';

    if ((totalCount % 10 + currentOrderCount) >= 10) {
      count10Message = 'You are eligible for a free 300 page notebook 🎉';
    } else {
      count10Message =
          'You are just ${10 - ((currentOrderCount + totalCount) % 10)} notebooks order away to get a 300 page notebook for FREE 🎁';
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Order Placed successfully ☑️')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Column(
                children: [
                  if (currentOrderCount >= 5)
                    Text(
                      'You are eligible for a free 100 page notebook 🎉',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  SizedBox(height: 10),
                  Text(
                    count10Message,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Flexible(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Go to Homepage"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => AppContainer(child: WelcomeScreen()),
                    ),
                    (_) => false,
                  );
                },
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  Text(
                    '✔️ Order 5 notebooks in a single order and get a 100 pages notebook free. 🎁',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '✔️ Order 10 notebooks in a year and get a 300 pages notebook free. 🎁',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
