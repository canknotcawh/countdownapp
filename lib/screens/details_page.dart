import 'dart:async';
import 'package:flutter/material.dart';
import '../models/countdown_item.dart';
import '../widgets/progress_ring.dart';
import 'create_widget.dart';
import 'write_empty.dart';
import '../utils/helper.dart';
import '../utils/date_utils.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.item});
  final CountdownItem item;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final remain = calculateRemaining(widget.item.target);
  final d = remain.days;
  final h_ = remain.hours;
  final m = remain.minutes;
  final s = remain.seconds;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar custom
            SizedBox(
              width: double.infinity,
              height: h(context, 60),
              child: Stack(
                children: [
                  Positioned(
                    left: w(context, 16),
                    top: h(context, 10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF222225),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: w(context, 22),
                          height: h(context, 22),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Icon(Icons.arrow_back, color: Colors.black, size: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: h(context, 12),
                    left: w(context, 72),
                    right: w(context, 72),
                    child: Center(
                      child: Text(
                        widget.item.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w(context, 18),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Positioned(
                    right: w(context, 16),
                    top: h(context, 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.item.title = "";
                              widget.item.note = "";
                              widget.item.color = Colors.grey;
                              widget.item.icon = Icons.event;
                              widget.item.target = DateTime.now().add(const Duration(days: 1));
                            });
                          },
                          child: CircleAvatar(
                            radius: w(context, 18),
                            backgroundColor: const Color(0xFF222225),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: w(context, 8)),
                        GestureDetector(
                          onTap: () {
                          },
                          child: CircleAvatar(
                            radius: w(context, 18),
                            backgroundColor: const Color(0xFF222225),
                            child: const Icon(Icons.share, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h(context, 12)),

            // Avatar icon
            SizedBox(
              width: w(context, 100),
              height: w(context, 100),
              child: CircleAvatar(
                radius: w(context, 50),
                backgroundColor: widget.item.color,
                child: Icon(
                  widget.item.icon,
                  size: w(context, 40),
                  color: widget.item.color!.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),

            SizedBox(height: h(context, 12)),

            // Title & date/time
            SizedBox(
              width: w(context, 312),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w(context, 20),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: h(context, 8)),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: w(context, 16), color: Colors.white),
                      SizedBox(width: w(context, 6)),
                      Text(
                        _formatDate(widget.item.target),
                        style: TextStyle(color: Colors.white, fontSize: w(context, 14)),
                      ),
                      SizedBox(width: w(context, 8)),
                      Icon(Icons.access_time, size: w(context, 16), color: Colors.white),
                      SizedBox(width: w(context, 6)),
                      Text(
                        _formatTime(widget.item.target),
                        style: TextStyle(color: Colors.white, fontSize: w(context, 14)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: h(context, 20)),

            // Countdown ring
            Container(
              width: w(context, 312),
              padding: EdgeInsets.all(w(context, 16)),
              decoration: BoxDecoration(
                color: const Color(0xFF222225),
                borderRadius: BorderRadius.circular(w(context, 20)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: w(context, 200),
                    height: w(context, 200),
                    child: ProgressRing(
                      target: widget.item.target,
                      strokeWidth: w(context, 14),
                    ),
                  ),
                  SizedBox(height: h(context, 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _timeColumn("Days", d),
                      _timeColumn("Hours", h_),
                      _timeColumn("Minutes", m),
                      _timeColumn("Seconds", s),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: h(context, 24)),

            // Notes 
            if (widget.item.note != null && widget.item.note!.isNotEmpty) ...[
              SizedBox(
                width: w(context, 311),
                child: Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: w(context, 16),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: h(context, 4)),
              SizedBox(
                width: w(context, 311),
                child: Text(
                  widget.item.note!,
                  style: TextStyle(fontSize: w(context, 14), color: Colors.white70),
                ),
              ),
            ],

            Spacer(),

            // Bottom actions
            SizedBox(
              width: double.infinity,
              height: h(context, 78),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomAction(
                    icon: Icons.home,
                    label: "Home",
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                  _BottomAction(
                    icon: Icons.edit,
                    label: "Edit",
                    onTap: () async {
                      if (!mounted) return;
                      final updated = await Navigator.push<CountdownItem>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WriteEmptyPage(item: widget.item),
                        ),
                      );
                      if (!mounted) return;
                      if (updated != null) {
                        setState(() {
                          widget.item.title = updated.title;
                          widget.item.note = updated.note;
                          widget.item.target = updated.target;
                        });
                      }
                    },
                  ),
                  _BottomAction(
                    icon: Icons.calendar_today,
                    label: "Calendar",
                    onTap: () {
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.black,
                          title: const Text(
                            "Calendar",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            "Target date:\n${_formatDate(widget.item.target)}\n${_formatTime(widget.item.target)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Close",
                                style: TextStyle(color: Color(0xFFB5FF3E)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _BottomAction(
                    icon: Icons.widgets,
                    label: "Widget",
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateWidgetScreen(
                            initialItem: widget.item
                          )
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: h(context, 24)),
          ],
        ),
      ),
    );
  }

  Widget _timeColumn(String label, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: TextStyle(
            fontSize: w(context, 22),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: h(context, 4)),
        Text(
          label,
          style: TextStyle(fontSize: w(context, 12), color: Colors.white),
        ),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${days[(date.weekday - 1) % 7]}, ${months[(date.month - 1) % 12]} ${date.day}, ${date.year}";
  }

  static String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final ampm = date.hour >= 12 ? "pm" : "am";
    return "${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $ampm (GMT+7)";
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: w(context, 24),
            backgroundColor: const Color(0xFFB5FF3E),
            child: Icon(icon, color: Colors.black),
          ),
          SizedBox(height: h(context, 6)),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: w(context, 12)),
          ),
        ],
      ),
    );
  }
}
