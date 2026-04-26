import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import '../../../data/models/booking.dart';
import 'bloc/booking_bloc.dart';
import 'bloc/booking_event.dart';
import 'bloc/booking_state.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc(getIt(), getIt())..add(LoadMyBookingsEvent()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(AppStrings.myBookings),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Aktivë"),
                Tab(text: "Historia"),
              ],
              indicatorColor: Colors.white,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BookingError) {
                return Center(child: Text(state.message));
              } else if (state is MyBookingsLoaded) {
                final activeBookings = state.bookings.where((b) => 
                  b.statusi == 'ne_pritje' || b.statusi == 'konfirmuar').toList();
                final historyBookings = state.bookings.where((b) => 
                  b.statusi == 'perfunduar' || b.statusi == 'anuluar').toList();

                return TabBarView(
                  children: [
                    _buildBookingList(activeBookings, isActive: true),
                    _buildBookingList(historyBookings, isActive: false),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings, {required bool isActive}) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: AppColors.textHint.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              isActive ? "Nuk keni rezervime aktive." : "Historia është e zbrazët.",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking, isActive);
      },
    );
  }

  Widget _buildBookingCard(Booking booking, bool isActive) {
    Color statusColor;
    String statusText;

    switch (booking.statusi) {
      case 'konfirmuar':
        statusColor = AppColors.success;
        statusText = 'Konfirmuar';
        break;
      case 'anuluar':
        statusColor = AppColors.error;
        statusText = 'Anuluar';
        break;
      case 'perfunduar':
        statusColor = AppColors.textHint;
        statusText = 'Përfunduar';
        break;
      default:
        statusColor = AppColors.warning;
        statusText = 'Në Pritje';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.fusha?.emri_fushes ?? "Fusha Sportive",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 16, color: AppColors.textHint),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd MMMM yyyy', 'sq').format(DateTime.parse(booking.data_rezervimit)),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.textHint),
                const SizedBox(width: 8),
                Text(
                  "${_formatTime(booking.ora_fillimit)} - ${_formatTime(booking.ora_mbarimit)}",
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
            if (isActive && booking.statusi == 'ne_pritje') ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {}, // TODO: Cancel booking logic
                    child: const Text("Anulo Rezervimin", style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(String time) {
    // Backend returns full ISO string, we want HH:mm
    try {
      final dt = DateTime.parse(time).toLocal();
      return DateFormat('HH:mm').format(dt);
    } catch (e) {
      return time;
    }
  }
}
