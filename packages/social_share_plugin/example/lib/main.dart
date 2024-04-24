import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _platformName;

  static Future<String> _urlToFilePath(String imageUrl) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    http.Response response = await http.get(Uri.parse(imageUrl));

    // Extracting file extension from Content-Type header
    String? contentType = response.headers['content-type'];
    String fileExtension =
        '.mp4'; // Default extension if Content-Type is not available
    if (contentType != null && contentType.isNotEmpty) {
      List<String> parts = contentType.split('/');
      if (parts.length == 2) {
        fileExtension = '.' + parts[1];
      }
    }
    print('fileExtension : ${fileExtension}');
    List<String> urlSegments = imageUrl.split('/');
    String filename = urlSegments.last;
    final filePath = '$tempPath/$filename$fileExtension';
    File file = new File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SocialSharePlugin Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_platformName == null)
              const SizedBox.shrink()
            else
              Text(
                'Platform Name: $_platformName',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await getPlatformName();
                  setState(() => _platformName = result);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text('$error'),
                    ),
                  );
                }
              },
              child: const Text('Get Platform Name'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await shareToFeedFacebookLink(
                    url: 'https://www.flutter.dev',
                    quote: 'test',
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text('$error'),
                    ),
                  );
                }
              },
              child: const Text('Share Link To Facebook Feed'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  // final filePath = await _urlToFilePath(
                  //     'https://storage.googleapis.com/lookin-dev-26f02.appspot.com/06316c5dfadad7838e66141a8ce68712');
                  // final filePath = await _urlToFilePath(
                  //     'https://cdn-dev.lookinid.com/banners/f572932e8bc370d143722fd4b837c907');

                  // print('file path :${filePath}');

                  await shareToFeedFacebook(
                    // path: '',
                    // path: filePath,
                    path: pickedFile!.path,
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text('$error'),
                    ),
                  );
                }
              },
              child: const Text('Share Image to Facebook Feed'),
            ),ElevatedButton(
              onPressed: () async {
                try {
                  final pickedFile = await ImagePicker()
                      .pickVideo(source: ImageSource.gallery);

                  // final filePath = await _urlToFilePath(
                  //     'https://storage.googleapis.com/lookin-dev-26f02.appspot.com/06316c5dfadad7838e66141a8ce68712');
                  // final filePath = await _urlToFilePath(
                  //     'https://cdn-dev.lookinid.com/banners/f572932e8bc370d143722fd4b837c907');

                  // print('file path :${filePath}');

                  await shareToFeedFacebookVideo(
                    // path: '',
                    // path: filePath,
                    path: pickedFile!.path,
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text('$error'),
                    ),
                  );
                }
              },
              child: const Text('Share Video to Facebook Feed'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await shareToTwitterLink(
                    url: 'https://www.flutter.dev',
                    text: r'test #, & and $',
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text('$error'),
                    ),
                  );
                }
              },
              child: const Text('Share Link to Twitter'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  await shareToFeedInstagram(
                    path: pickedFile!.path,
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Text('$error'),
                    ),
                  );
                }
              },
              child: const Text('Share Image to Instagram'),
            ),
          ],
        ),
      ),
    );
  }
}
