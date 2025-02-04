part of 'shared.dart';

double query9(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.9;
}

final colorPrimary = '1D1C36FF'.toColor();
final colorWhite = 'FFFFFFFF'.toColor();

const imageLogo = AssetImage("assets/images/berelang.jpeg");
const imageGoogle = AssetImage("assets/icon/google.png");
const imageFacebook = AssetImage("assets/icon/facebook.png");

const welcomeText = 'Welcome Back ✋';
const subWelcomeText = 'Lets start your day';

const hintEmail = 'Email';
const hintPassword = 'Password';
const hintConfirmPassword = 'Confirm Password';
const hintForgotPassword = 'Forgot Password?';
const hintSignIn = 'Sign In';
const hintSignUp = 'Sign Up';
const hintOtherSignInOption = 'Other Sign In Options';
const hintOtherSignUpOption = 'Other Sign Up Options';
const hintGoogle = "Google";
const hintFacebook = "Facebook";
const hintDoesntHaveAccout = "Don't have an account?";
const hintAlreadyHaveAccout = "Already have an account?";

TextStyle welcomeTextStyle = GoogleFonts.poppins(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: Colors.black,
);
TextStyle subWelcomeTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.black54,
);
TextStyle hintTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: colorWhite,
);