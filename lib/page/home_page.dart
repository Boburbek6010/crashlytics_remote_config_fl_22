import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final remoteConfig = FirebaseRemoteConfig.instance;


  Map<String, Color> colors = {
    "blue":Colors.blue,
    "yellow":Colors.yellow,
    "red":Colors.red,
    "green":Colors.green,
    "grey":Colors.grey,
    "pink":Colors.pink,
    "white":Colors.white,
  };
  String backgroundColor = "white";
  Future<void> fetchData()async{
    await remoteConfig.fetchAndActivate().then((value) {
      backgroundColor = remoteConfig.getString("background_color");
    });
  }
  Future<void> initialConfig()async{
    remoteConfig.setDefaults({"background_color":backgroundColor,});
    await fetchData();
    remoteConfig.onConfigUpdated.listen((event) async{
      await fetchData();
      setState(() {});
    });
  }

  bool isBannerShow = false;
  String bannerText = "";

  @override
  void initState() {
    initialConfig();
    isBannerShow = remoteConfig.getBool("isBannerShow");
    bannerText = remoteConfig.getString("bannerText");
    log(isBannerShow.toString());
    log(bannerText.toString());

    remoteConfig.onConfigUpdated.listen((event) async{
      await remoteConfig.activate();
      setState(() {
        isBannerShow = remoteConfig.getBool("isBannerShow");
        bannerText = remoteConfig.getString("bannerText");
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return isBannerShow ?Scaffold(
      backgroundColor: colors[backgroundColor],
      appBar: AppBar(
        title: isBannerShow ?Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueGrey,
          ),
          child: Center(child: Text(bannerText)),
        ):const SizedBox.shrink(),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, index){
            return Card(
              child: ListTile(
                title: Text("$index Data"),
              ),
            );
          },
        )
      ),
    ):const Scaffold(
      body: Center(
        child: Text("Chuchvarani xom sanabsan"),
      ),
    );
  }
}
