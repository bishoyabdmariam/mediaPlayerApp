import 'package:flutter/material.dart';
import 'package:mediaplayerapp/consts/colors.dart';
import 'package:mediaplayerapp/consts/textStyle.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: whiteColor,
              ),
            ),
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
          title: Text(
            "Beats",
            style: myStyle(
              family: "bold",
              size: 18,
            ),
          ),
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 100,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                tileColor: bgColor,
                title: Text(
                  "Music Name",
                  style: myStyle(
                    family: "bold",
                    size: 15,
                  ),
                ),
                subtitle: Text(
                  "Artist Name",
                  style: myStyle(
                    family: "regular",
                    size: 12,
                  ),
                ),
                leading: const Icon(
                  Icons.music_note,
                  color: whiteColor,
                  size: 32,
                ),
                trailing: const Icon(
                  Icons.play_arrow,
                  color: whiteColor,
                  size: 26,
                ),
              ),
            );
          },
        ));
  }
}
