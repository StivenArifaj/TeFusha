import 'package:flutter/material.dart';
import '../events/event_list_page.dart';
import 'my_teams_page.dart';

class TeamsAndTournamentsPage extends StatelessWidget {
  const TeamsAndTournamentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ekipet & Turnetë"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Ekipet e Mia"),
              Tab(text: "Eventet"),
            ],
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const TabBarView(
          children: [
            MyTeamsPage(),
            EventListPage(),
          ],
        ),
      ),
    );
  }
}
