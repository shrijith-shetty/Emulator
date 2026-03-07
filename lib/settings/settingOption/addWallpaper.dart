import 'dart:io';
import 'dart:typed_data';

import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:emulator/database/wallpaper_storage.dart';

class Addwallpaper extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() => _AddWallPaper();
}

class _AddWallPaper extends State<Addwallpaper>
{
    final StoreCurrentWallPaper _authService = StoreCurrentWallPaper();

    bool _isWallPaper = false;
    String currentWallpaper = "";

    // ================= LOAD SAVED WALLPAPER =================

    Future<void> _checkPath() async
    {
        String? path = await _authService.getWallpaper();

        if (!mounted) return;

        if (path != null && path.isNotEmpty)
        {
            setState(()
                {
                    currentWallpaper = path;
                    _isWallPaper = true;
                });
        }
    }

    // ================= SAVE WALLPAPER =================

    Future<void> _handleButton(String path) async
    {
        await _authService.setWallpaper(path);

        if (!mounted) return;

        setState(()
            {
                currentWallpaper = path;
                _isWallPaper = true;
            });

        Navigator.pop(context, true);
    }

    // ================= OPEN GALLERY =================

    Future<void> _openGallery() async
    {
        final PermissionState ps = await PhotoManager.requestPermissionExtend();

        if (!ps.isAuth)
        {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Gallery permission required. Please grant permission in settings.'
                    )
                )
            );
            PhotoManager.openSetting();
            return;
        }

        List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
            type: RequestType.image
        );

        if (albums.isEmpty)
        {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No photo albums found on device.'))
            );
            return;
        }

        // Select first album that actually has images
        AssetPathEntity? selectedAlbum;

        for (var album in albums)
        {
            final count = await album.assetCountAsync;
            if (count > 0)
            {
                selectedAlbum = album;
                break;
            }
        }

        if (selectedAlbum == null)
        {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No photos found in albums.'))
            );
            return;
        }

        List<AssetEntity> photos = await selectedAlbum.getAssetListPaged(
            page: 0,
            size: 100
        );

        if (photos.isEmpty)
        {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No photos available to display.'))
            );
            return;
        }

        if (!mounted) return;

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
                                                await _handleButton(file.path);
                                            }

                                            // Navigator.pop(context);
                                        },
                                        child: Image.memory(snapshot.data!, fit: BoxFit.cover)
                                    );
                                }
                            );
                        }
                    )
                );
            }
        );
    }

    @override
    void initState()
    {
        super.initState();
        _checkPath();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: CupertinoColors.black,
                leading: InkWell(
                    child: const Icon(
                        Icons.wallpaper_rounded,
                        color: Colors.white,
                        size: 30
                    ),
                    onTap: () async
                    {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Settings())
                        ).then((_)
                                {
                                    //reload everything when coming back
                                    (context as Element).markNeedsBuild();

                                });
                    }
                ),
                title: const Text(
                    "Wallpaper",
                    style: TextStyle(fontSize: 30, color: Colors.white)
                )
            ),
            body: Container(
                child: Column(
                    children: [
                        const Center(
                            child: Text("Current Wallpaper", style: TextStyle(fontSize: 30))
                        ),
                        const SizedBox(height: 100),
                        InkWell(
                            onTap: _openGallery,
                            child: !_isWallPaper
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(CupertinoIcons.add_circled, size: 30)
                                )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                        width: 200,
                                        height: 150,
                                        child: currentWallpaper.isEmpty
                                            ? const Icon(Icons.image, size: 50)
                                            : Image.file(
                                                File(currentWallpaper),
                                                fit: BoxFit.cover
                                            )
                                    )
                                )
                        ),
                        const SizedBox(height: 100)
                    ]
                )
            )
        );
    }
}
