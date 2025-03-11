part of '../pages.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            SizedBox(
              height: 8,
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, color: color, fontSize: 20),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 5),
                ),
              ]),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : color.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : color,
                size: 24,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red : Colors.black87,
                    ),
                  ), // Text
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: Colors.grey,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(child: Text('User data not found'));
            }
            final data = snapshot.data!;
            final firstName = data['name'] ?? 'No Name';
            final lastName = data['lastname'] ?? 'No Lastname';
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(
                              131, 204, 255, 1), // rgba(131,204,255,1)
                          Color.fromRGBO(66, 144, 251, 1), // rgba(66,144,251,1)
                        ],
                        begin: Alignment.topLeft, // Equivalent to 89.5 degrees
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -50,
                          right: -50,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 48,
                          left: 16,
                          right: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Profile",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 110,
                                  width: 110,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(55),
                                    child: Image.asset(
                                        'assets/images/woku_icon.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "$firstName",
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
