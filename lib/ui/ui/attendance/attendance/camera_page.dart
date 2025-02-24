part of '../../../pages.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final FaceDetector _faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableLandmarks: true,
    enableTracking: true,
  ));
  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool isBusy = false;

  Future<void> loadCamera() async {
    cameras = await availableCameras();
    if (cameras == null || cameras!.isEmpty) {
      showsnackbar('No camera available');
      return;
    }

    controller = CameraController(
      cameras!.length > 1 ? cameras![1] : cameras![0],
      ResolutionPreset.max,
    );

    try {
      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      showsnackbar('Failed to initialize camera: $e');
    }
  }

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  void showsnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.blueGrey,
    ));
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Location services are disabled. Please enable the services.",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        backgroundColor: Colors.blueGrey,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.location_off,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Location permission denied.",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          backgroundColor: Colors.blueGrey,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Location permission denied forever, we cannot access.",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        backgroundColor: Colors.blueGrey,
        shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
    return true;
  }

  Future<void> captureImage() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;

    try {
      if (controller != null && controller!.value.isInitialized) {
        await controller!.setFlashMode(FlashMode.off);
        final XFile imageFile = await controller!.takePicture();

        setState(() {
          showLoaderDialog();
          final inputImage = InputImage.fromFilePath(imageFile.path);

          if (Platform.isAndroid) {
            processImage(inputImage);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AttendancePage(image: imageFile),
              ),
            );
          }
        });
      }
    } catch (e) {
      showsnackbar("Error: $e");
    }
  }

  Future<void> processImage(InputImage inputImage) async {
    isBusy = true;
    final faces = await _faceDetector.processImage(inputImage);
    isBusy = false;

    if (mounted) {
      setState(() {
        Navigator.pop(context);

        if (faces.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AttendancePage(image: image)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.face_retouching_natural_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Oops, make sure your face is clearly visible!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.blueGrey,
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }

  void showLoaderDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text('Procesing')
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: size.height,
            width: size.width,
            child: controller == null || !controller!.value.isInitialized
                ? const Center(child: CircularProgressIndicator())
                : CameraPreview(controller!),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset("assets/raw/face_id_ring.json", fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildBottomContainer(size),
          ),
        ],
      ),
    );
  }

  Widget buildBottomContainer(Size size) {
    return Container(
      width: size.width,
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          )),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Make sure your face is visible',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: ClipOval(
              child: Material(
                color: Colors.blueAccent,
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: captureImage,
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      Icons.camera_enhance_outlined,
                      color: Colors.white,
                    ),
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
