import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'overlayedWidget.dart';

class Story extends StatefulWidget {
  const Story({Key? key}) : super(key: key);

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  List<Widget> _addedWidgets = [];
  bool _showDeleteButton = false;
  bool _isDeleteButtonActive = false;
  List<File> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Story"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImageFromGallery,
        child: Icon(Icons.add),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.black),
          ),
          ..._addedWidgets,
          if (_showDeleteButton)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Icon(
                  Icons.delete,
                  size: _isDeleteButtonActive ? 38 : 28,
                  color: _isDeleteButtonActive ? Colors.red : Colors.white70,
                ),
              ),
            )
        ],
      ),
    );
  }

  void _pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        File selectedImageFile = File(pickedImage.path);
        _selectedImages.add(selectedImageFile);

        _addedWidgets.add(
          OverlayedWidget(
            key: Key(_selectedImages.length.toString()),
            child: Image.file(
              selectedImageFile,
              fit: BoxFit.cover,
            ),
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

              if (offset.dy > (MediaQuery.of(context).size.height - 100)) {
                _addedWidgets.removeWhere((widget) => widget.key == key);
              }
            },
            onDragUpdate: (offset, key) {
              if (offset.dy > (MediaQuery.of(context).size.height - 100)) {
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
          ),
        );
      });
    }
  }
}
