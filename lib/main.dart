import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/flavor_config.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
// dev flags and fake services removed; using real services via providers
import 'providers/barber_provider.dart';
import 'providers/booking_provider.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set default flavor to CUSTOMER (for web testing)
  // Individual flavor mains (main_barber.dart, main_admin.dart) override this
  FlavorConfig.setFlavor(
    AppFlavor.customer,
    'BarberPro',
    'com.barberpro.customer',
  );

  // Initialize Firebase for all platforms. Use web options on web,
  // and the platform-native configuration on mobile/desktop.
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Initialize auth provider for web as well
  final authProvider = AuthProvider();
  await authProvider.initializeAuth();

  // Initialize theme provider (reads saved prefs)
  final themeProvider = await ThemeProvider.create();

  runApp(MyApp(
    authProvider: authProvider,
    themeProvider: themeProvider,
  ));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final ThemeProvider themeProvider;

  const MyApp({super.key, required this.authProvider, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => BarberProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: Builder(builder: (context) {
        final router = createAppRouter(context.read<AuthProvider>().authStateChanges);
        return MaterialApp.router(
          title: FlavorConfig.displayName,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: context.watch<ThemeProvider>().themeMode,
          routerConfig: router,
        );
      }),
    );
  }
}
