import 'package:flutter/material.dart';
import 'dart:io';
import 'recognition_service.dart';

class ResultScreen extends StatefulWidget {
  final File image;

  ResultScreen({required this.image});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<dynamic>? _recognitionResult;
  String? _recognizedLabel;

  @override
  void initState() {
    super.initState();
    _runRecognition();
  }

  Future<void> _runRecognition() async {
    // Cargar el modelo
    await RecognitionService.loadModel();

    // Ejecutar el modelo en la imagen seleccionada
    List<dynamic>? result =
    await RecognitionService.runRecognition(widget.image.path);

    if (result != null && result.isNotEmpty) {
      setState(() {
        _recognitionResult = result;
        _recognizedLabel = result[0]["label"]; // La etiqueta con mayor confianza
      });
    }

    // Cerrar el modelo (opcional, para liberar recursos)
    await RecognitionService.closeModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultado del Reconocimiento"),
      ),
      body: _recognitionResult == null
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
          ],
        ),
      ),
    );
  }
}



