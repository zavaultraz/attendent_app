part of '../pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  double _loadingProgress = 0.0;
  Timer? _progressTimer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
    _startloadingProgress();
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    });
  }

  void _startloadingProgress() {
    const totalSteps = 100;
    const stepDuration = Duration(milliseconds: 30);
    _progressTimer = Timer.periodic(
      stepDuration,
      (timer) {
        setState(() {
          if (_loadingProgress < 1.0) {
            _loadingProgress += 1 / totalSteps;
          } else {
            _progressTimer?.cancel();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(131, 204, 255, 1), // rgba(131,204,255,1)
              Color.fromRGBO(66, 144, 251, 1),  // rgba(66,144,251,1)
            ],
            begin: Alignment.topLeft, // Equivalent to 89.5 degrees
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1)),
                )),
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            child: Stack(
                              children: [
                                // Stroke text (behind)
                                Text(
                                  'Woku',
                                  style: GoogleFonts.concertOne(
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 20
                                      ..color = Colors.blueAccent,
                                  ),
                                ),
                                // Filled text (in front)
                                Text(
                                  'Woku',
                                  style: GoogleFonts.concertOne(
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              "Solusi Absensi Cerdas",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  letterSpacing: 1.2),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _loadingProgress,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text('${(_loadingProgress * 100).toInt()}%',style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
