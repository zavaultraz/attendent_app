part of '../pages.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isObscureText = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email and password can't be empty"),
        ),
      );
    } else {
      final user = await firebaseService.signIn(email, password);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email or password is incorrect"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 120,
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
              height: 10,
            ),
            SizedBox(
              width: query9(context),
              child: Text(
                welcomeText,
                style: GoogleFonts.varelaRound(
                    fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: query9(context),
              child: Text(
                subWelcomeText,
                style: GoogleFonts.varelaRound(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
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
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(
              height: 10,
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
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: query9(context),
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  hintForgotPassword,
                  textAlign: TextAlign.end,
                  style: subWelcomeTextStyle,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: query9(context),
              child: ElevatedButton(
                onPressed: () {
                  _login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  hintSignIn,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: query9(context),
              child: Text(
                hintOtherSignInOption,
                style: subWelcomeTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: query9(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    hintDoesntHaveAccout,
                    style: subWelcomeTextStyle,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/sign-up');
                    },
                    child: Text(
                      hintSignUp,
                      style: welcomeTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
