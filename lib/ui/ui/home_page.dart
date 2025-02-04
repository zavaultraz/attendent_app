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
    userId = user!.uid;
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('error fetch data'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('user data not found'),
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Email : ${_auth.currentUser.email}'),
                    Text('name : ${snapshot.data!['name']}'),
                    Text('role : ${snapshot.data!['role']}'),
                    Text('Id : ${userId}'),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {},
                          child: Text(
                            'Absen',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/note');
                          },
                          child: Text(
                            'Note',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {},
                          child: Text(
                            'Profile',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    GestureDetector(
                      onTap: () {
                        _signOut();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Log out',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
