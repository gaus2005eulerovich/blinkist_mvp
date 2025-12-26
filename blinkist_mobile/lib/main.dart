import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

// --- КОНФИГУРАЦИЯ СЕТИ ---

// При запуске на реальном устройстве, нужно будет:
// 1. Поменять этот IP на свой локальный (например, 192.168.1.X)
// 2. ИЛИ использовать 'adb reverse tcp:8000 tcp:8000' и адрес '127.0.0.1'
const String backendUrl = 'http://10.0.2.2:8000';

void main() {
  runApp(const BlinkistClone());
}

class BlinkistClone extends StatelessWidget {
  const BlinkistClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blinkist Clone',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF2CE080), 
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Sans', 
      ),
      home: const BookListScreen(),
    );
  }
}

// --- ЭКРАН 1: СПИСОК КНИГ ---
class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List books = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/books'));
      
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        setState(() {
          books = json.decode(body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Ошибка сервера: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Network Error: $e");
      setState(() {
        errorMessage = "Connection failed.\n\nMake sure the Backend is running on port 8000.\nTarget: $backendUrl";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF2CE080)))
        : errorMessage != null
          ? Center(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlayerScreen(book: book)),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                          child: Image.network(
                            book['image_url'], 
                            width: 100, 
                            height: 140, 
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(width: 100, height: 140, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['title'], 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  book['author'], 
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14)
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text("15 min", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.play_circle_outline, color: const Color(0xFF2CE080), size: 40),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// --- ЭКРАН 2: АУДИО ПЛЕЕР ---
class PlayerScreen extends StatefulWidget {
  final Map book;
  const PlayerScreen({super.key, required this.book});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    setupAudio();
  }

  void setupAudio() async {
    audioPlayer.onDurationChanged.listen((d) => setState(() => duration = d));
    audioPlayer.onPositionChanged.listen((p) => setState(() => position = p));
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });
    

  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.bookmark_border, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(widget.book['image_url'], width: 80, height: 120, fit: BoxFit.cover),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.book['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(widget.book['author'], style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 30),

          // Прогресс бар и кнопки
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Slider(
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
                  activeColor: const Color(0xFF2CE080),
                  inactiveColor: Colors.grey[200],
                  onChanged: (value) async {
                    await audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(position), style: TextStyle(color: Colors.grey[600])),
                      Text(formatTime(duration), style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xFF2CE080),
                  child: IconButton(
                    iconSize: 35,
                    color: Colors.white,
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                      } else {
                        await audioPlayer.play(UrlSource(widget.book['audio_url']));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),

          // Текст саммари 
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Text(
                widget.book['summary'],
                style: const TextStyle(fontSize: 18, height: 1.6, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



