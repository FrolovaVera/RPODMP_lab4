import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/services.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'lab4',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  late ArCoreController arCoreController;

  _onArCoreViewCreated(ArCoreController controller){
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);//onNodeTap : вызывается, когда мы касаемся узла на экране, аргументом является имя узла
    arCoreController.onPlaneTap = _onPlaneTapHandler;//onPlaneTap: вызывается, когда мы касаемся точки на плоскости, автоматически определяемой, аргумент представляет собой список ArCoreHitTestResult.
  }

  void onTapHandler(String name) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('onNodeTap on $name')),
    );
  }

  void _onPlaneTapHandler(List<ArCoreHitTestResult> hits) async{
    final ByteData textureBytes = await rootBundle.load('asserts/moon1.jpg');
    //final hit = hits.first;
    final material = ArCoreMaterial(
        color: Colors.black54, metallic: 1, roughness: 0.1,reflectance: 0.8, textureBytes: textureBytes.buffer.asUint8List());
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.15,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(-0.08, -1.5, -1.5),
    );
    arCoreController.addArCoreNodeWithAnchor(node);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ARKit'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,//вызывается при создании собственного представления платформы.
        enableTapRecognizer: true,//прослушивание экрана на касание
      ),
    );
  }
}
