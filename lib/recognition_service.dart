import 'package:tflite_v2/tflite_v2.dart';

class RecognitionService {
  static Future<void> loadModel() async {
    try {
      String? result = await Tflite.loadModel(
        model: "assets/model.tflite", // Ruta del modelo
        labels: "assets/labels.txt", // Ruta de las etiquetas
      );
      print("Modelo cargado: $result");
    } catch (e) {
      print("Error al cargar el modelo: $e");
    }
  }

  static Future<List<dynamic>?> runRecognition(String imagePath) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: imagePath, // Ruta de la imagen
        numResults: 5, // Máximo de predicciones a devolver
        threshold: 0.5, // Umbral de confianza (ajustable)
        imageMean: 127.5, // Normalización (puedes ajustar si es necesario)
        imageStd: 127.5, // Normalización (puedes ajustar si es necesario)
      );
      return output;
    } catch (e) {
      print("Error al ejecutar el modelo: $e");
      return null;
    }
  }

  static Future<void> closeModel() async {
    await Tflite.close();
  }
}
