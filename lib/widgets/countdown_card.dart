import 'package:flutter/material.dart';
import '../models/countdown_item.dart';
import '../utils/helper.dart';

class CountdownCard extends StatelessWidget {
  const CountdownCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final CountdownItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final remaining = item.target.difference(now);
    final remainingDays = remaining.isNegative ? 0 : remaining.inDays;

    final baseColor = item.color ?? Theme.of(context).colorScheme.primary;
    final gradient = LinearGradient(
      colors: [
        baseColor.withValues(alpha: 0.9),
        baseColor.withValues(alpha: 0.6),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        width: w(context, 343),
        height: h(context, 96),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: gradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w(context, 16)),
          child: Row(
            children: [
              // Icon
              Hero(
                tag: 'icon_${item.title}_${item.target.millisecondsSinceEpoch}',
                child: CircleAvatar(
                  radius: w(context, 24),
                  backgroundColor: Colors.black26,
                  child: Icon(
                    item.icon ?? Icons.emoji_emotions,
                    size: w(context, 24),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: w(context, 16)),

              // Text info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: h(context, 4)),
                    Text(
                      _formatDate(item.target),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                    ),
                    SizedBox(height: h(context, 6)),
                    Text(
                      remaining.isNegative
                          ? 'Finished'
                          : '$remainingDays day${remainingDays == 1 ? '' : 's'} left',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              // Delete
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
