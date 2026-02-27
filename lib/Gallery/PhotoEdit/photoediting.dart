import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class PhotoEdit extends StatefulWidget {
  final String imagePath;

  const PhotoEdit({super.key, required this.imagePath});

  @override
  State<PhotoEdit> createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  @override
  Widget build(BuildContext context) {
    return ProImageEditor.file(
      File(widget.imagePath),
      callbacks: ProImageEditorCallbacks(
        onCloseEditor: (mode) {
          Navigator.pop(context);
        },
        onImageEditingComplete: (Uint8List bytes) async {
          await _saveImage(bytes);
        },
      ),
    );
  }

  Future<void> _saveImage(Uint8List bytes) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await PhotoManager.editor.saveImage(
        bytes,
        filename: "edited_$timestamp.jpg",
        title: "edited_$timestamp",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save image: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
