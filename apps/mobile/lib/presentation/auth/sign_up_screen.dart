import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/injection.dart';
import '../common/widgets/role_card.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  String _selectedRole = 'perdorues';
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(getIt()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                // Pass email to OTP verify screen
                context.push('/otp-verify', extra: _emailCtrl.text);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Krijo Llogari',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Plotëso të dhënat e mëposhtme.',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Emri i plotë',
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    decoration: InputDecoration(
                      labelText: 'Fjalëkalimi',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPassCtrl,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'Konfirmo fjalëkalimin',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Unë jam:',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RoleCard(
                        role: 'Lojtar',
                        icon: Icons.sports_soccer,
                        isSelected: _selectedRole == 'perdorues',
                        onTap: () => setState(() => _selectedRole = 'perdorues'),
                      ),
                      const SizedBox(width: 12),
                      RoleCard(
                        role: 'Pronar Fushe',
                        icon: Icons.storefront_outlined,
                        isSelected: _selectedRole == 'pronar_fushe',
                        onTap: () => setState(() => _selectedRole = 'pronar_fushe'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                      children: [
                        TextSpan(text: 'Duke vazhduar, pranon '),
                        TextSpan(
                          text: 'Kushtet e Shërbimit',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' dhe '),
                        TextSpan(
                          text: 'Politikën e Privatësisë',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading 
                        ? null 
                        : () {
                            if (_passCtrl.text != _confirmPassCtrl.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fjalëkalimet nuk përputhen!'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                              return;
                            }
                            context.read<AuthBloc>().add(
                              RegisterSubmitted(
                                _nameCtrl.text,
                                _emailCtrl.text,
                                _passCtrl.text,
                                _selectedRole,
                              ),
                            );
                          },
                      child: state is AuthLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Regjistrohu'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ke llogari? ',
                        style: TextStyle(color: AppColors.textMedium),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text(
                          'Hyr',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
