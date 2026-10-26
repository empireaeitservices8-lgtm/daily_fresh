import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_state.dart';
import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primaryGreen,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const DayFreshApp());
}

class DayFreshApp extends StatefulWidget {
  const DayFreshApp({super.key});

  @override
  State<DayFreshApp> createState() => _DayFreshAppState();
}

class _DayFreshAppState extends State<DayFreshApp> {
  final AppState _appState = AppState();
  bool _phoneFrameMode = true;
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayFresh HYPERMARKET',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ListenableBuilder(
        listenable: _appState,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              final currentActiveScreen = AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _showSplash
                    ? SplashScreen(
                        key: const ValueKey('splash_screen'),
                        onFinish: () {
                          setState(() {
                            _showSplash = false;
                          });
                        },
                      )
                    : (_appState.isAuthenticated
                        ? HomeShell(
                            key: const ValueKey('home_shell'),
                            state: _appState,
                          )
                        : LoginScreen(
                            key: const ValueKey('login_screen'),
                            state: _appState,
                          )),
              );

              if (!isWide || !_phoneFrameMode) {
                return currentActiveScreen;
              }

              // Responsive Phone Frame for desktop and web testing
              return Scaffold(
                backgroundColor: const Color(0xFF0F172A),
                body: Stack(
                  children: [
                    // Top control bar for web/desktop
                    Positioned(
                      top: 14,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        'DayFresh Operations',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    _appState.isAuthenticated
                                        ? 'Active Session: ${_appState.currentUser.name} (${_appState.currentUser.role})'
                                        : 'Staff Authentication & OTP Portal',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              if (_appState.isAuthenticated)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ActionChip(
                                    avatar: const Icon(
                                      Icons.logout_rounded,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Log Out',
                                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12),
                                    ),
                                    backgroundColor: const Color(0xFF991B1B),
                                    side: BorderSide.none,
                                    onPressed: () {
                                      _appState.logout();
                                    },
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ActionChip(
                                    avatar: const Icon(
                                      Icons.bolt_rounded,
                                      size: 15,
                                      color: Color(0xFF22C55E),
                                    ),
                                    label: Text(
                                      'Quick Demo In',
                                      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12),
                                    ),
                                    backgroundColor: const Color(0xFF1E293B),
                                    side: const BorderSide(color: Color(0xFF334155)),
                                    onPressed: () {
                                      _appState.bypassAuthForDemo();
                                    },
                                  ),
                                ),
                              ActionChip(
                                avatar: const Icon(
                                  Icons.replay_rounded,
                                  size: 15,
                                  color: Colors.white70,
                                ),
                                label: Text(
                                  'Splash',
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12),
                                ),
                                backgroundColor: const Color(0xFF1E293B),
                                side: const BorderSide(color: Color(0xFF334155)),
                                onPressed: () {
                                  setState(() {
                                    _showSplash = true;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              ActionChip(
                                avatar: Icon(
                                  _phoneFrameMode ? Icons.fullscreen_rounded : Icons.phone_iphone_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  _phoneFrameMode ? 'Full Screen' : 'Mobile View',
                                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 12),
                                ),
                                backgroundColor: const Color(0xFF1E293B),
                                side: const BorderSide(color: Color(0xFF334155)),
                                onPressed: () {
                                  setState(() {
                                    _phoneFrameMode = !_phoneFrameMode;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Centered Phone Mockup
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 36, bottom: 20),
                        width: 395,
                        height: 820,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(44),
                          border: Border.all(color: const Color(0xFF334155), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 36,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            // Simulated iOS/Android Status Bar matching design
                            Container(
                              color: AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '9:41',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Row(
                                    children: const [
                                      Icon(Icons.signal_cellular_alt_rounded, color: Colors.white, size: 14),
                                      SizedBox(width: 4),
                                      Icon(Icons.wifi_rounded, color: Colors.white, size: 14),
                                      SizedBox(width: 4),
                                      Icon(Icons.battery_full_rounded, color: Colors.white, size: 15),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // App Content Shell (Switches between Login and HomeShell)
                            Expanded(
                              child: currentActiveScreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
