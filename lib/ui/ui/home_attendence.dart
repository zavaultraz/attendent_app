part of '../pages.dart';

class HomeAttendence extends StatelessWidget {
  const HomeAttendence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/attendance');
              },
              child: Text("Check In"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/leave-page');
              },
              child: Text("Check Out"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              child: Text("History"),
            ),
          ],
        ),
      ),
    );
  }
}
