import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/country_code.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/dayfresh_logo.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  final AppState state;

  const RegisterScreen({super.key, required this.state});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _empIdController = TextEditingController();

  CountryCode _selectedCountry = CountryCode.defaultList[0]; // +91 India
  String _selectedRole = 'Floor Supervisor';
  String _selectedBranch = 'DayFresh Hypermarket #104 - City Center';
  bool _agreedToTerms = true;
  bool _isLoading = false;

  final List<String> _roles = [
    'Store Operations Manager',
    'Floor Supervisor',
    'Inventory Auditor',
    'Produce & Fresh Food Specialist',
    'Merchandising Lead',
    'Cashier & Billing Team Lead',
  ];

  final List<String> _branches = [
    'DayFresh Hypermarket #104 - City Center',
    'DayFresh Hypermarket #108 - Metro West',
    'DayFresh Hypermarket #112 - North Boulevard',
    'DayFresh Express Hub #201 - Downtown',
  ];

  @override
  void initState() {
    super.initState();
    _empIdController.text = 'DF-${1000 + DateTime.now().millisecond % 9000}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _empIdController.dispose();
    super.dispose();
  }

  void _selectCountry() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Select Country Code',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: CountryCode.defaultList.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 60),
                  itemBuilder: (context, index) {
                    final item = CountryCode.defaultList[index];
                    final isSelected = item.dialCode == _selectedCountry.dialCode;
                    return ListTile(
                      leading: Text(item.flag, style: const TextStyle(fontSize: 24)),
                      title: Text(
                        item.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.primaryGreen : AppColors.textDark,
                        ),
                      ),
                      trailing: Text(
                        item.dialCode,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          color: isSelected ? AppColors.primaryGreen : AppColors.textMuted,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountry = item;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _proceedToOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Retail Operations Security terms to continue.'),
          backgroundColor: AppColors.priorityHighText,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    final phone = _phoneController.text.trim();
    final fullNumber = '${_selectedCountry.dialCode} $phone';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          state: widget.state,
          phoneNumber: fullNumber,
          isRegistration: true,
          fullName: _nameController.text.trim(),
          role: _selectedRole,
          storeBranch: _selectedBranch,
          employeeId: _empIdController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Staff Registration',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textDark,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top DayFresh mini banner
                Center(
                  child: Column(
                    children: [
                      const DayFreshLogo(scale: 0.9, isDarkBackground: false),
                      const SizedBox(height: 14),
                      Text(
                        'Join DayFresh Team',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Register your employee profile with mobile number and verify via OTP',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Full Name
                _buildFieldLabel('Full Name', isRequired: true),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'e.g. Alex Morgan',
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryGreen, size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Mobile Number
                _buildFieldLabel('Mobile Number (For OTP Verification)', isRequired: true),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _selectCountry,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_selectedCountry.flag, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 6),
                              Text(
                                _selectedCountry.dialCode,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down_rounded, color: AppColors.textMuted, size: 20),
                            ],
                          ),
                        ),
                      ),
                      Container(height: 26, width: 1, color: const Color(0xFFE2E8F0)),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Enter 10-digit number',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            if (value.trim().length < 8) {
                              return 'Enter a valid mobile number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Operational Role
                _buildFieldLabel('Store Operational Role', isRequired: true),
                DropdownButtonFormField<String>(
                  initialValue: _selectedRole,
                  isExpanded: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primaryGreen, size: 20),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDark),
                  items: _roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(
                        role,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedRole = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Assigned Branch
                _buildFieldLabel('Assigned Branch / Location', isRequired: true),
                DropdownButtonFormField<String>(
                  initialValue: _selectedBranch,
                  isExpanded: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.storefront_outlined, color: AppColors.primaryGreen, size: 20),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDark),
                  items: _branches.map((branch) {
                    return DropdownMenuItem<String>(
                      value: branch,
                      child: Text(
                        branch,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedBranch = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Employee ID
                _buildFieldLabel('Employee ID (Auto-assigned or custom)'),
                TextFormField(
                  controller: _empIdController,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.numbers_rounded, color: AppColors.primaryGreen, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.textLight),
                      onPressed: () {
                        setState(() {
                          _empIdController.text = 'DF-${1000 + DateTime.now().millisecond % 9000}';
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Terms Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        activeColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) {
                          setState(() {
                            _agreedToTerms = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'I confirm that I am an authorized employee of DayFresh Hypermarket and agree to company Retail Operation Security Policies.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // Submit & Send OTP Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _proceedToOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Send Verification Code (OTP)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 18),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(color: AppColors.priorityHighText, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
