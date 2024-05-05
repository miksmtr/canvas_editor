import 'dart:io';
import 'package:example/overlayedWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Story extends StatefulWidget {
  const Story({super.key});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  List<Widget> _addedWiggets = [];

  bool _showDeleteButton = false;
  bool _isDeleteButtonActive = false;
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Story"),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_addedWiggets.length < _dummyWidgets.length) {
              setState(() {
                _addedWiggets.add(OverlayedWidget(
                  key: Key(_addedWiggets.length.toString()),
                  child: _dummyWidgets.elementAt(_addedWiggets.length),
                  onDragStart: () {
                    if (!_showDeleteButton) {
                      setState(() {
                        _showDeleteButton = true;
                      });
                    }
                  },
                  onDragEnd: (offset, key) {
                    if (_showDeleteButton) {
                      setState(() {
                        _showDeleteButton = false;
                      });
                    }

                    if (offset.dy >
                        (MediaQuery.of(context).size.height - 100)) {
                      _addedWiggets.removeWhere((widget) => widget.key == key);
                    }
                  },
                  onDragUpdate: (offset, Key) {
                    if (offset.dy >
                        (MediaQuery.of(context).size.height - 100)) {
                      if (!_isDeleteButtonActive) {
                        setState(() {
                          _isDeleteButtonActive = true;
                        });
                      }
                    } else {
                      if (_isDeleteButtonActive) {
                        setState(() {
                          _isDeleteButtonActive = false;
                        });
                      }
                    }
                  },
                ));
              });
            }
          },
          child: Icon(Icons.add),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.black),
            ),
            for (int i = 0; i < _addedWiggets.length; i++) _addedWiggets[i],
            if (_showDeleteButton)
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Icon(
                      Icons.delete,
                      size: _isDeleteButtonActive ? 38 : 28,
                      color:
                          _isDeleteButtonActive ? Colors.red : Colors.white70,
                    ),
                  ))
          ],
        ));
  }

  final List<Widget> _dummyWidgets = [
    SizedBox(
      width: 150,
      height: 150,
      child: Image.asset(
        'assets/happy.png',
        fit: BoxFit.cover,
      ),
    ),
    SizedBox(
      width: 150,
      height: 150,
      child: Image.asset(
        'assets/sad-face.png',
        fit: BoxFit.cover,
      ),
    ),
    SizedBox(
      width: 150,
      height: 150,
      child: Image.asset(
        'assets/verified.png',
        fit: BoxFit.cover,
      ),
    ),
  ];

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
  }
}
