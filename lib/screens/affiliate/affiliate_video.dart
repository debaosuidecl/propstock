import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class AffiliateVideoPlayer extends StatefulWidget {
  const AffiliateVideoPlayer({super.key});

  @override
  State<AffiliateVideoPlayer> createState() => _AffiliateVideoPlayerState();
}

class _AffiliateVideoPlayerState extends State<AffiliateVideoPlayer> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    );

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
      autoPlay: false,
      looping: false,
      showControlsOnInitialize: true,
      allowFullScreen: true,
      allowMuting: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset("images/close_icon.svg"),
          ),
        ),
        title: Text(
          "Become an Affiliate",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
