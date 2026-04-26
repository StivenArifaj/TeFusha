import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import 'bloc/booking_bloc.dart';
import 'bloc/booking_event.dart';
import 'bloc/booking_state.dart';

class BookingPage extends StatefulWidget {
  final int fieldId;
  const BookingPage({super.key, required this.fieldId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlot;

  @override
  void initState() {
    super.initState();
    // Load initial availability
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAvailability();
    });
  }

  void _loadAvailability() {
    context.read<BookingBloc>().add(LoadAvailabilityEvent(
      widget.fieldId,
      DateFormat('yyyy-MM-dd').format(_selectedDate),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<BookingBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Rezervo Fushën"),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        body: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              context.go('/fields/${widget.fieldId}/confirmation');
            } else if (state is BookingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateStrip(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Text("Zgjidh orarin e lirë", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Expanded(
                  child: state is BookingLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : (state is AvailabilityLoaded)
                      ? _buildTimeGrid(state.slots)
                      : const SizedBox(),
                ),
                _buildBottomSummary(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateStrip() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 14, // Show next 14 days
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = DateUtils.isSameDay(_selectedDate, date);
          final dayName = DateFormat('E', 'sq').format(date); // Assuming locale support
          final dayNum = DateFormat('d').format(date);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                _selectedSlot = null;
              });
              _loadAvailability();
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeGrid(List<dynamic> slots) {
    if (slots.isEmpty) {
      return const Center(child: Text("Nuk ka orare të lira për këtë ditë."));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final time = slot.time;
        final isAvailable = slot.isAvailable;
        final isSelected = _selectedSlot == time;

        Color bgColor;
        Color textColor;
        if (!isAvailable) {
          bgColor = AppColors.slotTaken;
          textColor = AppColors.textSecondary;
        } else if (isSelected) {
          bgColor = AppColors.primary;
          textColor = Colors.white;
        } else {
          bgColor = AppColors.slotAvailable;
          textColor = AppColors.secondary;
        }

        return GestureDetector(
          onTap: isAvailable ? () => setState(() => _selectedSlot = time) : null,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected) const Icon(Icons.check_circle, color: Colors.white, size: 16),
                if (isSelected) const SizedBox(width: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Totali për t'u paguar:", style: TextStyle(color: AppColors.textSecondary)),
                Text(
                  _selectedSlot != null ? "1200 L" : "0 L", // Replace with real field price
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _selectedSlot == null 
                  ? null 
                  : () {
                      final h = int.parse(_selectedSlot!.split(':')[0]);
                      final endSlot = '${(h + 1).toString().padLeft(2, '0')}:00';
                      context.read<BookingBloc>().add(CreateBookingEvent(
                        widget.fieldId,
                        DateFormat('yyyy-MM-dd').format(_selectedDate),
                        _selectedSlot!,
                        endSlot,
                      ));
                    },
                child: const Text("Konfirmo Rezervimin"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
