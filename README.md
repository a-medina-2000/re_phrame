# RePhrame

RePhrame is a gallery app that edits images received from mobile devices.

## Installation

After downloading all of the files, simply run main.dart within the lib folder.
After performing image edits, be sure to hit 'Save Edits' and afterwards, hit 'Send to Gallery' to ensure
that the edits are applied to the image before the new image is sent to the photo gallery.


## Usage

```dart
// stateful widget class that handles image selection
MyHomePage();

// function that opens gallery and returns a selected image to file
selectPicture();

// stateless widget class that handles the displaying of an image
DisplayImage();

// stateful widget class that handles the brightness settings users can modify
BrightnessAdjustment();

// stateful widget class that handles the text display over an image
DrawOverImage();

// returns edited image to gallery within Brightness Settings Page
_saveLocalImage();

// returns edited image to gallery from Text Settings Page
_saveEdits();
```