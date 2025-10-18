import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:countdown_app/models/countdown_item.dart';
import 'package:countdown_app/widgets/color_picker.dart';
import '../utils/helper.dart';

class IconPickerDialog extends StatelessWidget {
  final IconData initial;
  const IconPickerDialog({super.key, required this.initial});

  @override
  Widget build(BuildContext context) {
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

    return AlertDialog(
      backgroundColor: const Color(0xFF1D1D1F),
      title: const Text("Pick an Icon", style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: icons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final icon = icons[index];
            return GestureDetector(
              onTap: () => Navigator.pop(context, icon),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: icon == initial ? Color(0xFFB5FF3E) : Colors.grey[800],
                ),
                child: Icon(icon, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WriteEmptyPage extends StatefulWidget {
  final CountdownItem? item;
  final bool fromCreateWidget;
  const WriteEmptyPage({super.key, this.item, this.fromCreateWidget = false});

  @override
  State<WriteEmptyPage> createState() => _WriteEmptyPageState();
}

class _WriteEmptyPageState extends State<WriteEmptyPage> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _noteController;

  DateTime? _selectedDate;
  Color _selectedColor = const Color(0xFFB5FF3E);
  IconData _selectedIcon = LucideIcons.smile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? "");
    _noteController = TextEditingController(text: widget.item?.note ?? "");
    _dateController = TextEditingController();

    if (widget.item != null) {
      _selectedDate = widget.item!.target;
      _selectedColor = widget.item!.color ?? const Color(0xFFB5FF3E);
      _selectedIcon = widget.item!.icon ?? LucideIcons.smile;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedDate != null) {
      _dateController.text =
          "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} "
          "${TimeOfDay.fromDateTime(_selectedDate!).format(context)}";
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFB5FF3E),
              onPrimary: Colors.black,
              surface: Color(0xFF1D1D1F),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: const TimePickerThemeData(
              dialHandColor: Color(0xFFB5FF3E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || pickedTime == null) return;

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      _dateController.text =
          "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} "
          "${pickedTime.format(context)}";
    });
  }

  Widget _buildPreviewCard(BuildContext context) {
    final daysLeft = _selectedDate == null
        ? 0
        : _selectedDate!.difference(DateTime.now()).inDays;

    return SizedBox(
      width: 375,
      height: 144,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8),
        child: Container(
          width: 343,
          height: 96,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _selectedColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: _selectedColor,
                child: Icon(
                  _selectedIcon,
                  size: 24,
                  color: _selectedColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _titleController.text.isEmpty
                        ? "Title"
                        : _titleController.text,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Text(
                    _selectedDate == null
                        ? "Pick a date"
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  Text(
                    "$daysLeft Days left",
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveItem() {
    if (_titleController.text.isEmpty || _selectedDate == null) return;

    final newItem = CountdownItem(
      title: _titleController.text,
      target: _selectedDate!,
      color: _selectedColor,
      icon: _selectedIcon,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;
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
                
                // Title 
                Text( 
                  isEditing ? "Edit Event" : "New Event", 
                  style: TextStyle( 
                    color: Colors.white, 
                    fontSize: h(context, 19), 
                    fontWeight: FontWeight.bold, 
                  ), 
                ),

                const Spacer(),

                // Save button
                GestureDetector(
                  onTap: _saveItem,
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
                  const SizedBox(height: 18),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 6),

                  // Preview card
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w(context, 16),
                      vertical: h(context, 16),
                    ),
                    child: _buildPreviewCard(context),
                  ),

                  const SizedBox(height: 18),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 6),

                  // Title
                  Padding(
                    padding: EdgeInsets.only(left: w(context, 16)),
                    child: SizedBox(
                      height: h(context, 32),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "1. Title",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h(context, 8)),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: w(context, 16)),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: h(context, 56),
                            child: TextField(
                              controller: _titleController,
                              style:
                                  const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Birthday, Trip, Holiday...",
                                hintStyle:
                                    const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: const Color(0xFF2C2C2E),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFB5FF3E), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFB5FF3E), width: 2),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: w(context, 12),
                                    vertical: h(context, 16)),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ),
                        SizedBox(width: w(context, 8)),
                        IconButton(
                          icon: const Icon(Icons.check_circle,
                              color: Color(0xFFB5FF3E), size: 28),
                          onPressed: () {
                            final title =
                                _titleController.text.trim();
                            if (title.isNotEmpty) {
                              setState(() {
                                _titleController.text = title;
                              });
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 6),

                  // Date & Time
                  Padding(
                    padding: EdgeInsets.only(left: w(context, 16)),
                    child: SizedBox(
                      height: h(context, 32),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "2. Date & Time",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h(context, 8)),

                  Padding(
                    padding:
                      EdgeInsets.symmetric(horizontal: w(context, 16)),
                    child: SizedBox(
                      height: h(context, 56),
                      child: TextField(
                        readOnly: true,
                        onTap: _pickDateTime,
                        style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                          hintText: "Select date & time",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFF2C2C2E),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFB5FF3E), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFB5FF3E), width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: w(context, 12),
                              vertical: h(context, 16)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 6),

                  // Color picker
                  Padding(
                    padding: EdgeInsets.only(left: w(context, 16)),
                    child: SizedBox(
                      height: h(context, 32),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "3. Color",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h(context, 8)),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: w(context, 16)),
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDialog<Color>(
                          context: context,
                          builder: (context) =>
                              ColorPickerDialog(initial: _selectedColor),
                        );
                        if (picked != null) {
                          setState(() => _selectedColor = picked);
                        }
                      },
                      child: Container(
                        height: h(context, 56),
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFB5FF3E),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Tap to pick color",
                            style: TextStyle(
                              color: _selectedColor.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 6),

                  // Icon picker
                  Padding(
                    padding: EdgeInsets.only(left: w(context, 16)),
                    child: SizedBox(
                      height: h(context, 32),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "4. Icon",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h(context, 8)),
                  
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: w(context, 16)),
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDialog<IconData>(
                          context: context,
                          builder: (context) =>
                              IconPickerDialog(initial: _selectedIcon),
                        );
                        if (picked != null) {
                          setState(() => _selectedIcon = picked);
                        }
                      },
                      child: Container(
                        height: h(context, 56),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFB5FF3E),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(_selectedIcon, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Divider(height: 1, color: Colors.white10),
                  const SizedBox(height: 6),

                  // Note
                  Padding(
                    padding: EdgeInsets.only(left: w(context, 16)),
                    child: SizedBox(
                      height: h(context, 32),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "5. Note",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h(context, 8)),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: w(context, 16)),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: h(context, 120),
                            child: TextField(
                              controller: _noteController,
                              style:
                                  const TextStyle(color: Colors.white),
                              minLines: 3,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: "Optional note...",
                                hintStyle:
                                    const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: const Color(0xFF2C2C2E),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFB5FF3E), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFB5FF3E), width: 2),
                                ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: w(context, 12),
                                    vertical: h(context, 16)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: w(context, 8)),
                        IconButton(
                          icon: const Icon(Icons.check_circle,
                            color: Color(0xFFB5FF3E), size: 28),
                          onPressed: () {
                            final note =
                                _noteController.text.trim();
                            if (note.isNotEmpty) {
                              setState(() {
                                _noteController.text = note;
                              });
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
