import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore
            .collection('votaciones')
            .where('status', isEqualTo: 'activa')
            .limit(1)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          bool isVotingActive =
              snapshot.hasData && snapshot.data!.docs.isNotEmpty;

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                width: size.width,
                height: 200,
                child: Container(
                  width: size.width,
                  height: size.height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    'VOTACIONES',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 200,
                width: size.width,
                height: size.height - 200,
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: isVotingActive
                              ? null
                              : () => _showCreateVoteDialog(context),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            width: 200,
                            decoration: BoxDecoration(
                              color:
                                  isVotingActive ? Colors.grey : Colors.indigo,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Crear Votación',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showVoteDialog(context),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Votar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showCloseVoteDialog(context),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Cerrar Votación',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showResults(context),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Resultados de la votación',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showResults(BuildContext context) async {
    QuerySnapshot votaciones = await _firestore.collection('votaciones').get();
    List<DocumentSnapshot> votacionesList = votaciones.docs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar Votación'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: votacionesList.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot votacion = votacionesList[index];
                return ListTile(
                  title: Text(votacion['title']),
                  onTap: () {
                    Navigator.pop(
                        context); // Cerrar el diálogo de selección de votación
                    _showVoteResults(context,
                        votacion); // Mostrar los resultados de la votación seleccionada
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showVoteResults(BuildContext context, DocumentSnapshot votacion) async {
    QuerySnapshot candidatosSnapshot =
        await votacion.reference.collection('candidates').get();
    List<DocumentSnapshot> candidatosList = candidatosSnapshot.docs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultados de la votación: ${votacion['title']}'),
          content: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: candidatosList.map((candidato) {
                return ListTile(
                  title: Text(candidato['name']),
                  subtitle: Text('Votos: ${candidato['votes']}'),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Cerrar el diálogo de resultados de votación
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateVoteDialog(BuildContext context) {
    final scaffoldContext = context;
    showDialog(
      context: scaffoldContext,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        final _titleController = TextEditingController();
        final List<TextEditingController> _candidateControllers = [];

        return AlertDialog(
          title: Text('Crear Votación'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título de la votación',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el título de la votación';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Ingrese los candidatos:'),
                    ..._candidateControllers.map((controller) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Candidato',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese un nombre de candidato';
                            }
                            return null;
                          },
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _candidateControllers.add(TextEditingController());
                        });
                      },
                      child: Text('Agregar Candidato'),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Manejar creación de votación con los candidatos
                  DocumentReference newVoteRef =
                      await _firestore.collection('votaciones').add({
                    'title': _titleController.text,
                    'status': 'activa',
                  });

                  for (var controller in _candidateControllers) {
                    await newVoteRef.collection('candidates').add({
                      'name': controller.text,
                      'votes': 0,
                    });
                  }

                  Navigator.of(scaffoldContext).pop();
                }
              },
              child: Text('Crear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(scaffoldContext).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showVoteDialog(BuildContext context) async {
    QuerySnapshot activeVotations = await _firestore
        .collection('votaciones')
        .where('status', isEqualTo: 'activa')
        .limit(1)
        .get();
    if (activeVotations.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay votaciones activas en este momento')));
      return;
    }

    DocumentSnapshot votacionDoc = activeVotations.docs.first;
    QuerySnapshot candidatesSnapshot =
        await votacionDoc.reference.collection('candidates').get();
    List<DocumentSnapshot> candidates = candidatesSnapshot.docs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        String? _selectedCandidate;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Votar'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Text('Seleccione su candidato:'),
                    ...candidates.map((candidate) {
                      return ListTile(
                        title: Text(candidate['name']),
                        leading: Radio<String>(
                          value: candidate
                              .id, // Use el ID del candidato como valor
                          groupValue: _selectedCandidate,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedCandidate = value;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedCandidate != null) {
                      // Actualizar el recuento de votos para el candidato seleccionado
                      votacionDoc.reference
                          .collection('candidates')
                          .doc(_selectedCandidate)
                          .update({'votes': FieldValue.increment(1)});
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Votar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCloseVoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Votación'),
          content: Text('¿Estás seguro de que deseas cerrar la votación?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Manejar cierre de votación
                QuerySnapshot activeVotations = await _firestore
                    .collection('votaciones')
                    .where('status', isEqualTo: 'activa')
                    .get();
                if (activeVotations.docs.isNotEmpty) {
                  for (var doc in activeVotations.docs) {
                    await doc.reference.update({'status': 'cerrada'});
                  }
                }
                print('Votación cerrada');
                Navigator.of(context).pop();
              },
              child: Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
