import 'package:flutter/material.dart';
import 'animated_widgets.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInWidget(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SlideInWidget(
              delay: const Duration(milliseconds: 400),
              offset: const Offset(-0.5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Life Assistant',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Super App Home',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            ScaleInWidget(
              delay: const Duration(milliseconds: 600),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // TODO: Implement notification
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 