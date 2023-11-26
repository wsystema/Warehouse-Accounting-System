import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warehouse_accounting_systems/model/product.dart';
import 'package:warehouse_accounting_systems/runner/app.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:warehouse_accounting_systems/screens/participants_list_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen(
      {super.key, required this.docId, required this.admin});

  final String docId;

  final bool admin;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _nameController = TextEditingController();
  final _numberOfUnits = TextEditingController();
  final _price = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.goodsInStock),
        actions: widget.admin
            ? [
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ParticipantsListScreen(docId: widget.docId))),
                    icon: const Icon(Icons.supervised_user_circle_rounded))
              ]
            : [],
      ),
      body: SafeArea(
        child: Center(
            child: Stack(
          children: [
            StreamBuilder<List<ProductFromMap>>(
                stream: productStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data![index];
                          return Container(
                            height: 200,
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(
                                    3,
                                    3,
                                  ),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    height: 180,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),

                                    ),
                                    child: PageView.builder(
                                        itemCount: data.images.length,
                                        itemBuilder: (context, index) {
                                          return Image.network(
                                            data.images[index],
                                            fit: BoxFit.cover,
                                          );
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        data.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        ' ${data.price}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),

                                      ),
                                      Text(
                                        data.sender,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),

                                      ),
                                      Text(
                                        ' ${data.numberOfUnits}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        data.id,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      ElevatedButton.icon(
                                          onPressed: () => deleteProduct(
                                                  widget.docId, data.docId)
                                              .then((value) =>
                                                  showProductDeleteComplete()),
                                          icon: const Icon(Icons.remove),
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .delete)),
                                      ElevatedButton.icon(
                                          onPressed: ()  {
                                            showUpdateDialog(data);
                                          },
                                          icon:
                                              const Icon(Icons.refresh_rounded),
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .refresh)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return CircularProgressIndicator();
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FillTheProduct(docId: widget.docId))),
                      child: Text(AppLocalizations.of(context)!.addProduct)),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  Stream<List<ProductFromMap>> productStream() async* {
    yield* FirebaseFirestore.instance
        .collection('warehouse')
        .doc(widget.docId)
        .collection('product')
        .snapshots()
        .asyncMap((event) => event.docs
            .map((e) => ProductFromMap.fromMap(e.data(), e.id))
            .toList());
  }

  Future<void> updateProduct(ProductFromMap productFromMap) async {
    final collection = FirebaseFirestore.instance
        .collection('warehouse')
        .doc(widget.docId)
        .collection('product')
        .doc(productFromMap.docId)
        .update({
      'name': _nameController.text,
      'numberOfUnits': int.parse(_numberOfUnits.text),
      'price': int.parse(_price.text)
    }).then((value) {
      showUpdateCompleted();
      _nameController.clear();
      _price.clear();
      _numberOfUnits.clear();
      Navigator.pop(context);
    });
  }

  void showUpdateCompleted() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.updateCompleted)));
  }

  void showUpdateDialog(ProductFromMap productFromMap) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _key,
            child: SingleChildScrollView(
              child: AlertDialog(
                icon: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.exit_to_app)),
                title: Text(AppLocalizations.of(context)!.updateProduct),
                actions: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.name),
                    validator: (value) =>
                        _validation(value, AppLocalizations.of(context)!.name),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _numberOfUnits,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) => _validation(value,
                        AppLocalizations.of(context)!.pleaseEnterNumberOfUnits),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.numberOfUnits),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) => _validation(
                        value, AppLocalizations.of(context)!.pleaseEnterPrice),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.price),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          updateProduct(productFromMap);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.updateProduct))
                ],
              ),
            ),
          );
        });
  }

  String? _validation(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }

  void showProductDeleteComplete() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.productDeleteComplete)));
  }

  Future<void> deleteProduct(String warehouseId, String docId) async {
    await FirebaseFirestore.instance
        .collection('warehouse')
        .doc(warehouseId)
        .collection('product')
        .doc(docId)
        .delete();
  }
}

class FillTheProduct extends StatefulWidget {
  const FillTheProduct({super.key, required this.docId});

  final String docId;

  @override
  State<FillTheProduct> createState() => _FillTheProductState();
}

class _FillTheProductState extends State<FillTheProduct> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _numberOfUnitsController = TextEditingController();
  final _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<File>? listFile;
  List<String> imageURL = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.enterProductParameters),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (listFile != null)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listFile!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                listFile![index],
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                    ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.name),
                    validator: (value) => _validation(
                        value, AppLocalizations.of(context)!.pleaseEnterName),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _numberOfUnitsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.numberOfUnits),
                    validator: (value) => _validation(value,
                        AppLocalizations.of(context)!.pleaseEnterNumberOfUnits),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: AppLocalizations.of(context)!.price),
                    validator: (value) => _validation(
                        value, AppLocalizations.of(context)!.pleaseEnterPrice),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLines: 5,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.description),
                    validator: (value) => _validation(value,
                        AppLocalizations.of(context)!.pleaseEnterDescription),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => getImages(),
                        child: Text(AppLocalizations.of(context)!.addImages)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate() ||
                                    listFile != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (listFile == null) {
                                    setState(() {
                                      isLoading = false;
                                      showPleaseSelectImage();
                                    });
                                  }
                                  await postImage(listFile!)
                                      .then((value) async {
                                    showImageCompleted();
                                    await addProduct().then((value) {
                                      setState(() {
                                        showProductCompleted();
                                        isLoading = false;
                                      });
                                    });
                                  });
                                } else if (listFile == null) {
                                  showPleaseSelectImage();
                                }
                              },
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Text(AppLocalizations.of(context)!.addProduct)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showPleaseSelectImage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.pleaseSelectImage)));
  }

  void showImageCompleted() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context)!.loadingOfImagesIsCompleted)));
  }

  void showProductCompleted() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.productAdded)));
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context)!.thereWasAnErrorSendingImages)));
  }

  Future<void> postImage(List<File> imageList) async {
    try {
      for (var i = 0; i < imageList.length; i++) {
        final ref = FirebaseStorage.instance
            .ref('images/${imageList[i].path} ${Random.secure()}');

        await ref.putFile(
            imageList[i], SettableMetadata(contentType: 'images/jpeg'));

        final imageId = await ref.getDownloadURL();

        setState(() {
          imageURL.add(imageId);
          isLoading = true;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      showError();
    } finally {}
  }

  Future<void> getImages() async {
    try {
      ///  Result are files from devices
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg']);

      if (result != null) {
        List<File> files = result.paths.map((e) => File(e!)).toList();

        setState(() {
          listFile = files;
        });
      } else {}
    } catch (e) {
      return Future.error(e);
    }
  }

  String? _validation(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }

  Future<void> addProduct() async {
    setState(() {
      isLoading = true;
    });
    CollectionReference warehouseCollection =
        FirebaseFirestore.instance.collection('warehouse');
    final user = FirebaseAuth.instance.currentUser!;
    final email = user.email;
    warehouseCollection.doc(widget.docId).collection('product').add(Product(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            sender: email!,
            id: generateUniqueId(),
            images: imageURL,
            numberOfUnits: int.parse(_numberOfUnitsController.text),
            price: int.parse(_priceController.text))
        .toMap());
  }

  String generateUniqueId() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random = Random().nextInt(999999);
    String uniqueId = '$timestamp$random';

    return uniqueId;
  }
}
