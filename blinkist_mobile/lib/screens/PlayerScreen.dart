import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart'; // Нужен для PlayerState
import '../models/Book.dart';
import '../services/AudioPlayerService.dart';
import '../widgets/AudioControls.dart';
import '../utils/theme.dart';

class PlayerScreen extends StatefulWidget {
  final Book book;
  const PlayerScreen({super.key, required this.book});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayerService _audioService = AudioPlayerService();
  
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  
  // Флаг: пользователь сейчас тянет ползунок?
  bool _isSeeking = false; 
  // Локальная позиция слайдера, пока пользователь тянет
  Duration _dragPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  void _setupAudio() {
    _audioService.durationStream.listen((d) {
      if (mounted) setState(() => duration = d);
    });

    _audioService.positionStream.listen((p) {
      // Обновляем позицию ТОЛЬКО если пользователь НЕ тянет ползунок
      if (!_isSeeking && mounted) {
        setState(() => position = p);
      }
    });

    _audioService.stateStream.listen((state) {
      if (mounted) {
        // Синхронизируем реальное состояние плеера (на случай, если трек закончился)
        setState(() => isPlaying = state == PlayerState.playing);
      }
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    // 1. OPTIMISTIC UI: Меняем иконку мгновенно
    setState(() {
      isPlaying = !isPlaying;
    });

    // 2. Асинхронная логика выполняется в фоне
    if (isPlaying) {
      // Пользователь нажал Play
      await _audioService.play(widget.book.audioUrl);
    } else {
      // Пользователь нажал Pause
      await _audioService.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.book.title),
        backgroundColor: AppTheme.backgroundLight,
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Обложка и Инфо
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(widget.book.imageUrl, width: 80, height: 120, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.book.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(widget.book.author, style: const TextStyle(color: AppTheme.textGrey, fontSize: 16)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Контролы
            AudioControls(
              isPlaying: isPlaying,
              // Если тянем - показываем позицию пальца, иначе - реальную позицию трека
              position: _isSeeking ? _dragPosition : position,
              duration: duration,
              onPlayPause: _togglePlay,
              
              // Когда пользователь просто тащит или тапнул (визуальное обновление)
              onSeek: (val) {
                setState(() {
                  _dragPosition = Duration(seconds: val.toInt());
                });
              },
              
              // Пользователь коснулся слайдера
              onSeekStart: (val) {
                setState(() {
                  _isSeeking = true;
                  _dragPosition = Duration(seconds: val.toInt());
                });
              },
              
              // Пользователь отпустил слайдер (фактическая перемотка)
              onSeekEnd: (val) async {
                final newPosition = Duration(seconds: val.toInt());
                await _audioService.seek(newPosition);
                setState(() {
                  _isSeeking = false;
                  position = newPosition;
                });
              },
            ),

            const SizedBox(height: 20),
            Container(height: 1, color: CupertinoColors.separator),

            // Саммари
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Text(
                  widget.book.summary,
                  style: const TextStyle(fontSize: 18, height: 1.6, color: AppTheme.textBlack),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


