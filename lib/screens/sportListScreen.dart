import 'package:favorite_sports/data/sportRepository.dart';
import 'package:favorite_sports/data/user_settings_repository.dart';
import 'package:favorite_sports/model/sports.dart';
import 'package:favorite_sports/routes.dart';
import 'package:flutter/material.dart';

class SportListScreen extends StatefulWidget {
  const SportListScreen({super.key});

  @override
  State<SportListScreen> createState() => _SportListScreenState();
}

class _SportListScreenState extends State<SportListScreen> {
  final UserSettingsRepository userSettingsRepository =
      UserSettingsRepository();
  final SportsRepository sportsRepository = SportsRepository();
  Future<Sport?>? _lastViewedFuture;
  Future<List<Sport>>? _sportsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _lastViewedFuture = userSettingsRepository.getLastViewedSport();
    _sportsFuture = sportsRepository.loadSports();
  }

  void _navigateToDetail(Sport sport) async {
    await userSettingsRepository.saveLastViewedSport(sport);
    Navigator.pushNamed(context, Routes.details, arguments: sport);
  }

  Widget _buildLastViewedCard(Sport? sport) {
    if (sport == null) return SizedBox();

    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Image.asset(sport.image, width: 50, height: 50),
        title: Text('Último esporte visto'),
        subtitle: Text(sport.name),
        trailing: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () async {
            await userSettingsRepository.clearLastViewedSport();
            setState(() {
              _lastViewedFuture = userSettingsRepository.getLastViewedSport();
            });
          },
        ),
        onTap: () => _navigateToDetail(sport),
      ),
    );
  }

  Widget _buildSportCard(Sport sport) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Image.asset(sport.image, width: 50, height: 50),
        title: Text(sport.name),
        subtitle: Text(sport.description),
        trailing: Icon(Icons.chevron_right),
        onTap: () => _navigateToDetail(sport),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Esportes Favoritos')),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadData();
          });
        },
        child: Column(
          children: [
            // Seção do último esporte visto
            FutureBuilder<Sport?>(
              future: _lastViewedFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return _buildLastViewedCard(snapshot.data);
              },
            ),
            Divider(),
            // Lista de esportes
            Expanded(
              child: FutureBuilder<List<Sport>>(
                future: _sportsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar esportes'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Nenhum esporte encontrado'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _buildSportCard(snapshot.data![index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
