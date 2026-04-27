import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shadows.dart';
import '../../core/di/injection.dart';
import '../fields/bloc/field_bloc.dart';
import '../fields/bloc/field_event.dart';
import '../fields/bloc/field_state.dart';
import 'widgets/field_summary_mini_card.dart';
import 'widgets/booking_summary_row.dart';

class RequestToBookScreen extends StatefulWidget {
  final int fieldId;

  const RequestToBookScreen({super.key, required this.fieldId});

  @override
  State<RequestToBookScreen> createState() => _RequestToBookScreenState();
}

class _RequestToBookScreenState extends State<RequestToBookScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlot;

  // Mock slots for demonstration
  final List<_TimeSlot> _slots = [
    _TimeSlot('16:00', false),
    _TimeSlot('17:00', true),
    _TimeSlot('18:00', true),
    _TimeSlot('19:00', true),
    _TimeSlot('20:00', false),
    _TimeSlot('21:00', true),
    _TimeSlot('22:00', true),
    _TimeSlot('23:00', true),
  ];

  void _loadSlots(DateTime date) {
    // In a real app, trigger a BLoC event to fetch slots for this date
    setState(() {
      _selectedSlot = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldBloc(getIt())..add(LoadFieldDetailEvent(widget.fieldId)),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          title: const Text('Rezervo Fushën'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<FieldBloc, FieldState>(
          builder: (context, state) {
            if (state is FieldLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FieldError) {
              return Center(child: Text(state.message));
            }
            if (state is FieldDetailLoaded) {
              final field = state.field;
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // SECTION 1 — FIELD SUMMARY CARD
                        FieldSummaryMiniCard(field: field),
                        
                        const SizedBox(height: 24),
                        // SECTION 2 — DATE STRIP
                        const Text(
                          'Zgjidh Datën',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 30,
                            itemBuilder: (_, i) {
                              final day = DateTime.now().add(Duration(days: i));
                              final isSelected = DateUtils.isSameDay(day, _selectedDate);
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedDate = day);
                                  _loadSlots(day);
                                },
                                child: Container(
                                  width: 58,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(14),
                                    border: isSelected ? null : Border.all(color: AppColors.divider),
                                    boxShadow: isSelected ? AppShadows.button : AppShadows.card,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('EEE').format(day).toUpperCase(), // Note: 'sq' locale requires setup
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textLight,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${day.day}',
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected ? Colors.white : AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('MMM').format(day), // Note: 'sq' locale requires setup
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        // SECTION 3 — TIME SLOT GRID
                        const Text(
                          'Oraret e Disponueshme',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('dd MMMM yyyy').format(_selectedDate),
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            color: AppColors.textMedium,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.2,
                          ),
                          itemCount: _slots.length,
                          itemBuilder: (_, i) {
                            final slot = _slots[i];
                            final isAvailable = slot.available;
                            final isSelected = slot.time == _selectedSlot;
                            
                            return GestureDetector(
                              onTap: isAvailable ? () => setState(() => _selectedSlot = slot.time) : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? AppColors.primary
                                      : isAvailable 
                                          ? AppColors.cardBg
                                          : AppColors.inputFill,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected 
                                        ? AppColors.primary
                                        : isAvailable 
                                            ? AppColors.divider
                                            : AppColors.divider.withOpacity(0.5),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    slot.time,
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected 
                                          ? Colors.white 
                                          : isAvailable 
                                              ? AppColors.textDark 
                                              : AppColors.textLight,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        // SECTION 4 — BOOKING SUMMARY
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _selectedSlot != null ? 1.0 : 0.0,
                          child: _selectedSlot != null
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: AppShadows.card,
                                  ),
                                  child: Column(
                                    children: [
                                      BookingSummaryRow('Fusha', field.emri_fushes ?? ''),
                                      BookingSummaryRow('Data', DateFormat('dd/MM/yyyy').format(_selectedDate)),
                                      BookingSummaryRow(
                                        'Ora', 
                                        '$_selectedSlot - ${int.parse(_selectedSlot!.split(':')[0]) + 1}:00'
                                      ),
                                      const Divider(height: 16),
                                      BookingSummaryRow(
                                        'Totali', 
                                        'L ${field.cmimi_orari}',
                                        valueStyle: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  
                  // BOTTOM BUTTON
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: AppShadows.bottomNav,
                      ),
                      child: ElevatedButton(
                        onPressed: _selectedSlot != null
                            ? () {
                                context.push('/checkout');
                              }
                            : null,
                        child: const Text('Vazhdo me Checkout'),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _TimeSlot {
  final String time;
  final bool available;

  _TimeSlot(this.time, this.available);
}
