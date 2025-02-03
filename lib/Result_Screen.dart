import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'recognition_service.dart';

class Medicamento {
  final String nombre;
  final String dosis;
  final String contraindicaciones;
  final String paraQueSirve;

  Medicamento({
    required this.nombre,
    required this.dosis,
    required this.contraindicaciones,
    required this.paraQueSirve,
  });

  factory Medicamento.fromJson(Map<String, dynamic> json) {
    return Medicamento(
      nombre: json['nombre'],
      dosis: json['dosis'],
      contraindicaciones: json['contraindicaciones'],
      paraQueSirve: json['para_que_sirve'],
    );
  }
}

Future<List<Medicamento>> loadMedicamentos() async {
  String jsonString = await rootBundle.loadString('assets/medicamentos_info.json');
  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((item) => Medicamento.fromJson(item)).toList();
}

Future<Medicamento?> buscarMedicamento(String nombreBuscado) async {
  List<Medicamento> medicamentos = await loadMedicamentos();
  try {
    return medicamentos.firstWhere(
      (med) => med.nombre.toLowerCase() == nombreBuscado.toLowerCase(),
    );
  } catch (e) {
    return null;
  }
}

class ResultScreen extends StatefulWidget {
  final File image;

  ResultScreen({required this.image});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<dynamic>? _recognitionResult;
  String? _recognizedLabel;
  Medicamento? _medicamentoEncontrado;
  bool _buscando = true;

  @override
  void initState() {
    super.initState();
    _runRecognition();
  }

  Future<void> _runRecognition() async {
    await RecognitionService.loadModel();
    List<dynamic>? result = await RecognitionService.runRecognition(widget.image.path);

    if (result != null && result.isNotEmpty) {
      setState(() {
        _recognitionResult = result;
        _recognizedLabel = result[0]["label"];
        
      });

      

      Medicamento? medicamento = await buscarMedicamento(_recognizedLabel?? "");
      setState(() {
        _medicamentoEncontrado = medicamento;
        _buscando = false;
      });
    } else {
      setState(() {
        _buscando = false;
      });
    }

    await RecognitionService.closeModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultado del Reconocimiento"),
      ),
      body: _buscando
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(widget.image, height: 200),
                  SizedBox(height: 20),
                  Text(
                    "Medicamento reconocido: ${_recognizedLabel ?? "Desconocido"}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  if (_recognitionResult != null)
                    ..._recognitionResult!.map((res) {
                      return Text(
                          "${res['label']} - Confianza: ${(res['confidence'] * 100).toStringAsFixed(2)}%");
                    }).toList(),

                  SizedBox(height: 20),

                 
                  _medicamentoEncontrado != null
                      ? Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("📌 Nombre: ${_medicamentoEncontrado!.nombre}",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text("💊 Dosis: ${_medicamentoEncontrado!.dosis}",
                                    style: TextStyle(fontSize: 16)),
                                Text("⚠️ Contraindicaciones: ${_medicamentoEncontrado!.contraindicaciones}",
                                    style: TextStyle(fontSize: 16)),
                                Text("📖 Para qué sirve: ${_medicamentoEncontrado!.paraQueSirve}",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        )
                      : Text(
                          "❌ Medicamento no encontrado en la base de datos.",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                ],
              ),
            ),
    );
  }
}
