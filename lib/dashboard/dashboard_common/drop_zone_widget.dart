import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:google_fonts/google_fonts.dart';

class DropZoneWidget extends StatelessWidget {
  final void Function(dynamic)? onDrop;
  final void Function(DropzoneViewController)? onCreated;
  final VoidCallback? iconPressed;
  final String? type;
  const DropZoneWidget(
      {Key? key, this.onDrop, this.onCreated, this.iconPressed, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DottedBorder(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: DropzoneView(
                onDrop: onDrop,
                onCreated: onCreated,
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: iconPressed,
                  icon: const Icon(
                    Icons.cloud_upload_rounded,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
                Text(
                  'Upload a $type',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  'Drag and drop file here',
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
