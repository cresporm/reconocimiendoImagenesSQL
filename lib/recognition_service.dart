import 'package:tflite_v2/tflite_v2.dart';

class RecognitionService {
  static Future<void> loadModel() async {
    try {
      String? result = await Tflite.loadModel(//assets para reconocerl
        model: "assets/model.tflite", 
        labels: "assets/labels.txt", 
      );
      print("Modelo cargado: $result");
    } catch (e) {
      print("Error al cargar el modelo: $e");
    }
  }

  static Future<List<dynamic>?> runRecognition(String imagePath) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: imagePath, 
        numResults: 5, 
        threshold: 0.5, 
        imageMean: 127.5, 
        imageStd: 127.5, 
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
