part of '../pages.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isObscureText = true;
  bool isObsecureTextConfirm = true;
  bool isLoading = false;

  final FirebaseService _auth = FirebaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController(); // New controller for last name
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController rolePasswordContorller = TextEditingController();

  // Added role selection
  String? selectedRole = 'user'; // Default role is 'user'
  final List<String> roles = ['user', 'admin'];

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      User? user =
      (await _auth.signUp(emailController.text, passwordController.text));

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'lastName': lastNameController.text, // Store last name
          'email': emailController.text,
          'role': selectedRole, // Store selected role
        });

        Navigator.pushReplacementNamed(context, '/home');

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registrasi berhasil ${user.email}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: query9(context),
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: imageLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(

                        child: Text(
                          'Register Now',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 28),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(

                    child: Text(
                      'make easy than before',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.black54),
                    ),
                  ),
                  const SizedBox(
                    height: 8 ,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Profile',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),textAlign: TextAlign.start,),
                      ],
                    ),
                  ),
                  SizedBox(height: 7,),
                  SizedBox(
                    width: query9(context),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "First Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama depan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: query9(context),
                    child: TextFormField(
                      controller: lastNameController, // Last name input
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama belakang tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Account',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),textAlign: TextAlign.start,),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: query9(context),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: hintEmail,
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Role dropdown
                  SizedBox(
                    width: query9(context),
                    child: DropdownButtonFormField<String>(
                      value: selectedRole,
                      items: roles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (String? newRole) {
                        setState(() {
                          selectedRole = newRole!;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Role',
                        prefixIcon: const Icon(Icons.group),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a role';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Security',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 16),textAlign: TextAlign.start,),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: query9(context),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: hintPassword,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                          icon: isObscureText
                              ? const Icon(
                            Icons.visibility_off,
                          )
                              : const Icon(
                            Icons.visibility,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: isObscureText ? true : false,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        } else if (value.length < 8) {
                          return 'Password minimal 8 karakter';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: query9(context),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: hintConfirmPassword,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObsecureTextConfirm = !isObsecureTextConfirm;
                            });
                          },
                          icon: isObsecureTextConfirm
                              ? const Icon(
                            Icons.visibility_off,
                          )
                              : const Icon(
                            Icons.visibility,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: isObsecureTextConfirm ? true : false,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        } else if (value.length < 8) {
                          return 'Password minimal 8 karakter';
                        } else if (value != passwordController.text) {
                          return 'Password tidak sama';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: query9(context),
                    child: isLoading
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : ElevatedButton(
                      onPressed: () {
                        _signUp();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        hintSignUp,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.white)
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  SizedBox(
                    width: query9(context),
                    child: Text(
                      hintOtherSignUpOption,
                      style: subWelcomeTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: query9(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: const DecorationImage(
                                  image: imageGoogle,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              hintGoogle,
                              style: welcomeTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: const DecorationImage(
                                  image: imageFacebook,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              hintFacebook,
                              style: welcomeTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: query9(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          hintAlreadyHaveAccout,
                          style: subWelcomeTextStyle,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/sign-in');
                          },
                          child: Text(
                            hintSignIn,
                            style: GoogleFonts.poppins(fontSize: 16,color: colorPrimary,fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
