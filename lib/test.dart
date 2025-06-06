import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
        ),
        primarySwatch: Colors.blue,
        canvasColor: Colors.white54,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const <Widget>[
        NormalScreen(),
        CardScreen(),
        ChatReplyScreen(),
      ],
    );
  }
}

class NormalScreen extends StatefulWidget {
  const NormalScreen({Key? key}) : super(key: key);

  @override
  _NormalScreenState createState() => _NormalScreenState();
}

class _NormalScreenState extends State<NormalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Nomal Usecase'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 400,
          width: 400,
          child: CustomPaint(
            painter: TrianglePainter(progress: 1),
          ),
        ),
      ),
    );
  }
}

class CardScreen extends StatefulWidget {
  const CardScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Card Tile'),
      ),
      backgroundColor: Colors.white,
      body: ListView(children: <Widget>[
        ...persons.map(
          (Person person) => SwipeableTile.swipeToTriggerCard(
            swipeThreshold: 0.2,
            color: const Color(0xFFab9ee8),
            shadow: BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
            horizontalPadding: 16,
            verticalPadding: 8,
            direction: SwipeDirection.horizontal,
            onSwiped: (_) {
              // final index = persons.indexOf(person);

              // setState(() {
              //   persons.removeAt(index);
              // });
            },
            backgroundBuilder: (_, SwipeDirection direction, AnimationController progress) {
              return AnimatedBuilder(
                animation: progress,
                builder: (context, child) {
                  print('builder: ${progress.value}');
                  return CustomPaint(
                    painter: TrianglePainter(progress: progress.value),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.35 * progress.value),
                        child: Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              );
            },
            key: UniqueKey(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                leading: ClipRRect(borderRadius: BorderRadius.circular(48), child: Image.network(person.imageURL)),
                title: Text(
                  person.name,
                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                ),
                subtitle: Text(
                  '${person.state} ${person.city}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class ChatReplyScreen extends StatefulWidget {
  const ChatReplyScreen({Key? key}) : super(key: key);

  @override
  _ChatReplyScreenState createState() => _ChatReplyScreenState();
}

class _ChatReplyScreenState extends State<ChatReplyScreen> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  Person? _selectedPerson;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Swipe To Reply',
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(children: <Widget>[
              ...persons.map(
                (Person person) => SwipeableTile.swipeToTrigger(
                  behavior: HitTestBehavior.translucent,
                  isElevated: false,
                  color: Colors.white,
                  swipeThreshold: 0.2,
                  direction: SwipeDirection.endToStart,
                  onSwiped: (_) {
                    _focusNode.requestFocus();
                    setState(() {
                      _selectedPerson = person;
                    });
                  },
                  backgroundBuilder: (
                    _,
                    SwipeDirection direction,
                    AnimationController progress,
                  ) {
                    bool vibrated = false;
                    return AnimatedBuilder(
                      animation: progress,
                      builder: (_, __) {
                        if (progress.value > 0.9999 && !vibrated) {
                          Vibration.vibrate(duration: 40);
                          vibrated = true;
                        } else if (progress.value < 0.9999) {
                          vibrated = false;
                        }

                        print(progress.value);

                        final curveValue = CurvedAnimation(
                          parent: progress,
                          curve: Curves.easeOutBack,
                        ).value;

                        return Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            // Blue fill and curved shape based on swipe progress
                            // Positioned.fill(
                            //   child: CustomPaint(
                            //     painter: BlueCurvePainter(progressValue: curveValue),
                            //   ),
                            // ),
                            // Reply icon (unchanged)
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.reply,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  key: UniqueKey(),
                  child: MessageBubble(
                    url: person.imageURL,
                    message: person.message,
                    name: person.name,
                  ),
                ),
              ),
            ]),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                color: Colors.grey.shade200.withOpacity(0.5),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: <Widget>[
                      _selectedPerson != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.reply_rounded,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _selectedPerson!.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          _selectedPerson!.message,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedPerson = null;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onSubmitted: (_) {
                          _focusNode.canRequestFocus;
                        },
                        decoration: InputDecoration(
                          // filled: true,
                          // fillColor: Color(0xFFe8e6d5)
                          contentPadding: const EdgeInsets.all(16),
                          hintText: 'Type your message',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {},
                          ),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                          border: const UnderlineInputBorder(borderSide: BorderSide.none),

                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String name;
  final String message;
  final String url;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.name,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: Image.network(
              url,
              width: 48,
              height: 48,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFa1ffb7), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xFF457d52)),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(message),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<Person> persons = <Person>[
  Person(
      name: 'Timothy Altenwerth',
      city: 'East Port Vincechester',
      state: 'Michigan',
      streetAddress: '565359 Fisher Stravenue',
      imageURL: 'https://raw.githubusercontent.com/watery-desert/assets/main/swipeable_tile/babies/baby1.png',
      message: 'I heard babies needs more love nowadays. Please hug and kiss me more often.'),
  Person(
      name: 'Fernando Lynch',
      city: 'O\'Konview',
      state: 'Iowa',
      streetAddress: '682698 Bode Flats',
      imageURL: 'https://raw.githubusercontent.com/watery-desert/assets/main/swipeable_tile/babies/baby2.png',
      message: 'I wan\'t to sleep more don\'t wake me up. I will stay awake all night I promise.'),
  Person(
      name: 'Astrid Wolff',
      city: 'Davetown',
      state: 'Utah',
      streetAddress: '532429 Willow Ridge',
      imageURL: 'https://raw.githubusercontent.com/watery-desert/assets/main/swipeable_tile/babies/baby3.png',
      message: 'What happened? Everyone is alright? I was under the blanket. It was so dark I can\'t believe.'),
  Person(
      name: 'Madison Beier',
      city: 'Ethanside',
      state: 'Hawaii',
      streetAddress: '623190 Lewis Flats',
      imageURL: 'https://raw.githubusercontent.com/watery-desert/assets/main/swipeable_tile/babies/baby4.png',
      message: 'I can\'t believe how much I am happy to see you.'),
  Person(
      name: 'Josianne Gaylord',
      city: 'Mrazburgh',
      state: 'Iowa',
      streetAddress: '835334 Kuvalis Freeway',
      imageURL: 'https://raw.githubusercontent.com/watery-desert/assets/main/swipeable_tile/babies/baby5.png',
      message: 'Who wants to play with me? I am ready now.'),
];

class Person {
  final String name;
  final String city;
  final String streetAddress;
  final String state;
  final String imageURL;
  final String message;

  Person({
    required this.name,
    required this.city,
    required this.state,
    required this.streetAddress,
    required this.imageURL,
    required this.message,
  });
}

class TrianglePainter extends CustomPainter {
  final double progress;

  TrianglePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 1;

    final paint2 = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    final path2 = Path();
    // path2.moveTo(0, size.height);
    path2.moveTo(size.width, size.height - size.height * 0.85); // top right
    path2.lineTo(size.width, size.height * 0.85); // bottom right
    path2.quadraticBezierTo(
      size.width,
      size.height - size.height / 3,
      size.width * (1 - progress / 9) + radius * 2,
      size.height / 2 + radius,
    ); // to center
    path2.arcToPoint(
      Offset(size.width * (1 - progress / 9) + radius * 2, size.height / 2 - radius),
      radius: Radius.circular(radius * 1.1),
      clockwise: true,
    );
    path2.quadraticBezierTo(
      size.width,
      size.height / 3,
      size.width,
      size.height - size.height * 0.85,
    );

    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
