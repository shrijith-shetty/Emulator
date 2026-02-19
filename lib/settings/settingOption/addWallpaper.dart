import 'dart:io';

import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:emulator/database//wallpaper_storage.dart';
// import ''

class Addwallpaper extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() =>
    _AddWallPaper();
}

class _AddWallPaper extends State<Addwallpaper>
{

    final StoreCurrentWallPaper _authService = StoreCurrentWallPaper();
    bool _obsecure = false;
    bool _isWallPaper = false;
    String msg = "";
    Future<void> requestPermission() async
    {
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (ps.isAuth)
        {
            print("Permission Granted");
        }
        else
        {
            print("Permission deneid");
            PhotoManager.openSetting();
        }
    }

    Future<List<AssetPathEntity>> getAlbums() async
    {
        return await PhotoManager.getAssetPathList(
            type: RequestType.image
        );
    }

    Future<List<AssetEntity>> getPhotos(AssetPathEntity album) async
    {
        return await album.getAssetListPaged(page: 0, size: 100);
    }

    Future<void> _checkPath() async
    {
        bool exits = await _authService.isWallpaperset();
        setState(()
            {
                _isWallPaper = exits;
            });
    }

    Future<void> _handleButton() async{

    }
    @override
    void initState()
    {
        super.initState();
        requestPermission();
    }

    String currentWallpaper = "assets/Gallery/flower-8559381_1280.jpg";
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: CupertinoColors.black,
                leading: InkWell(
                    child: Icon(
                        Icons.wallpaper_rounded,
                        color: Colors.white,
                        size: 30
                    ),
                    onTap: ()
                    {
                        Navigator.pop(context, MaterialPageRoute(builder: (context) => Settings()));
                    }
                ),
                title: Text("Wallpaper", style: TextStyle(fontSize: 30, color: Colors.white))
            ),
            body: Container(
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Center(child: Text("Current Wallpaper", style: TextStyle(fontSize: 30))),

                        InkWell(
                            onTap: () async
                            {

                                List<AssetPathEntity> albums = await getAlbums();

                                if (albums.isEmpty) return;

                                List<AssetEntity> photos = await getPhotos(albums.first);

                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context)
                                    {
                                        return SizedBox(
                                            height: 500,
                                            child: GridView.builder(
                                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5
                                                ),
                                                itemCount: photos.length,
                                                itemBuilder: (context, index)
                                                {
                                                    return FutureBuilder<Uint8List?>(
                                                        future: photos[index].thumbnailDataWithSize(
                                                            const ThumbnailSize(200, 200)
                                                        ),
                                                        builder: (context, snapshot)
                                                        {
                                                            if (!snapshot.hasData)
                                                            {
                                                                return const SizedBox();
                                                            }

                                                            return InkWell(
                                                                onTap: () async
                                                                {
                                                                    final file = await photos[index].file;

                                                                    if (file != null)
                                                                    {
                                                                        setState(()
                                                                            {
                                                                                currentWallpaper = file.path;
                                                                            });
                                                                    }

                                                                    Navigator.pop(context);
                                                                },
                                                                child: Image.memory(
                                                                    snapshot.data!,
                                                                    fit: BoxFit.cover
                                                                )
                                                            );
                                                        }
                                                    );
                                                }
                                            )
                                        );
                                    }
                                );
                            },

                            child: InkWell(

                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                        width: 200,
                                        height: 150,
                                        // color: Colors.blue,
                                        // decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(35)
                                        //     // boxShadow:
                                        // ),
                                        child: currentWallpaper.startsWith("assets")
                                            ? Image.asset(currentWallpaper, fit: BoxFit.cover)
                                            : Image.file(File(currentWallpaper), fit: BoxFit.cover)

                                    )
                                )
                            )
                        ),
                        SizedBox(height: 100)

                    ]
                )

            )
        );
    }

}

