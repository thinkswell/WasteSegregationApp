import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  Map data = {};
  bool uploaded = false;
  int dataLength = 0;
  var info = [];
  var type;
  var msg;

  var url = 'http://localhost:8000/api';

  Future<FormData> formData1(File file) async {
    return FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: 'image.jpg')
    });
  }

  void _uploadImage(File file) async {
    if (uploaded) return;
    var dio = new Dio();
    dio.options.baseUrl = url;

    try {
      await dio.post('$url/image/', data: await formData1(file)).then((res) {
        var rdata = jsonDecode(res.toString());
        print(data);
        dataLength = rdata['length'];
        type = rdata['type'];
        info = rdata['data'];
        print(info);
        setState(() {
          uploaded = true;
        });
      });
    } catch (err) {
      print('Got an Error in info.dart.💥💥');
      print("Error: $err");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    _uploadImage(data['image']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ways to Recycle $type.'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: 400,
        child: uploaded
            // ? Text('$message')
            ? ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: dataLength,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 10),
                      if (info[index]['head'] != null)
                        Center(
                          child: Text(
                            "${info[index]['head']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (info[index]['para'] != null)
                        Text(
                          '${info[index]['para']}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800],
                          ),
                        ),
                      if (info[index]['list'] != null)
                        for (var item in info[index]['list'])
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 1, 0, 1),
                            child: Text(
                              '• $item',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                      SizedBox(height: 5),
                      if (info[index]['open'] != null)
                        InkWell(
                            child: Text(
                              "Open Link ➼ ${info[index]['openText']}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue[600],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () => launch(info[index]['open'])),
                      SizedBox(height: 5),
                      if (info[index]['link'] != null)
                        // Text("We got a link: ${info[index]['link']}"),
                        YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: YoutubePlayer.convertUrlToId(
                                info[index]['link']),
                            flags: YoutubePlayerFlags(
                              autoPlay: false,
                              mute: false,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 10,
                      )
                    ],
                  );
                },
              )
            : SpinKitCircle(
                color: Colors.green,
                size: 100,
              ),
      ),
    );
  }
}
