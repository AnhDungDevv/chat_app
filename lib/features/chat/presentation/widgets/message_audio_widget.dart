import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shimmer/shimmer.dart';

class MessageAudioWidget extends StatefulWidget {
  final String? audioUrl;
  const MessageAudioWidget({super.key, this.audioUrl});

  @override
  State<MessageAudioWidget> createState() => _MessageAudioWidgetState();
}

class _MessageAudioWidgetState extends State<MessageAudioWidget> {
  bool isPlaying = false;
  bool isLoading = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _handleAudio() async {
    if (widget.audioUrl == null) return;

    try {
      if (isPlaying) {
        await audioPlayer.pause();
        setState(() => isPlaying = false);
      } else {
        setState(() => isLoading = true);

        await audioPlayer.setUrl(widget.audioUrl!);

        setState(() {
          isPlaying = true;
          isLoading = false;
        });

        await audioPlayer.play();

        setState(() => isPlaying = false);
        await audioPlayer.stop();
      }
    } catch (e) {
      debugPrint('Audio load/play error: $e');
      setState(() {
        isLoading = false;
        isPlaying = false;
      });
      // Bạn có thể show snackbar hoặc toast ở đây nếu cần
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          constraints: const BoxConstraints(minWidth: 50),
          onPressed: isLoading ? null : _handleAudio,
          icon:
              isLoading
                  ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.grey.shade100,
                    child: const Icon(
                      Icons.music_note,
                      size: 30,
                      color: Colors.grey,
                    ),
                  )
                  : Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 30,
                    color: greyColor,
                  ),
        ),
        const SizedBox(width: 15),
        isPlaying
            ? StreamBuilder<Duration>(
              stream: audioPlayer.positionStream,
              builder: (context, snapshot) {
                final totalDuration = audioPlayer.duration;
                final currentPosition = snapshot.data ?? Duration.zero;

                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 190,
                  height: 2,
                  child: LinearProgressIndicator(
                    value:
                        (totalDuration != null &&
                                totalDuration.inMilliseconds > 0)
                            ? currentPosition.inMilliseconds.toDouble() /
                                totalDuration.inMilliseconds.toDouble()
                            : 0,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    backgroundColor: greyColor,
                  ),
                );
              },
            )
            : Container(
              margin: const EdgeInsets.only(top: 20),
              width: 190,
              height: 2,
              child: const LinearProgressIndicator(
                value: 0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: greyColor,
              ),
            ),
      ],
    );
  }
}
