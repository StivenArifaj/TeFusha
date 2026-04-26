import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection.dart';
import 'bloc/event_bloc.dart';
import 'bloc/event_event.dart';
import 'bloc/event_state.dart';
import 'widgets/bracket_widget.dart';

class BracketPage extends StatelessWidget {
  final int eventId;
  const BracketPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc(getIt())..add(LoadEventDetailEvent(eventId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text("Tabela e Turneut")),
        body: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventError) {
              return Center(child: Text(state.message));
            } else if (state is EventDetailLoaded) {
              return InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 2.0,
                child: Center(
                  child: BracketWidget(matches: state.event.ndeshjet ?? []),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
