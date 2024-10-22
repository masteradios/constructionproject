import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../screens/home/workerhomeScreen.dart';
import '../../showSnackBar.dart';
import '../upload_image_service.dart';
import 'adminHomeScreen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  static const routeName = '/add-product-screen';
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  Uint8List? image;
  String category = 'Fresh Fruits';
  String res = 'error';
  bool isLoading = false;

  void _selectImages() async {
    var imageDocs = await getImage(source: ImageSource.gallery);
    setState(() {
      image = imageDocs;
    });
  }

  void uploadImages() async {
    setState(() {
      isLoading = true;
    });
    res = await AdminServices().uploadProduct(
        context: context,
        desc: _productdescriptioncontroller.text.trim(),
        file: image!);
    if (res == 'Success') {
      setState(() {
        isLoading = false;
      });
      displaySnackBar(
          context: context, content: 'Uploaded today\'s work successfully!');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return WorkerHomePage();
      }), (route) => false);
    } else {
      setState(() {
        isLoading = false;
      });
      displaySnackBar(context: context, content: res);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _productdescriptioncontroller.dispose();
  }

  final _addProductkey = GlobalKey<FormState>();
  final TextEditingController _productnamecontroller = TextEditingController();
  final TextEditingController _productdescriptioncontroller =
      TextEditingController();
  final TextEditingController _productpricecontroller = TextEditingController();
  final TextEditingController _productquantitycontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (image == null)
                    ? GestureDetector(
                        onTap: _selectImages,
                        child: Center(
                          child: DottedBorder(
                              dashPattern: [6, 3, 6, 3],
                              borderPadding: EdgeInsets.all(10),
                              borderType: BorderType.RRect,
                              radius: Radius.circular(15),
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.folder),
                                      Text(
                                        'Select Image',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      )
                    : Image.memory(
                        image!,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                Form(
                    key: _addProductkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _productdescriptioncontroller,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Description',
                            ),
                          ),
                        ),
                      ],
                    )),
                (isLoading)
                    ? Container(
                        width: double.infinity,
                        height: 40,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Center(
                          child: const CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        child: Text('Upload'),
                        onPressed: () {
                          if (_addProductkey.currentState!.validate()) {
                            if (image == null) {
                              displaySnackBar(
                                  context: context,
                                  content: 'Add image of the product!!');
                            } else {
                              uploadImages();
                              print('Add Successful!');
                            }
                          }
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
