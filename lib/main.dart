import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/landing/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
      ),
      body: LandingPage()
    );
  }
}


// class MonthCalendar extends StatelessWidget{
//   MonthCalendar({Key? key, required this.month}) : super(key: key);
//   final DateTime month;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           DateFormat.yMMMM().format(month),
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         GridView.count(crossAxisCount: 7,
        
//         children: List.generate(35, (index) {
//             return Center(
//               child: Expanded(
//                 child: Text(
//                   'Item $index',
//                   style: TextTheme.of(context).headlineSmall,
//                 ),
//               ),
//             );
//           }),),
//       ],
//     );
//   }
// }

// class MonthCalendar extends StatelessWidget {
//   final DateTime month;

//   MonthCalendar({Key? key, required this.month}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
//     DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
//     int startWeekday = firstDayOfMonth.weekday; // 1 (Monday) to 7 (Sunday)

//     List<Widget> dayWidgets = [];

//     // Add empty cells for the first week alignment
//     for (int i = 1; i < startWeekday; i++) {
//       dayWidgets.add(Container());
//     }

//     // Add the actual days
//     for (int i = 1; i <= daysInMonth; i++) {
//       dayWidgets.add(
//         Container(
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//           ),
//           child: Text('$i', style: TextStyle(fontSize: 18)),
//         ),
//       );
//     }

//     return Column(
//       children: [
//         Text(
//           DateFormat.yMMMM().format(month),
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Expanded(
//           child: GridView.count(
//             crossAxisCount: 7, // 7 days a week
//             children: dayWidgets,
//           ),
//         ),
//       ],
//     );
//   }
// }

