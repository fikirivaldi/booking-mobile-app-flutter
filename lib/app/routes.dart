import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/detail/screens/detail_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/start/screens/start_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/booking/screens/booking_screen.dart';
import '../features/booking/screens/payment_screen.dart';
import 'main_screen.dart'; // Tambahkan import ini!

final routes = {
  '/': (context) => const SplashScreen(),
  '/start': (context) => const StartScreen(),
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignUpScreen(),
  '/home': (context) => const MainScreen(), // <- ubah ke MainScreen
  '/profile': (context) => const ProfileScreen(), // <- ubah ke MainScreen
  '/detail': (context) => const DetailScreen(),
  '/booking': (context) => const BookingScreen(),
  '/payment': (context) => const PaymentScreen(),


};
