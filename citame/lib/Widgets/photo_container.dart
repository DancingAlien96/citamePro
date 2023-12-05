import 'dart:io';
import 'package:citame/providers/img_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EspacioParaSubirFotoDeNegocio extends ConsumerWidget {
  EspacioParaSubirFotoDeNegocio({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String ruta = ref.watch(imgProvider);

    Future pickImageFromGallery() async {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      var comprimida = await FlutterImageCompress.compressAndGetFile(
          returnedImage!.path, '${returnedImage.path}compressed.jpg',
          minHeight: 640, minWidth: 480, quality: 10);

      if (comprimida != null) {
        final camino = comprimida.path;
        ref.watch(imgProvider.notifier).changeState(camino);
      }
    }

    Future pickImageFromCamera() async {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      var comprimida = await FlutterImageCompress.compressAndGetFile(
          returnedImage!.path, '${returnedImage.path}compressed.jpg',
          minHeight: 640, minWidth: 480, quality: 10);

      if (comprimida != null) {
        final camino = comprimida.path;
        ref.watch(imgProvider.notifier).changeState(camino);
      }
    }

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.amber,
      ),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: /*Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red,
                border: Border.all(width: 5),
              ),*/
                ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ruta != ''
                  ? Image.file(
                      File(ruta),
                      width: double.infinity,
                      height: 230,
                      fit: BoxFit.cover,
                    )
                  : Text('Sube una imagen prro'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    //TODO: Anthony va a ver como incluir la foto del negocio
                    pickImageFromGallery();
                  },
                  child: Text('Subir imagen'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    //TODO: Anthony va a ver como incluir la foto del negocio
                    pickImageFromCamera();
                  },
                  child: Text('Tomar foto'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
