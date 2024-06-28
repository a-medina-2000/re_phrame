import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:simple_fx/simple_fx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:image_painter/image_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'RePhrame'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? _image;
  final pick = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Select an image.'),
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: selectPicture,
        tooltip: 'Selected Image',
        child: const Icon(Icons.image),
      ),

    );
  }

  Future selectPicture() async {
    final selectedImage = await pick.pickImage(source: ImageSource.gallery);

    setState(() {
      if (selectedImage != null) {
        _image = File(selectedImage.path);
      }
    }
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DisplayImage(_image))
    );
  }
}

class DisplayImage extends StatelessWidget {
  File? image;
  DisplayImage(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Image - Main Menu'),
      ),
      body: ListView(
        children: [
              image?.path == null ? const Text('No img'): Image.file(image!),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Icon(Icons.lightbulb),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BrightnessAdjustment(image))
                    );
                  },
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  child: const Icon(Icons.draw),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrawOverImage(image))
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BrightnessAdjustment extends StatefulWidget {
  File? image;
  late Uint8List? editedImage;

  BrightnessAdjustment(this.image, {super.key});

  @override
  State<BrightnessAdjustment> createState() => _BrightnessAdjustmentState(image);
}

class _BrightnessAdjustmentState extends State<BrightnessAdjustment> {

  double _brightValue = 0;
  double _hueValue = 0;
  double _saturationValue = 100;

  late Uint8List? editedImage;
  File? image;

  ScreenshotController screenshotController = ScreenshotController();

  _BrightnessAdjustmentState(this.image) {
    image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Brightness Settings'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            child: const Text('Save Edits'),
              onPressed: () {
              screenshotController.capture().then((edit) {
                setState(() {
                  editedImage = edit!;
                });
              });
              }
          ),
          ElevatedButton(
              onPressed: _saveLocalImage,
              child: const Text('Send to Gallery'),
          ),
          Screenshot(
              controller: screenshotController,
              child: Stack(
                children: [
                  SimpleFX(imageSource: Image.file(image!),
                    hueRotation: _hueValue,
                    brightness: _brightValue,
                    saturation: _saturationValue,
                  ),
                ],
              )
          ),
          Row(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Slider(
                      min: -100.0,
                      max: 100.0,
                      value: _brightValue,
                      onChanged: (value) {
                        setState(() {
                          _brightValue = value;
                        });
                      },
                    ),
                    const Text('Brightness'),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    Slider(
                      min: -360.0,
                      max: 360.0,
                      value: _hueValue,
                      onChanged: (value) {
                        setState(() {
                          _hueValue = value;
                        });
                      },
                    ),
                    const Text('Hue'),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: [
                    Slider(
                      min: 0.0,
                      max: 100.0,
                      value: _saturationValue,
                      onChanged: (value) {
                        setState(() {
                          _saturationValue = value;
                        });
                      },
                    ),
                    const Text('Saturation'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  _saveLocalImage() async {
    Gal.putImageBytes(editedImage!);
    }
}

class DrawOverImage extends StatefulWidget {
  File? image;
  late Uint8List? editedImage;

  final imagePainterController = ImagePainterController();

  ScreenshotController screenshotController = ScreenshotController();

  DrawOverImage(this.image, {super.key});

  @override
  State<DrawOverImage> createState() => _DrawOverImageState(image);
}

class _DrawOverImageState extends State<DrawOverImage> {
  File? image;
  late Uint8List? editedImage;

  final imagePainterController = ImagePainterController();

  ScreenshotController screenshotController = ScreenshotController();

  _DrawOverImageState(this.image) {
    image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Text Settings'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
              child: const Text('Save Edits'),
              onPressed: () {
                screenshotController.capture().then((edit) {
                  setState(() {
                    editedImage = edit!;
                  });
                });
              }
          ),
          ElevatedButton(
              onPressed: _sendToGallery,
              child: const Text('Send to Gallery')
          ),
          Stack(
                children: <Widget>[
                  Screenshot(
                      controller: screenshotController,
                      child: Column(
                        children: [
                          Image.file(image!),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextField(
                            decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            ),
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
  void _sendToGallery() async {
    Gal.putImageBytes(editedImage!);
  }
}

