import 'package:flutter/material.dart';
import 'package:frontend/Screens/Studente/models/Prenotazione.dart';
import 'package:frontend/Screens/Studente/models/Appello.dart';
import 'DataClass.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/utils/ApiManager.dart';
import 'dart:convert';

Future<List<Prenotazione>> _fetchPrenotazioni() async {
  var response = await ApiManager.fetchData('appelli/prenotazioni');
  if (response != null) {
    var results = json.decode(response) as List?;
    if (results != null) {
      return results.map((e) => Prenotazione.fromJson(e)).toList();
    }
  }

  return [];
}

class PrenotazioniScreen extends StatefulWidget {
  const PrenotazioniScreen({super.key});

  @override
  State<PrenotazioniScreen> createState() => _PrenotazioniScreenState();
}

class _PrenotazioniScreenState extends State<PrenotazioniScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Prenotazione>>(
      future: _fetchPrenotazioni(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Prenotazione>> snapshotPrenotazione) {
        if (snapshotPrenotazione.connectionState == ConnectionState.none) {
          return const Text('no data');
        } else if (snapshotPrenotazione.connectionState ==
            ConnectionState.done) {
          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: DataClass(
              dataListPrenotazioni:
                  snapshotPrenotazione.data as List<Prenotazione>,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
