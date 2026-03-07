import 'package:device_info_plus/device_info_plus.dart';
import 'package:emulator/settings/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AboutPhone extends StatefulWidget
{
    const AboutPhone({super.key});

    @override
    State<AboutPhone> createState() => _AboutPhoneState();
}

class _AboutPhoneState extends State<AboutPhone>
{
    String deviceInfo = "";

    List<String> text = ["loading..."];
    void deviceInformation()
    {
        deviceInfo = "";

        for (String line in text)
        {
            if (line.startsWith("Manufacturer:"))
            {
                deviceInfo = line.split(":")[1].trim();
                break;
            }
        }
    }
    @override
    void initState()
    {
        // text.clear();
        super.initState();
        loadInfo();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: InkWell(
                    onTap: () => Navigator.pop(context, MaterialPageRoute(builder: (context) => Settings())),
                    child: const Icon(
                        Icons.phone_iphone_outlined,
                        size: 30,
                        color: Colors.white
                    )
                ),

                title: const Text(
                    'About Phone',
                    style: TextStyle(fontSize: 20, color: Colors.white)
                )
            ),

            body: Container(
                color: Colors.black54,
                child: Column(
                    children: [
                        SizedBox(
                            height: 10
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(20),
                                    child: Container(
                                        height: 188,
                                        width: 188,
                                        color: Colors.black,
                                        child: Padding(
                                            padding: const EdgeInsets.all(38.0),
                                            child: Column(
                                                children: [
                                                    Text("Device", style: TextStyle(fontSize: 36, color: Colors.grey)),
                                                    Text("Info", style: TextStyle(fontSize: 30, color: Colors.grey, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
                                                ]
                                            )
                                        )
                                    )
                                ),
                                ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(20),
                                    child: Container(
                                        height: 188,
                                        width: 188,
                                        color: Colors.black,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                                Text(
                                                    deviceInfo,
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                )
                            ]
                        ),
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(12),
                                child: ListView.builder(
                                    itemCount: text.length,
                                    itemBuilder: (context, int index)
                                    {
                                        return ClipRRect(
                                            borderRadius: BorderRadiusGeometry.circular(20),
                                            child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Container(

                                                    height: 40,
                                                    width: 900,
                                                    color: Colors.black,
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                            text[index].toString(),
                                                            style: const TextStyle(fontSize: 16, color: Colors.white)
                                                        )
                                                    )
                                                )
                                            )
                                        );
                                    }
                                )
                            )
                        )

                    ]
                )

            )
        );
    }

    Future<void> loadInfo() async
    {
        final deviceInfo = DeviceInfoPlugin();
        List<String> info = [];

        // ================= WEB =================
        if (kIsWeb)
        {
            final webInfo = await deviceInfo.webBrowserInfo;

            info.add("Platform: Web");
            info.add("Browser: ${webInfo.browserName.name}");
            info.add("User Agent: ${webInfo.userAgent}");
            info.add("Vendor: ${webInfo.vendor}");
            info.add("App Version: ${webInfo.appVersion}");

            if (!mounted) return;
            setState(() => text = info

            );
            return;
        }

        switch (defaultTargetPlatform)
        {

            // ================= ANDROID =================
            case TargetPlatform.android:
                final android = await deviceInfo.androidInfo;

                info.add("Platform: Android");
                info.add("Brand: ${android.brand}");
                info.add("Manufacturer: ${android.manufacturer}");
                info.add("Model: ${android.model}");
                info.add("Device: ${android.device}");
                info.add("Product: ${android.product}");
                info.add("Android Version: ${android.version.release}");
                info.add("SDK Level: ${android.version.sdkInt}");
                info.add("Board: ${android.board}");
                info.add("Hardware: ${android.hardware}");
                info.add("Bootloader: ${android.bootloader}");
                // info.add("Fingerprint: ${android.fingerprint}");
                info.add("Is Physical Device: ${android.isPhysicalDevice}");
                info.add("Supported ABIs: ${android.supportedAbis.join(", ")}");

                break;

            // ================= IOS =================
            case TargetPlatform.iOS:
                final ios = await deviceInfo.iosInfo;

                info.add("Platform: iOS");
                info.add("Name: ${ios.name}");
                info.add("System Name: ${ios.systemName}");
                info.add("System Version: ${ios.systemVersion}");
                info.add("Model: ${ios.model}");
                info.add("Localized Model: ${ios.localizedModel}");
                info.add("Identifier For Vendor: ${ios.identifierForVendor}");
                info.add("Machine: ${ios.utsname.machine}");
                info.add("Is Physical Device: ${ios.isPhysicalDevice}");

                break;

            // ================= WINDOWS =================
            case TargetPlatform.windows:
                final windows = await deviceInfo.windowsInfo;

                info.add("Platform: Windows");
                info.add("Computer Name: ${windows.computerName}");
                info.add("User Name: ${windows.userName}");
                info.add("CPU Cores: ${windows.numberOfCores}");
                info.add("RAM (MB): ${windows.systemMemoryInMegabytes}");
                info.add("Major Version: ${windows.majorVersion}");
                info.add("Minor Version: ${windows.minorVersion}");
                info.add("Build Number: ${windows.buildNumber}");
                info.add("Product Name: ${windows.productName}");

                break;

            // ================= MACOS =================
            case TargetPlatform.macOS:
                final mac = await deviceInfo.macOsInfo;

                info.add("Platform: macOS");
                info.add("Computer Name: ${mac.computerName}");
                info.add("Host Name: ${mac.hostName}");
                info.add("Model: ${mac.model}");
                info.add("Kernel Version: ${mac.kernelVersion}");
                info.add("OS Release: ${mac.osRelease}");
                info.add("Active CPUs: ${mac.activeCPUs}");
                info.add("Memory Size: ${(mac.memorySize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB");

                break;

            // ================= LINUX =================
            case TargetPlatform.linux:
                final linux = await deviceInfo.linuxInfo;

                info.add("Platform: Linux");
                info.add("Name: ${linux.name}");
                info.add("Version: ${linux.version}");
                info.add("Pretty Name: ${linux.prettyName}");
                info.add("Machine ID: ${linux.machineId}");

                break;

            default:
            info.add("Unsupported Platform");
        }

        if (!mounted) return;

        setState(()
            {
                text = info;
                deviceInformation();
            }
        );
    }
}

