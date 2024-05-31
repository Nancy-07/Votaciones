import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          width: size.width,
          height: 200,
          child: Container(
            width: size.width,
            height: size.height,
            alignment: Alignment
                .center, // Alineando el contenido en el centro del contenedor
            decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Text(
              'VOTACIONES',
              style: TextStyle(color: Colors.white, fontSize: 30),
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
                    onTap: () => _showCreateVoteDialog(context),
                    child: Container(
                      padding: EdgeInsets.all(16),width: 200,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('Crear Votación',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showVoteDialog(context),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('Votar',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showCloseVoteDialog(context),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('Cerrar Votación',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showResults(context),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('Resultados de la votación',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  void _showResults(BuildContext context){
    showDialog(context: context, builder:(BuildContext context){
        return AlertDialog(
          content: Container(alignment: Alignment.center,
          child: Text('Este es una prueba'),),
        );
    });
  }

  void _showCreateVoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
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
                    Text('Ingrese los candidatos:'),
                    ..._candidateControllers.map((controller) {
                      return TextFormField(
                        controller: controller,
                        decoration: InputDecoration(labelText: 'Candidato'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese un nombre de candidato';
                          }
                          return null;
                        },
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Manejar creación de votación con los candidatos
                  _candidateControllers.forEach((controller) {
                    print('Candidato: ${controller.text}');
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Crear'),
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
  }

  void _showVoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        final List<String> candidates = [
          'Candidato 1',
          'Candidato 2',
          'Candidato 3'
        ];
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
                        title: Text(candidate),
                        leading: Radio<String>(
                          value: candidate,
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
                      // Manejar el envío de la votación

                      print('Candidato elegido: $_selectedCandidate');
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
              onPressed: () {
                // Manejar cierre de votación
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

