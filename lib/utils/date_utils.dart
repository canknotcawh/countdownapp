String formatDate(DateTime dt) {
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year} • $hh:$mm';
}

String compactRemaining(DateTime target) {
  final now = DateTime.now();
  final diff = target.difference(now);
  if (diff.isNegative) return 'Done';
  final days = diff.inDays;
  if (days >= 1) return '$days d';
  final hours = diff.inHours;
  if (hours >= 1) return '$hours h';
  final minutes = diff.inMinutes;
  if (minutes >= 1) return '$minutes m';
  return '${diff.inSeconds}s';
}
class RemainingTime {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isPast;

  RemainingTime(this.days, this.hours, this.minutes, this.seconds, this.isPast);
}

RemainingTime calculateRemaining(DateTime target) {
  final diff = target.difference(DateTime.now());
  final isPast = diff.isNegative;
  return RemainingTime(
    isPast ? 0 : diff.inDays,
    isPast ? 0 : diff.inHours % 24,
    isPast ? 0 : diff.inMinutes % 60,
    isPast ? 0 : diff.inSeconds % 60,
    isPast,
  );
}
