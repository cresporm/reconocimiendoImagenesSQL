import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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

Future<List<Medicamento>> loadJsonData() async {
  String jsonString = await rootBundle.loadString('assets/medicamentos_info.json');
  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((item) => Medicamento.fromJson(item)).toList();
}

Future<Medicamento?> buscarMedicamento(String nombreBuscado) async {
  List<Medicamento> medicamentos = await loadJsonData();

  try {
    return medicamentos.firstWhere(
      (medicamento) => medicamento.nombre.toLowerCase() == nombreBuscado.toLowerCase(),
    );
  } catch (e) {
    return null; 
  }
}