import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';

class TeamDetailScreen extends StatelessWidget {
  final int id;

  const TeamDetailScreen({super.key, required this.id});

  void _showInviteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fto Anëtar të Ri',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dërgoni një ftesë me email për t\'u bashkuar me ekipin tuaj.',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                color: AppColors.textMedium,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email i anëtarit',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ftesa u dërgua!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: const Text('Dërgo Ftesën'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCaptain = true; // Mock role

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('FC TeFusha'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (isCaptain)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                // Navigate to edit
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppShadows.card,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.sportFootball.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.sports_soccer, size: 40, color: AppColors.sportFootball),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'FC TeFusha',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.inputFill,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Futboll',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '•',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '5 Anëtarë',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                color: AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Members List
                  const Text(
                    'Anëtarët',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final isMemberCaptain = index == 0;
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Text(
                                'L${index + 1}',
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isMemberCaptain ? 'Arbër T.' : 'Lojtar ${index + 1}',
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isMemberCaptain ? AppColors.primary : AppColors.inputFill,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isMemberCaptain ? 'Kapiten' : 'Anëtar',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: isMemberCaptain ? Colors.white : AppColors.textMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isCaptain && !isMemberCaptain)
                              IconButton(
                                icon: const Icon(Icons.person_remove_outlined, color: AppColors.error),
                                onPressed: () {
                                  // Show remove confirmation
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Bottom Actions
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: AppShadows.bottomNav,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCaptain) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showInviteBottomSheet(context),
                      child: const Text('Ftoni Anëtar'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push('/events'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    child: const Text('Regjistrohu për Event'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
