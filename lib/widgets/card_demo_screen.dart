import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class CardDemoScreen extends StatelessWidget {
  const CardDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SwipeableTile.swipeToTriggerCard(
                    key: UniqueKey(),
                    direction: SwipeDirection.horizontal,
                    backgroundBuilder: (BuildContext context, SwipeDirection direction, AnimationController progress) {
                      return SizedBox();
                    },
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    shadow: const BoxShadow(),
                    color: Colors.black,
                    onSwiped: (SwipeDirection direction) {},
                    child: const Center(
                        child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('qwe'),
                    )),
                  ),
                ),
                Expanded(
                  child: SwipeableTile.swipeToTriggerCard(
                    key: UniqueKey(),
                    direction: SwipeDirection.horizontal,
                    backgroundBuilder: (BuildContext context, SwipeDirection direction, AnimationController progress) {
                      return SizedBox();
                    },
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    shadow: const BoxShadow(),
                    color: Colors.blue,
                    onSwiped: (SwipeDirection direction) {},
                    child: const Center(
                        child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('qwe'),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
