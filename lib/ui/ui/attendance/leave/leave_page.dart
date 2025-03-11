part of '../../../pages.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  // Deklarasi variabel dan controller
  String strAddress = '';
  String strDate = '';
  String strTime = '';
  String strDateTime = '';
  int dateHour = 0;
  int dateMinute = 0;
  double dLat = 0.0;
  double dLong = 0.0;
  final controllerName = TextEditingController();
  final formController = TextEditingController();
  final toController = TextEditingController();
  String dropValue = "Please Choose";
  var categoryList = <String>["Please Choose", "Sick", "Permission", "Other"];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    fetchUser(); // Memanggil fetchUser untuk mendapatkan data user
  }

  Future<void> fetchUser() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknow';
    if (userId == 'Unknow') {
      return;
    }
    try {
      DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
      print("userDoc : ${userDoc.data()}");
      String name = userDoc['name'];
      String lastName = userDoc['lastName'];
      String fullName = '$name $lastName';
      setState(() {
        controllerName.text = fullName;
      });
    } catch (e) {
      print("error :$e");
    }
  }

  Future<void> submitAbsent(String name, String status, String from, String until) async {
    showloaderDialog(context);

    String userId = FirebaseAuth.instance.currentUser?.uid ?? "Unknow";
    print("user id = $userId");

    if (userId == "Unknow") {
      print("Error: User ID not found");
      return;
    }

    DocumentReference userDocRef = firestore.collection('users').doc(userId);
    CollectionReference attendanceCollection = userDocRef.collection('attendance');

    attendanceCollection.add({
      'name': name,
      'description': status,
      'datetime': '$from-$until',
      'address' : strAddress,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((result) {
      print("Data berhasil disimpan dengan id = ${result.id}");
      setState(() {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  CupertinoIcons.check_mark_circled,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Yeyyy, laporan berhasil terkirim",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.greenAccent,
            behavior: SnackBarBehavior.floating,
            shape: StadiumBorder(),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeAttendence()),
        );
      });
    }).catchError((error) {
      print("Error menyimpan data: $error");
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                CupertinoIcons.xmark_circle, // Ikon error
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Oops, terjadi kesalahan. Coba lagi.",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent, // Warna merah untuk error
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
        ),
      );
    });
  }

  void showloaderDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          SizedBox(width: 10), // Menambahkan jarak antara loading indicator dan teks
          Text(
            'Please Wait.....',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        "Permission Form",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(10),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.house_fill,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Please Fill This Form Below",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16), // Jarak antara header dan input
                TextField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: controllerName,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: "Your Name",
                    hintText: "Please enter your name",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Leave Type",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    child: DropdownButton(
                      value: dropValue,
                      items: categoryList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropValue = value.toString();
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'From',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: formController,
                                onTap: () async {
                                  DateTime? pickDateTime =
                                  await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime(9999),
                                      initialDate: DateTime.now());
                                  if (pickDateTime != null) {
                                    formController.text =
                                        DateFormat('dd/M/yyyy')
                                            .format(pickDateTime);
                                  }
                                },
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'Until',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: toController,
                                onTap: () async {
                                  DateTime? pickDateTime =
                                  await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime(9999),
                                      initialDate: DateTime.now());
                                  if (pickDateTime != null) {
                                    toController.text =
                                        DateFormat('dd/M/yyyy')
                                            .format(pickDateTime);
                                  }
                                },
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(8),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: size.width * 0.8,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent,
                          child: InkWell(
                            splashColor: Colors.blue,
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              // Validasi form sebelum submit
                              if (controllerName.text.isEmpty ||
                                  dropValue == "Please Choose" ||
                                  formController.text.isEmpty ||
                                  toController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.info,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Please fill all the form",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.blueAccent,
                                    shape: StadiumBorder(),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                // Panggil submitAbsent
                                submitAbsent(
                                  controllerName.text,
                                  dropValue,
                                  formController.text,
                                  toController.text,
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                'Submit',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
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
