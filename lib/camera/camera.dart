import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';

class CameraPage extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver
{
    List<CameraDescription> cameras = [];
    CameraController? cameraController;

    @override
    void initState() 
    {
        super.initState();
        WidgetsBinding.instance.addObserver(this);
        _setupCameraController();
    }

    @override
    void dispose() 
    {
        WidgetsBinding.instance.removeObserver(this);
        cameraController?.dispose();
        super.dispose();
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) 
    {
        if (cameraController == null || !cameraController!.value.isInitialized) 
        {
            return;
        }

        if (state == AppLifecycleState.inactive) 
        {
            cameraController?.dispose();
        } else if (state == AppLifecycleState.resumed) 
        {
            _setupCameraController();
        }
    }

    Future<void> _setupCameraController() async
    {
        final availableCamerasList = await availableCameras();
        if (availableCamerasList.isNotEmpty) 
        {
            cameras = availableCamerasList;
            cameraController =
            CameraController(cameras.last, ResolutionPreset.high);

            try
            {
                await cameraController!.initialize();
                if (mounted) setState(()
                        {});
            } catch (e)
            {
                print("Camera initialization error: $e");
            }
        }
    }

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            body: cameraController == null || !cameraController!.value.isInitialized
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: SizedBox.expand(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.6,
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: CameraPreview(cameraController!)
                                ),
                                IconButton(
                                    onPressed: () async
                                    {
                                        final picture = await cameraController!.takePicture();
                                        await Gal.putImage(picture.path);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Saved to gallery!"))
                                        );
                                    },
                                    iconSize: 100,
                                    icon: const Icon(
                                        Icons.camera,
                                        color: Colors.red
                                    )
                                )
                            ]
                        )
                    )
                )
        );
    }
}
