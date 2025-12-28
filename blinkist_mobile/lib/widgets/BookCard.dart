import 'package:flutter/cupertino.dart';
import '../models/Book.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppConstants.cardBorderRadius),
              ),
              child: Image.network(
                book.imageUrl,
                width: 100,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 100,
                  height: 140,
                  color: CupertinoColors.systemGrey5,
                  child: const Icon(CupertinoIcons.exclamationmark_triangle),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.author,
                      style: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(CupertinoIcons.time, size: 16, color: AppTheme.textGrey),
                        SizedBox(width: 4),
                        Text("15 min", style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(CupertinoIcons.play_circle, color: AppTheme.primaryGreen, size: 40),
            )
          ],
        ),
      ),
    );
  }
}

