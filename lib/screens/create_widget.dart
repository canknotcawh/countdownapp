import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/helper.dart';
import '../models/countdown_item.dart';
import 'home_screen.dart';
import 'write_empty.dart';
import '../utils/date_utils.dart';

class CreateWidgetScreen extends StatefulWidget {
  final CountdownItem? initialItem;

  const CreateWidgetScreen({
    super.key,
    this.initialItem,
  });

  @override
  State<CreateWidgetScreen> createState() => _CreateWidgetScreenState();
}

class _CreateWidgetScreenState extends State<CreateWidgetScreen> {
  int _selectedTab = 0;

  String _title = "";
  String _note = "";
  IconData _icon = LucideIcons.smile;
  DateTime? _date;
  Color _bgColor = const Color(0xFFB5FF3E);
  String _selectedFont = "Roboto";
  CountdownItem? _currentItem;

  void _saveWidget() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WriteEmptyPage(fromCreateWidget: true),
      ),
    );

    if (result != null && result is CountdownItem) {
      setState(() {
        _currentItem = result;
        _title = result.title;
        _note = result.note ?? "";
        _icon = result.icon ?? LucideIcons.smile;
        _bgColor = result.color ?? const Color(0xFFB5FF3E);
        _date = result.target;
      });
    }
  }

  Future<void> _finalSave() async {
    if (_currentItem == null) return;
    _currentItem!
      ..title = _title
      ..note = _note
      ..icon = _icon
      ..color = _bgColor
      ..target = _date ?? _currentItem!.target;

    final items = await CountdownStorage.loadItems();

    final index = items.indexWhere((item) => item.id == _currentItem!.id);
    if (index != -1) {
      items[index] = _currentItem!;
    } 
    else {
      items.add(_currentItem!);
    }

    await CountdownStorage.saveItems(items);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialItem != null) {
      _currentItem = widget.initialItem;
      _title = widget.initialItem!.title;
      _note = widget.initialItem!.note ?? "";
      _icon = widget.initialItem!.icon ?? LucideIcons.smile;
      _bgColor = widget.initialItem!.color ?? const Color(0xFFB5FF3E);
      _date = widget.initialItem!.target;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(h(context, 60)),
        child: Padding(
          padding: EdgeInsets.only(top: h(context, 53)),
          child: Container(
            width: w(context, 375),
            height: h(context, 56),
            padding: EdgeInsets.symmetric(horizontal: w(context, 16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF222225),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: w(context, 20),
                      height: h(context, 20),
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

                SizedBox(width: w(context, 8)),
                Text(
                  "Create Widget",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: h(context, 19),
                  ),
                ),

                const Spacer(),

                // Save button
                GestureDetector(
                  onTap: _finalSave,
                  child: Container(
                    width: w(context, 36),
                    height: h(context, 36),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D1D1F),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFFB5FF3E),
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: h(context, 18)),
                  const Divider(height: 1, color: Colors.white10),
                  SizedBox(height: h(context, 6)),

                  // Preview card
                  GestureDetector(
                    onTap: _saveWidget,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: w(context, 16),
                          vertical: h(context, 12),
                        ),
                        padding: EdgeInsets.all(w(context, 16)),
                        width: w(context, 180),
                        height: h(context, 180),
                        decoration: BoxDecoration(
                          color: _bgColor,
                          borderRadius: BorderRadius.circular(w(context, 24)),
                          border: Border.all(color: Colors.grey, width: 3.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Row(
                              children: [
                                Icon(_icon, size: w(context, 22), color: Colors.black),
                                SizedBox(width: w(context, 8)),
                                Expanded(
                                  child: Text(
                                    _title.isEmpty ? "Title" : _title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.getFont(
                                      _selectedFont,
                                      textStyle: TextStyle(
                                        fontSize: w(context, 16),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            // Remaining time
                            if (_date != null) ...[
                              Builder(
                                builder: (_) {
                                  final remain = calculateRemaining(_date!);
                                  final label = remain.isPast ? "Done" : "remaining";
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        compactRemaining(_date!),
                                        style: TextStyle(
                                          fontSize: w(context, 32),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: w(context, 14),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ] else ...[
                              Text(
                                "",
                                style: TextStyle(
                                  fontSize: w(context, 32),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                  fontSize: w(context, 14),
                                  color: Colors.black,
                                ),
                              ),
                            ],

                            const Spacer(),

                            // Date
                            Text(
                              _date == null ? "Pick a date" : formatDate(_date!),
                              style: TextStyle(
                                fontSize: w(context, 12),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Tabs bar
                  SizedBox(
                    width: w(context, 375),
                    height: h(context, 64),
                    child: Container(
                      color: Color(0xFF2D2D30),
                      alignment: Alignment.center,
                      child: Container(
                        width: w(context, 343),
                        height: h(context, 40),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _pillTab("Template", 0, LucideIcons.smile),
                            _pillTab("Background", 1, LucideIcons.image),
                            _pillTab("Font", 2, LucideIcons.type),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h(context, 12)),
                ],
              ),
            ),

            // Tab content
            SliverFillRemaining(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pillTab(String label, int index, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          margin: EdgeInsets.all(w(context, 4)),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: w(context, 16), color: isSelected ? Colors.white : Colors.white70),
                SizedBox(width: w(context, 6)),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      // Icons
    final icons = [
      LucideIcons.smile,
      LucideIcons.heart,
      LucideIcons.star,
      LucideIcons.sun,
      LucideIcons.moon,
      LucideIcons.bell,
      LucideIcons.cake,
      LucideIcons.gift,
      LucideIcons.partyPopper,
      LucideIcons.plane,
      LucideIcons.car,
      LucideIcons.home,
      LucideIcons.briefcase,
      LucideIcons.book,
      LucideIcons.camera,
      LucideIcons.music,
      LucideIcons.film,
      LucideIcons.gamepad,
      LucideIcons.pizza,
      LucideIcons.trees,
      LucideIcons.flame,
      LucideIcons.coffee,
      LucideIcons.package,
      LucideIcons.shoppingCart,
      LucideIcons.clock,
      LucideIcons.mapPin,
      LucideIcons.wine,
      LucideIcons.bookmarkPlus,
    ];
      return GridView.builder(
        padding: EdgeInsets.all(w(context, 16)),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: icons.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () => setState(() => _icon = icons[index]),
            child: Container(
              decoration: BoxDecoration(
                color: _icon == icons[index] ? const Color(0xFFB5FF3E) : Colors.grey[800],
                borderRadius: BorderRadius.circular(w(context, 12)),
              ),
              child: Icon(icons[index], color: Colors.white, size: w(context, 32)),
            ),
          );
        },
      );
    } else if (_selectedTab == 1) {
      // Background colors
      final colors = Colors.primaries.take(9).toList();
      return GridView.builder(
        padding: EdgeInsets.all(w(context, 16)),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: colors.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () => setState(() => _bgColor = colors[index]),
            child: Container(
              decoration: BoxDecoration(
                color: colors[index],
                borderRadius: BorderRadius.circular(w(context, 12)),
              ),
            ),
          );
        },
      );
    } else {
      // Fonts 
      final fonts = ["Roboto","Anton","Carter One","Dela Gothic One","Goblin One"];
      return GridView.builder(
        padding: EdgeInsets.all(w(context, 16)),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3,
        ),
        itemCount: fonts.length,
        itemBuilder: (_, index) {
          final font = fonts[index];
          final isSelected = _selectedFont == font;
          return GestureDetector(
            onTap: () => setState(() => _selectedFont = font),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFB5FF3E) : Colors.grey[800],
                borderRadius: BorderRadius.circular(w(context, 12)),
              ),
              child: Text(
                "Sample",
                style: GoogleFonts.getFont(font, textStyle: TextStyle(color: Colors.white, fontSize: w(context, 18))),
              ),
            ),
          );
        },
      );
    }
  }
}

