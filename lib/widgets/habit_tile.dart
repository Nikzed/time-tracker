import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

import '../test.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SwipeableTile.swipeToTriggerCard(
        key: UniqueKey(),
        swipeThreshold: 0.25,
        backgroundBuilder: (_, SwipeDirection direction, AnimationController progress) {
          return AnimatedBuilder(
            animation: progress,
            builder: (context, child) {
              print('builder: ${progress.value}');
              if (direction == SwipeDirection.startToEnd) {
                return const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.add),
                );
              } else if (direction == SwipeDirection.endToStart) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: AnimatedBuilder(
                    animation: progress,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: TrianglePainter(progress: progress.value),
                        child: const Align(
                          alignment: Alignment.centerRight,
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          );
        },
        horizontalPadding: 14,
        verticalPadding: 8,
        shadow: const BoxShadow(),
        color: const Color(0xff6f4d37),
        onSwiped: (SwipeDirection direction) {},
        direction: SwipeDirection.horizontal,
        child: SizedBox(
          // height: 500,
          // width: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(14)),
                    child: const Center(
                      child: Text('ICON'),
                    ),
                  ),
                ),
                const Text('Title'),
                const Text('Success rate'),
              ],
            ),
          ),
        ));
  }
}
