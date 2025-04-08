import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:habit_tracker/entities/habit.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/widgets/card_demo_screen.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.brown.shade700,
          titleTextStyle: Theme.of(context).primaryTextTheme.titleLarge,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primaryContainer: Colors.brown.shade400,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HabitDatabase database = HabitDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CardDemoScreen()));
            },
            icon: const Icon(Icons.accessibility_new_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TimerScreen()));
            },
            icon: const Icon(Icons.timer),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarScreen()));
              },
              icon: const Icon(Icons.calendar_month),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Habit>>(
          future: database.getHabits(),
          builder: (context, habits) {
            if (habits.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (habits.hasError) {
              log('${habits.error}');
              return const Text('Error');
            }
            print(habits.data?.toList());

            // return SingleChildScrollView(
            //   child: LayoutGrid(
            //     columnSizes: [auto, auto],
            //     rowSizes: [auto, auto, auto, auto, auto, auto, auto, auto],
            //     children: [
            //       Container(height: 200, width: 200, color: Colors.blue,),
            //       Container(height: 200, width: 200, color: Colors.brown,),
            //       Container(height: 200, width: 200, color: Colors.yellow,),
            //       Container(height: 200, width: 200, color: Colors.orange,),
            //       Container(height: 200, width: 200, color: Colors.black,),
            //       Container(height: 200, width: 200, color: Colors.green,),
            //       Container(height: 200, width: 200, color: Colors.grey,),
            //       Container(height: 200, width: 200, color: Colors.red,),
            //       Container(height: 200, width: 200, color: Colors.blue,),
            //       Container(height: 200, width: 200, color: Colors.brown,),
            //       Container(height: 200, width: 200, color: Colors.yellow,),
            //       Container(height: 200, width: 200, color: Colors.orange,),
            //       Container(height: 200, width: 200, color: Colors.black,),
            //       Container(height: 200, width: 200, color: Colors.green,),
            //       Container(height: 200, width: 200, color: Colors.grey,),
            //       Container(height: 200, width: 200, color: Colors.red,),
            //
            //     ],
            //   ),
            // );
            /// flutter_layout_grid
            // return SingleChildScrollView(
            //   child: LayoutGrid(
            //     columnSizes: [auto, auto],
            //     rowSizes: List.generate(habits.data?.length ?? 0, (index) => 250.px),
            //     children: habits.data!
            //         .map(
            //           (habit) => HabitTile(
            //         //     // habit: habit,
            //         //     // onHandPressed: () async {
            //         //     //   await database.deleteHabit(habit.id ?? 0);
            //         //     //   setState(() {});
            //         //     // },
            //         //     // onCompleted: () async {
            //         //     //   await database.updateHabit(
            //         //     //     habit.copyWith(
            //         //     //       checkedDays: habit.checkedDays..add(DateTime.now()),
            //         //     //     ),
            //         //     //   );
            //         //     //   setState(() {});
            //         //     // },
            //       ),
            //     )
            //         .toList(),
            //   ),
            // );
            /// flutter_staggered_grid_view
            // return SingleChildScrollView(
            //   child: StaggeredGrid.count(
            //     crossAxisCount: 2,
            //     children: habits.data!
            //         .map((_) =>
            //             const StaggeredGridTile.count(crossAxisCellCount: 1, mainAxisCellCount: 1, child: HabitTile()))
            //         .toList(),
            //   ),
            // );
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Column(
                    children: habits.data!
                        .map(
                          (Habit habit) => habit.checkedDays.any((dateTime) =>
                                  dateTime.year == DateTime.now().year &&
                                  dateTime.month == DateTime.now().month &&
                                  dateTime.day == DateTime.now().day)
                              ? const SizedBox()
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.brown,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        habit.name,
                                        style: const TextStyle(fontSize: 17, color: Colors.white),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        splashRadius: 12,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          habit.checkedDays.add(DateTime.now());
                                          database.updateHabit(habit.copyWith(checkedDays: habit.checkedDays));
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.circle_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddHabitPopUp();
          // _showAddHabitSheet();
        },
        tooltip: 'New habit',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddHabitPopUp() {
    final TextEditingController controller = TextEditingController();

    WoltModalSheet.show(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            topBarTitle: const Text(
              'New Task',
              style: TextStyle(color: Colors.black),
            ),
            isTopBarLayerAlwaysVisible: true,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Task name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await database.insertHabit(Habit(name: controller.text, startDate: DateTime.now()));
                    if (modalSheetContext.mounted) {
                      Navigator.pop(modalSheetContext);
                      setState(() {});
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) {
        return WoltModalType.dialog();
      },
    );
  }

  String? validateHabitName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter the name';
    }
    return null;
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TableCalendar(
          firstDay: DateTime(2024, 10, 10),
          lastDay: DateTime(9999),
          focusedDay: DateTime.now(),
        ),
      ),
    );
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    onChange: (value) => debugPrint('onChange $value'),
    onChangeRawSecond: (value) => debugPrint('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => debugPrint('onChangeRawMinute $value'),
    onStopped: () {
      debugPrint('onStop');
    },
    onEnded: () {
      debugPrint('onEnded');
    },
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen(
      (value) => debugPrint('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'),
    );
    _stopWatchTimer.minuteTime.listen((value) => debugPrint('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => debugPrint('secondTime $value'));
    _stopWatchTimer.records.listen((value) => debugPrint('records $value'));
    _stopWatchTimer.fetchStopped.listen((value) => debugPrint('stopped from stream'));
    _stopWatchTimer.fetchEnded.listen((value) => debugPrint('ended from stream'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Count Up Timer'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Display stop watch time
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayTime = StopWatchTimer.getDisplayTime(value, hours: _isHours, milliSecond: false);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                              fontSize: 40,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                /// Display every minute.
                StreamBuilder<int>(
                  stream: _stopWatchTimer.minuteTime,
                  initialData: _stopWatchTimer.minuteTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    debugPrint('Listen every minute. $value');
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  'minute',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                /// Display every second.
                StreamBuilder<int>(
                  stream: _stopWatchTimer.secondTime,
                  initialData: _stopWatchTimer.secondTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    debugPrint('Listen every second. $value');
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  'second',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                /// Lap time.
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 100,
                    child: StreamBuilder<List<StopWatchRecord>>(
                      stream: _stopWatchTimer.records,
                      initialData: _stopWatchTimer.records.value,
                      builder: (context, snap) {
                        final value = snap.data!;
                        if (value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        });
                        debugPrint('Listen records. $value');
                        return ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            final data = value[index];
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    '${index + 1} ${data.displayTime}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                ),
                              ],
                            );
                          },
                          itemCount: value.length,
                        );
                      },
                    ),
                  ),
                ),

                /// Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: _stopWatchTimer.onStartTimer,
                          child: const Text(
                            'Start',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: _stopWatchTimer.onStopTimer,
                          child: const Text(
                            'Stop',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: _stopWatchTimer.onResetTimer,
                          child: const Text(
                            'Reset',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilledButton(
                            onPressed: _stopWatchTimer.onAddLap,
                            child: const Text(
                              'Lap',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: () {
                            _stopWatchTimer.setPresetHoursTime(1);
                          },
                          child: const Text(
                            'Set Hours',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: () {
                            _stopWatchTimer.setPresetMinuteTime(59);
                          },
                          child: const Text(
                            'Set Minute',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: () {
                            _stopWatchTimer.setPresetSecondTime(10);
                          },
                          child: const Text(
                            'Set +Second',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: () {
                            _stopWatchTimer.setPresetSecondTime(-10);
                          },
                          child: const Text(
                            'Set -Second',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilledButton(
                    onPressed: _stopWatchTimer.clearPresetTime,
                    child: const Text(
                      'Clear PresetTime',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
