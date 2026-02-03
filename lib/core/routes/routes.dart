import 'package:final_project/features/auth/forgetpassword_screen.dart';
import 'package:final_project/features/auth/login_screen.dart';
import 'package:final_project/features/auth/register_screen.dart';
import 'package:final_project/features/cart/address_screen.dart';
import 'package:final_project/features/cart/cart_items_screen.dart';
import 'package:final_project/features/cart/checkout_screen.dart';
import 'package:final_project/features/confirm_order/confirmation_screen.dart';
import 'package:final_project/features/confirm_order/order_review_screen.dart';
import 'package:final_project/features/confirm_order/payment_method_screen.dart';
import 'package:final_project/features/home/categories/hair_care_screen.dart';
import 'package:final_project/features/home/categories/pharma_screen.dart';
import 'package:final_project/features/home/categories/skin_care_screen.dart';
import 'package:final_project/features/home/home_screen.dart';
import 'package:final_project/features/home/prescription/prescription_items_screen.dart';
import 'package:final_project/features/home/prescription/scan_prescription_screen.dart';
import 'package:final_project/features/home/product/product_details_screen.dart';
import 'package:final_project/features/notification/notification_screen.dart';
import 'package:final_project/features/profile/edit_profile_page.dart';
import 'package:final_project/features/profile/my_profile_page.dart';
import 'package:final_project/features/splash/splashscreen.dart';
import 'package:final_project/features/welcome/welcome_screen.dart';
// import 'package:final_project/shared/widgets/main_layout.dart';
import 'package:go_router/go_router.dart';

import '../shared/widgets/main_layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    /// 🟢 Splash
    GoRoute(path: '/', builder: (context, state) => const Splashscreen()),

    /// 🟢 Welcome
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),

    /// 🟢 Auth
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forget-password',
      builder: (context, state) => const ForgetPasswordScreen(),
    ),

    /// 🔥 Main Layout (Bottom Navigation)
    ShellRoute(
      builder: (context, state, child) {
        int currentIndex = 0;
        final location = state.uri.path;

        if (location.startsWith('/our-pharm')) {
          currentIndex = 1;
        } else if (location.startsWith('/hair-care')) {
          currentIndex = 1;
        } else if (location.startsWith('/skin-care')) {
          currentIndex = 1;
        } else if (location.startsWith('/cart')) {
          currentIndex = 2;
        } else if (location.startsWith('/notifications')) {
          currentIndex = 3;
        } else if (location.startsWith('/profile')) {
          currentIndex = 4;
        } else {
          currentIndex = 0;
        }

        return MainLayout(currentIndex: currentIndex, child: child);
      },
      routes: [
        /// 🏠 Home
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),

        /// 🧴 Categories
        GoRoute(
          path: '/our-pharm',
          builder: (context, state) => const PharmaScreen(),
        ),
        GoRoute(
          path: '/hair-care',
          builder: (context, state) => const HairCareScreen(),
        ),
        GoRoute(
          path: '/skin-care',
          builder: (context, state) => const SkinCareScreen(),
        ),

        /// 🛒 Cart
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartItemsScreen(),
        ),

        /// 🔔 Notifications
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationScreen(),
        ),

        /// 👤 Profile
        GoRoute(
          path: '/profile',
          builder: (context, state) => const MyProfilePage(),
        ),
      ],
    ),

    /// 🔹 Screens خارج الـ Bottom Nav
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),

    GoRoute(
      path: '/scan-prescription',
      builder: (context, state) => const ScanPrescriptionScreen(),
    ),
    GoRoute(
      path: '/prescription-items',
      builder: (context, state) => const PrescriptionItemsScreen(),
    ),

    GoRoute(
      path: '/product-details',
      builder: (context, state) => const ProductDetailsScreen(),
    ),

    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/address',
      builder: (context, state) => const AddressScreen(),
    ),
    GoRoute(
      path: '/payment-method',
      builder: (context, state) => const PaymentMethodScreen(),
    ),
    GoRoute(
      path: '/order-review',
      builder: (context, state) => const OrderReviewScreen(),
    ),
    GoRoute(
      path: '/confirmation',
      builder: (context, state) => const ConfirmationScreen(),
    ),
  ],
);
