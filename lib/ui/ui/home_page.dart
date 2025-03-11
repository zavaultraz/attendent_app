part of '../pages.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _auth = FirebaseService();
  String? userId;
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    userId = user?.uid;
    userData = _auth.getUserData(userId!);
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('User data not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Text(
                        'Woku',
                        style: GoogleFonts.concertOne(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.red ,size: 30,),
                      onPressed: _signOut,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Hello,\n${snapshot.data!['name']} ${snapshot.data!['lastName']} 👋',
                  style: GoogleFonts.poppins(fontSize: 35, fontWeight: FontWeight.bold),
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
                              'Welcome to Woku',
                              style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Manage your attendance easily',
                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70,fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Image.asset('assets/images/illustration.png', height: 140,width: 140,),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text('Mau ngapain nih',style: GoogleFonts.poppins(fontSize: 26,fontWeight: FontWeight.w600),),
                SizedBox(height: 15),
                Column(
                  children: [
                    _buildFeatureButton(Icons.check_circle, 'Absen', Colors.green, '/home-attendance'),
                    SizedBox(height: 15),
                    _buildFeatureButton(Icons.note_alt, 'Note', Colors.orange, '/note'),
                    SizedBox(height: 15),
                    _buildFeatureButton(Icons.person, 'Profile', Colors.blue, '/profile'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureButton(IconData icon, String title, Color color, String route) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, route),
      child: Container(
        padding: EdgeInsets.all(20),
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
              style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
