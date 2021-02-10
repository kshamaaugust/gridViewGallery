// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:async/async.dart';
// import 'package:path/path.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:() {
//          Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AddPhotos(),
//           ),
//         );
//       },
//         // tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), 
//     );
//   }
// }

// class AddPhotos extends StatefulWidget {
//   @override
//   _AddPhotosState createState() => _AddPhotosState();
// }

// class _AddPhotosState extends State<AddPhotos> {
//   File _image;
//   bool isLoading = false, galleryButton = false;
//   double height;
//   final storage = new FlutterSecureStorage();

//   List<int> _selectedIndexList = List();
//   bool _selectionMode = false;

//   List<AssetEntity> assets = [];
//   _fetchAssets() async {
//     final albums = await PhotoManager.getAssetPathList(onlyAll: true);
//     final recentAlbum = albums.first;
//     final recentAssets = await recentAlbum.getAssetListRange(
//       start: 0, // start at index 0
//       end: 100, // end at a very big index (to get all the assets)
//     );
//     setState(() {
//       print("PRinting recent assets is....");
//       print(assets.runtimeType);
//       return assets = recentAssets;
//     });
//     setState(() {
//       print(assets);
//     });
//   }

//   updateProfilePicture(File imageFile) async { 
//     print("API IS callinggggggggggggg");
//     var authToken  = await storage.read(key: 'authtoken');
//     var token  = json.decode(authToken);
//     print("printing imagefile in api calling time is...");
//     print(imageFile);

//     var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//     var length = await imageFile.length();
//     var uri = Uri.parse("http://18.219.69.106/dating-app/public/api/users/update-profile-picture");
//     Map<String, String> headers = { "Authorization": "Bearer " +token ,  "Accept": "application/json"};
//     var request = new http.MultipartRequest("POST", uri);

//     request.headers.addAll(headers);
//     var multipartFile = new http.MultipartFile('image[]', stream, length,
//       filename: basename(imageFile.path));

//     request.files.add(multipartFile);
//     var response = await request.send();
//     print(response.statusCode);
//     response.stream.transform(utf8.decoder).listen((value) {
//       print("hellooo");
//       print(value); 
//     });
//     if(response.statusCode == 200){
//       print("Successful....");
//       // Navigator.pushReplacement(  
//       //   this.context,  
//       //   MaterialPageRoute(builder: (context) => HomePage()),  
//       // );
//     }
//     var status  = (request.fields['status']);
//     print(status);
//     setState(() { token; request.fields; });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     height = AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: new IconThemeData(color: Color(0xFFFEA085)),
//         title: Text(
//           "Add Photos",
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(25),
//           child: Stack(children: [
//             Column(children: [
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   style: TextStyle(color: Color(0xFF0ABBB0)),
//                   text: "addPhotosText",
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 35),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.camera),
//                       color: galleryButton ? Color(0xFFFEA085) : Color(0xFF424242),
//                       onPressed: () async{
//                         final permitted = await PhotoManager.requestPermission();
//                         if (!permitted) return;
//                         _fetchAssets();
//                         // _imgFromGallery();
//                         setState(() {
//                           galleryButton =!galleryButton;
//                         });
//                       },
//                     ),
//                 ]),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               (assets != null)
//               ? Container(
//                 height: MediaQuery.of(context).size.height *.55,
//                 child: GridView.builder(
//                   scrollDirection: Axis.vertical,
//                   shrinkWrap: true,
//                   physics: ScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisSpacing: 15, 
//                     mainAxisSpacing: 15,
//                     crossAxisCount: 3,
//                   ),
//                   itemCount: assets.length,
//                   itemBuilder: (_, index) {
//                     debugPrint(assets[index].id);
//                     // return AssetThumbnail(asset: assets[index]);
//                     return getGridTile(index);
//                   },
//                 ),
//               )
//               : Container(
//                 color: Colors.red,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
//                 child: FlatButton(
//                   // isbordered: false,
//                   color: Color(0xFFEC77B6),
//                   onPressed: () {
//                     updateProfilePicture(File(_image.path));
//                     setState(() {
//                       isLoading = true;
//                     });
//                   },
//                   child: Text('Done'),
//                 ),
//               ),
//               Center(child: isLoading? CircularProgressIndicator(): 
//                 Text("")),
//             ]),
//             FutureBuilder(
//             // asset = assets[index];
//       future: asset.thumbData,
//       builder: (_, snapshot) {
//         final bytes = snapshot.data;
//         // If we have no data, display a spinner
//         if (bytes == null) return CircularProgressIndicator();
//         // If there's data, display it as an image
//         return InkWell(
//           onTap: () {
//             if (asset.type == AssetType.image) {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (_) => ImageScreen(imageFile: asset.file),
//               //   ),
//               // );
//               print("Assets file in assectthumbnail file is");
//               // print(asset.file);
//             }
//           },
//           child: Stack(
//             children: [
//               // Wrap the image in a Positioned.fill to fill the space
//               Positioned.fill(
//                 child: Image.memory(bytes, fit: BoxFit.cover),
//               ),
//               // Display a Play icon if the asset is a video
//               if (asset.type == AssetType.video)
//                 Center(
//                   child: Container(
//                     color: Colors.blue,
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     ),
//           ]),
//         ),
//       ),
//     );
//   }
//   void _changeSelection({bool enable, int index}) {
//     print("Chnageselection calling.....");
//     _selectionMode = enable;
//     _selectedIndexList.add(index);
//     if (index == -1) {
//       _selectedIndexList.clear();
//     }
//   }

