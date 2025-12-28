import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart'; // Новый пакет
import '../utils/theme.dart';

class AudioControls extends StatelessWidget {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final Function(double) onSeek;      // Для обновления UI
  final Function(double) onSeekStart; // Начали тянуть
  final Function(double) onSeekEnd;   // Закончили (отпустили)

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Профессиональный прогресс-бар
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ProgressBar(
            progress: position,
            total: duration,
            
            // Цвета
            baseBarColor: CupertinoColors.systemGrey5,
            progressBarColor: AppTheme.primaryGreen,
            thumbColor: AppTheme.primaryGreen,
            bufferedBarColor: Colors.transparent,
            
            // Настройка поведения
            timeLabelLocation: TimeLabelLocation.sides, // Время по бокам
            timeLabelTextStyle: const TextStyle(color: AppTheme.textGrey, fontSize: 12),
            thumbRadius: 8.0,
            
            // Обработчики событий
            onSeek: (duration) {
              // Это срабатывает при ТАПЕ и при окончании перетаскивания
              onSeekEnd(duration.inSeconds.toDouble());
            },
            onDragStart: (details) {
              onSeekStart(position.inSeconds.toDouble());
            },
            onDragUpdate: (details) {
              // Пока тянем - обновляем визуально
              onSeek(details.timeStamp.inSeconds.toDouble());
            },
          ),
        ),
        const SizedBox(height: 20),
        
        // Кнопка Play
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



