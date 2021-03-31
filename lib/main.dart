import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:qr_mobile_vision/qr_barcode.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';
import 'package:vision_demo/barcode_detctor_painter.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(new HomePage());
}

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool camState = false;
  List<Barcode> barcode = List<Barcode>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            camState
                ? new SizedBox(
                    width: 300,
                    height: 600,
                    child: Stack(
                      children: [
                        new QrCamera(
                          onError: (context, error) => Text(
                            error.toString(),
                            style: TextStyle(color: Colors.red),
                          ),
                          qrCodeCallback: (code) {
                            setState(() {
                              barcode = code;
                            });
                          },
                          child: new Container(
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        _buildResults()
                      ],
                    ),
                  )
                : Expanded(child: new Center(child: new Text("Camera inactive"))),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Text(
            "press me",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            setState(() {
              camState = !camState;
            });
          }),
    );
  }

  Widget _buildResults() {
    if (barcode == null) {
      return Container();
    }

    CustomPainter painter;
    if (QrMobileVision.previewDetails != null) {
      final Size imageSize = Size(double.parse(QrMobileVision.previewDetails.height.toString()), double.parse(QrMobileVision.previewDetails.width.toString()));

      if (barcode is! List<Barcode>) return Container();
      painter = BarcodeDetectorPainter(imageSize, barcode);
      return CustomPaint(
        size: Size(double.maxFinite, double.maxFinite),
        painter: painter,
      );
    } else {
      return Container();
    }
  }
}