//   GridTile getGridTile(int index) {
//     print("Gridtile calling......");
//     if (_selectionMode) {
//       print("If calling...");
//       return GridTile(
//           header: GridTileBar(
//             leading: Icon(
//               _selectedIndexList.contains(index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
//               color: _selectedIndexList.contains(index) ? Colors.green : Colors.black,
//             ),
//           ),
//           child: GestureDetector(
//             // child: Container(
//             //   decoration: BoxDecoration(border: Border.all(color: Colors.blue[50], width: 30.0)),
//             //   child: Image.network(
//             //     'https://picsum.photos/800/600/?image=280',
//             //     // assets[index],
//             //     fit: BoxFit.cover,
//             //   ),
//             // ),
//             onLongPress: () {
//               setState(() {
//                 _changeSelection(enable: false, index: -1);
//               });
//             },
//             onTap: () {
//               setState(() {
//                 if (_selectedIndexList.contains(index)) {
//                   _selectedIndexList.remove(index);
//                 } else {
//                   _selectedIndexList.add(index);
//                 }
//               });
//             },
//           ));
//     } else {
//       print("Else calling....");
//       return GridTile(
//         child: InkResponse(
//           // child: Image.network(
//           //   'https://picsum.photos/800/600/?image=283',
//           //   fit: BoxFit.cover,
//           // ),
//           onLongPress: () {
//             setState(() {
//               _changeSelection(enable: true, index: index);
//             });
//           },
//         ),
//       );
//     }
//   }
// }

// class AssetThumbnail extends StatelessWidget {
//   const AssetThumbnail({
//     Key key,
//     @required this.asset,
//   }) : super(key: key);

//   final AssetEntity asset;

//   @override
//   Widget build(BuildContext context) {
//     // We're using a FutureBuilder since thumbData is a future
//     return FutureBuilder(
//       future: asset.thumbData,
//       builder: (_, snapshot) {
//         final bytes = snapshot.data;
//         // If we have no data, display a spinner
//         if (bytes == null) return CircularProgressIndicator();
//         // If there's data, display it as an image
//         return InkWell(
//           onTap: () {
//             if (asset.type == AssetType.image) {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (_) => ImageScreen(imageFile: asset.file),
//               //   ),
//               // );
//               print("Assets file in assectthumbnail file is");
//               print(asset.file);
//             }
//           },
//           child: Stack(
//             children: [
//               // Wrap the image in a Positioned.fill to fill the space
//               Positioned.fill(
//                 child: Image.memory(bytes, fit: BoxFit.cover),
//               ),
//               // Display a Play icon if the asset is a video
//               if (asset.type == AssetType.video)
//                 Center(
//                   child: Container(
//                     color: Colors.blue,
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class ImageScreen extends StatelessWidget {
//   const ImageScreen({
//     Key key,
//     @required this.imageFile,
//   }) : super(key: key);

//   final Future<File> imageFile;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       alignment: Alignment.center,
//       child: FutureBuilder<File>(
//         future: imageFile,
//         builder: (_, snapshot) {
//           final file = snapshot.data;
//           print("Printing file in imagescreen file is.......");
//           print(file);
//           if (file == null) return Container();
//           return Image.file(file);
//         },
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:multi_image_picker/multi_image_picker.dart';

// void main() => runApp(new MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   List<Asset> images = List<Asset>();
//   String _error;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Widget buildGridView() {
//     if (images != null)
//       return GridView.count(
//         crossAxisCount: 3,
//         children: List.generate(images.length, (index) {
//           Asset asset = images[index];
//           return AssetThumb(
//             asset: asset,
//             width: 300,
//             height: 300,
//           );
//         }),
//       );
//     else
//       return Container(color: Colors.white);
//   }

//   Future<void> loadAssets() async {
//     setState(() {
//       images = List<Asset>();
//     });

//     List<Asset> resultList;
//     String error;

//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 300,
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       images = resultList;
//       if (error == null) _error = 'No Error Dectected';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Center(child: Text('Error: $_error')),
//             RaisedButton(
//               child: Text("Pick images"),
//               onPressed: loadAssets,
//             ),
//             Expanded(
//               child: buildGridView(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _imageList = List();
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> _buttons = List();
    if (_selectionMode) {
      _buttons.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _selectedIndexList.sort();
            print('Delete ${_selectedIndexList.length} items! Index: ${_selectedIndexList.toString()}');
          }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: _buttons,
      ),
      body: _createBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _imageList.add('https://picsum.photos/800/600/?image=280');
    _imageList.add('https://picsum.photos/800/600/?image=281');
    _imageList.add('https://picsum.photos/800/600/?image=282');
    _imageList.add('https://picsum.photos/800/600/?image=283');
    _imageList.add('https://picsum.photos/800/600/?image=284');
  }

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  Widget _createBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      primary: false,
      itemCount: _imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return getGridTile(index);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: const EdgeInsets.all(4.0),
    );
  }

  GridTile getGridTile(int index) {
    if (_selectionMode) {
      return GridTile(
          header: GridTileBar(
            leading: Icon(
              _selectedIndexList.contains(index) ? Icons.check_circle_outline : Icons.radio_button_unchecked,
              color: _selectedIndexList.contains(index) ? Colors.green : Colors.black,
            ),
          ),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blue[50], width: 30.0)),
              child: Image.network(
                _imageList[index],
                fit: BoxFit.cover,
              ),
            ),
            onLongPress: () {
              setState(() {
                _changeSelection(enable: false, index: -1);
              });
            },
            onTap: () {
              setState(() {
                if (_selectedIndexList.contains(index)) {
                  _selectedIndexList.remove(index);
                } else {
                  _selectedIndexList.add(index);
                }
              });
            },
          ));
    } else {
      return GridTile(
        child: InkResponse(
          child: Image.network(
            _imageList[index],
            fit: BoxFit.cover,
          ),
          onLongPress: () {
            setState(() {
              _changeSelection(enable: true, index: index);
            });
          },
        ),
      );
    }
  }
}