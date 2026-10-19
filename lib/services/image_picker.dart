import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

class UploadImages extends StatefulWidget {

  final Function (File imageUrl) onFileChanged;

  UploadImages({super.key, required this.onFileChanged});

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {

    final ImagePicker _picker = ImagePicker();
    File? imageUrl;

    @override
  Widget build(BuildContext context) {

    Color? borderColor = Theme.of(context).primaryColor == Colors.black54 ? Colors.white : Colors.black45;

    return Column(
      children: [
        if(imageUrl == null)
          InkWell(
            onTap: () => _selectPhoto(),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  )
                ),
                child: SizedBox(
                  height: 88,
                  width: 150,
                  child: Image.network('https://cdn-icons-png.flaticon.com/512/8334/8334879.png',),
                ),
              ),
            ),
          ),
        if(imageUrl != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectPhoto(),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: 92,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: borderColor,
                ),
              ),
              child: Image.file(
                  imageUrl!,
                  fit: BoxFit.cover
              ),
            )
          ),

      ],
    );


  }
  Future _selectPhoto() async {
    await showModalBottomSheet(context: context, builder: (context) => BottomSheet(
        onClosing: (){},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: (){
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image_search_outlined),
              title: Text('Gallery'),
              onTap: (){
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
        )
    ));
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 50);

    if(pickedFile == null){
      return;
    }

    ImageCropper _cropper = ImageCropper();
    var file = await _cropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2)
    );

    if (file ==null){
      return;
    }

    String compressedImage = await compressImage(file.path, 44) ;

    setState(() {
      imageUrl = File(compressedImage);
    });

    widget.onFileChanged(imageUrl!);


  }

  Future<String> compressImage(String path, int quality) async {
    final newPath = p.join((await getTemporaryDirectory()).path, '${DateTime.now()}.${p.extension(path)}');

    final result = await FlutterImageCompress.compressAndGetFile(
        path,
        newPath,
      quality: quality
    );


    return result!.path;
  }
}