part of '../pages.dart';

class HomeAttendence extends StatelessWidget {
  const HomeAttendence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: Text(
                    'Woku',
                    style:  GoogleFonts.concertOne(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blueAccent)
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.red, size: 35,),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Attendance Menu',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check In & Check Out',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Manage your attendance with ease',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white70,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.access_time, size: 70, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                _buildFeatureButton(Icons.login, 'Check In', Colors.green,
                    '/attendance-page', context),
                SizedBox(height: 10),
                _buildFeatureButton(Icons.logout, 'Check Out', Colors.orange,
                    '/leave-page', context),
                SizedBox(height: 10),
                _buildFeatureButton(
                    Icons.history, 'History', Colors.blue, '/history-page', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(IconData icon, String title, Color color,
      String route, BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
