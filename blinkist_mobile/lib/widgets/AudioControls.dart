import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Нужен для Slider и Material
import '../utils/theme.dart';

class AudioControls extends StatelessWidget {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final Function(double) onSeek;
  final Function(double) onSeekStart;
  final Function(double) onSeekEnd;

  const AudioControls({
    super.key,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onSeek,
    required this.onSeekStart,
    required this.onSeekEnd,
  });

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final double maxDuration = duration.inSeconds.toDouble();
    final double currentValue = position.inSeconds.toDouble().clamp(0.0, maxDuration > 0 ? maxDuration : 1.0);
    final double safeMax = maxDuration > 0 ? maxDuration : 1.0;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          // --- ИСПРАВЛЕНИЕ ЗДЕСЬ ---
          // Оборачиваем SliderTheme в Material виджет
          // type: MaterialType.transparency делает его невидимым, не ломая дизайн
          child: Material(
            type: MaterialType.transparency, 
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppTheme.primaryGreen,
                inactiveTrackColor: CupertinoColors.systemGrey5,
                thumbColor: AppTheme.primaryGreen,
                trackHeight: 4.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
              ),
              child: Slider(
                value: currentValue,
                min: 0.0,
                max: safeMax,
                onChanged: onSeek,
                onChangeStart: onSeekStart,
                onChangeEnd: onSeekEnd,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatTime(position), style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
              Text(_formatTime(duration), style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPlayPause,
          child: Icon(
            isPlaying ? CupertinoIcons.pause_circle_fill : CupertinoIcons.play_circle_fill,
            color: AppTheme.primaryGreen,
            size: 70,
          ),
        ),
      ],
    );
  }
}


