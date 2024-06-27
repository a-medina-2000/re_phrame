import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_fx/simple_fx.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
          builder: (context) => displayImage(_image))
    );
  }
}

class displayImage extends StatelessWidget {
  File? image;
  displayImage(this.image, {super.key});

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
                  },
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  child: const Icon(Icons.text_fields),
                  onPressed: () {
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
  BrightnessAdjustment(this.image, {super.key});

  @override
  State<BrightnessAdjustment> createState() => _BrightnessAdjustmentState(image);
}

class _BrightnessAdjustmentState extends State<BrightnessAdjustment>{
  double _brightValue = 0;
  double _hueValue = 180;
  double _saturationValue = 100;
  File? image;

  _BrightnessAdjustmentState(this.image) {
    image = this.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Brightness Settings'),
      ),
      bottomNavigationBar: ElevatedButton(
        child: Text('Apply Changes'),
        onPressed: () {
        },
      ),
      body: ListView(
        children: [
          SimpleFX(imageSource: Image.file(image!)),
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


}