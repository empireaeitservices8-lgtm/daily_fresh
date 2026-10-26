import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/dayfresh_logo.dart';

class LoginScreen extends StatefulWidget {
  final AppState state;

  const LoginScreen({super.key, required this.state});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController(text: 'staff');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  UserRole _selectedRole = UserRole.staff;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectRole(UserRole role) {
    setState(() {
      _selectedRole = role;
      if (role == UserRole.generalManager) {
        _usernameController.text = 'gm';
        _passwordController.text = 'gm123';
      } else if (role == UserRole.storeManager) {
        _usernameController.text = 'sm';
        _passwordController.text = 'sm123';
      } else {
        _usernameController.text = 'staff';
        _passwordController.text = 'staff123';
      }
      _errorMessage = null;
    });
  }

  void _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;

    final u = username.toLowerCase();
    if (_selectedRole == UserRole.generalManager || u == 'gm' || u == 'admin') {
      widget.state.switchUserRole(UserRole.generalManager);
    } else if (_selectedRole == UserRole.storeManager || u == 'sm' || u.contains('store')) {
      widget.state.switchUserRole(UserRole.storeManager);
    } else {
      widget.state.switchUserRole(UserRole.staff);
    }

    widget.state.loginWithCredentials(username: username, password: password);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // DayFresh Logo Header
              const DayFreshLogo(scale: 1.25, isDarkBackground: false),
              const SizedBox(height: 8),

              Text(
                'Store Operations & Management Portal',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 28),

              // Role Selector Tabs (Staff vs Store Manager vs General Manager)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // 1. Staff Tab
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectRole(UserRole.staff),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: _selectedRole == UserRole.staff ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _selectedRole == UserRole.staff
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 16,
                                color: _selectedRole == UserRole.staff
                                    ? AppColors.primaryGreen
                                    : AppColors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Staff',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: _selectedRole == UserRole.staff
                                      ? AppColors.primaryGreen
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 2. SM (Store Manager) Tab
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectRole(UserRole.storeManager),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: _selectedRole == UserRole.storeManager ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _selectedRole == UserRole.storeManager
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.storefront_rounded,
                                size: 16,
                                color: _selectedRole == UserRole.storeManager
                                    ? const Color(0xFF2563EB)
                                    : AppColors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'SM (Store)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: _selectedRole == UserRole.storeManager
                                      ? const Color(0xFF2563EB)
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 3. GM (General Manager) Tab
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectRole(UserRole.generalManager),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: _selectedRole == UserRole.generalManager ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _selectedRole == UserRole.generalManager
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings_outlined,
                                size: 16,
                                color: _selectedRole == UserRole.generalManager
                                    ? const Color(0xFFD97706)
                                    : AppColors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'GM (HQ)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: _selectedRole == UserRole.generalManager
                                      ? const Color(0xFFD97706)
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedRole == UserRole.generalManager
                          ? 'General Manager (GM) Authentication'
                          : 'Store Staff Authentication',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedRole == UserRole.generalManager
                          ? 'Access Task Dispatch Hub, Oversight, and Admin Approval rules.'
                          : 'Access Tasks, Daily Checklists, Display FEFO, and Registers.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Username Field
                    Text(
                      'Username / Employee ID',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _usernameController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.textDark),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                        hintText: _selectedRole == UserRole.generalManager ? 'gm' : 'staff',
                        hintStyle: const TextStyle(color: AppColors.textLight),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _selectedRole == UserRole.generalManager
                                ? const Color(0xFFD97706)
                                : AppColors.primaryGreen,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    Text(
                      'Password',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.textDark),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: AppColors.textLight),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _selectedRole == UserRole.generalManager
                                ? const Color(0xFFD97706)
                                : AppColors.primaryGreen,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            _errorMessage!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 22),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedRole == UserRole.generalManager
                              ? const Color(0xFFD97706)
                              : _selectedRole == UserRole.storeManager
                                  ? const Color(0xFF2563EB)
                                  : AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 1,
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                _selectedRole == UserRole.generalManager
                                    ? 'Log in to GM Interface'
                                    : _selectedRole == UserRole.storeManager
                                        ? 'Log in to SM Interface'
                                        : 'Log in to Staff Portal',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Preset Login Chips for testing
              Text(
                'Quick Preset Credentials (1-Tap Login)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.person, size: 15, color: AppColors.primaryGreen),
                    label: const Text('Staff (Juan)', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      _selectRole(UserRole.staff);
                      _handleLogin();
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.storefront_rounded, size: 15, color: Color(0xFF2563EB)),
                    label: const Text('SM (Marcus)', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      _selectRole(UserRole.storeManager);
                      _handleLogin();
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.admin_panel_settings, size: 15, color: Color(0xFFD97706)),
                    label: const Text('GM (Alexander)', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      _selectRole(UserRole.generalManager);
                      _handleLogin();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
