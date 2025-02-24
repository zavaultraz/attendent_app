part of '../pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService _auth = FirebaseService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool isLoading = false;
  String? profileImage = "";
  File? imageFile;

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      isLoading = true;
    });
    String? userId = FirebaseAuth.instance.currentUser!.uid;
    Reference refrence =
        FirebaseStorage.instance.ref().child("profile/$userId");
    UploadTask uploadTask = refrence.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      profileImage = imageUrl;
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Profile image has been updated',
        style: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w600, color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }

    if (imageFile != null) {
      _uploadImage(imageFile!);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadProfileDate();
    super.initState();
  }

  void _checkEmail() async {
    setState(() {
      isLoading = true;
    });
    User? user = _auth.currentUser;
    if (!user!.emailVerified) {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'email verification has been sended',
          style: GoogleFonts.ibmPlexSans(
              fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  void _loadProfileDate() async {
    User? user = _auth.currentUser;
    String userId = user!.uid;
    Map<String, dynamic> userData = await _auth.getUserData(userId);
    nameController.text = userData['name'];
    lastNameController.text = userData['lastName'];
  }

  void _sendEmailVerification() async {
    setState(() {
      isLoading = true;
    });
    User? user = _auth.currentUser;
    await user?.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'email verification has been sended',
        style: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w600, color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));
    setState(() {
      isLoading = false;
    });
  }

  void _updateProfile() async {
    setState(() {
      isLoading = true;
    });
    String? name = nameController.text;
    String? lastName = lastNameController.text;

    await _auth.updateProfile(name, lastName);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: Text('Profile')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile!)
                      : profileImage != null
                          ? NetworkImage(profileImage!)
                          : const AssetImage('assets/images/berelang.jpeg'),
                ),
                Positioned(
                  child: GestureDetector(
                      onTap: _pickImage,
                      child: Icon(CupertinoIcons.camera_circle_fill)),
                  bottom: 0,
                  right: 0,
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Edit your name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.name,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              textInputAction: TextInputAction.done,
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                hintText: 'Edit your last name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.name,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              textInputAction: TextInputAction.done,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/change-password');
                  },
                  child: Text(
                    'Reset Password',
                    style: GoogleFonts.ibmPlexSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black54),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            // Ganti dengan warna yang diinginkan
                            ),
                      )
                    : GestureDetector(
                        onTap: _updateProfile,
                        child: Text(
                          'Kirim',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
            (FirebaseAuth.instance.currentUser!.emailVerified)
                ? Text('Email Verified',
                    style: GoogleFonts.ibmPlexSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black))
                : TextButton(
                    onPressed: _sendEmailVerification,
                    child: Text(
                      'Send email verification',
                      style: GoogleFonts.ibmPlexSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
