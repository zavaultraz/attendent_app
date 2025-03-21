import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:presensi/ui/ui/attendance/history/widget/attendance_card_widget.dart';

import '../Service/service.dart';
import '../themes/shared.dart';
import '../utils/detection/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

part 'auth/sign_in_page.dart';
part 'auth/sign_up_page.dart';
part 'ui/home_page.dart';
part 'ui/note_page.dart';
part 'ui/profile_page.dart';
part 'ui/change_password_page.dart';
part 'ui/home_attendence.dart';
part 'ui/attendance/leave/leave_page.dart';
part 'ui/attendance/history/history_page.dart';
part 'ui/splash_screen.dart';
part 'ui/onboarding_screen.dart';
part 'ui/profile_screen.dart';