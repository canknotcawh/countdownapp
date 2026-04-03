import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/countdown_item.dart';
import '../widgets/countdown_card.dart';
import 'details_page.dart';
import 'settings.dart';
import 'write_empty.dart';
import 'create_widget.dart';
import '../utils/helper.dart';
import '../services/countdown_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CountdownItem> _items = [];

  int _isSettingsSelected = 0;
  int _selectedTab = 0;
  int _isEventsSelected = 1;
  int _isWidgetsSelected = 0;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final loaded = await CountdownStorage.loadItems();
    setState(() {
      _items = [...loaded,];
    });
  }
  

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today =
        "${_weekdayName(now.weekday)}, ${now.day} ${_monthName(now.month)}";

    final currentEvents = _items.where((e) => e.target.isAfter(now)).toList();
    final pastEvents = _items.where((e) => e.target.isBefore(now)).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w(context, 16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h(context, 24)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title + Date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Events",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                            ),
                            SizedBox(height: h(context, 4)),
                            Text(
                              today,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),

                        // Get Pro + Settings
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF2D2D30),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFC107),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.workspace_premium,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Get Pro",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: w(context, 12)),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _isSettingsSelected = 1;
                                });
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsScreen()),
                                );
                                setState(() {
                                  _isSettingsSelected = 0;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF222225),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF2D2D30),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.settings,
                                  size: 20,
                                  color: _isSettingsSelected == 1
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: h(context, 24)),

                    // Current + Past
                    Container(
                      width: w(context, 343),
                      height: h(context, 40),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D30),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          // Current
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 0 ? Colors.black : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.calendar_today,
                                            size: 16,
                                            color: _selectedTab == 0
                                                ? Colors.white
                                                : Colors.white70),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Current",
                                          style: TextStyle(
                                            color: _selectedTab == 0
                                                ? Colors.white
                                                : Colors.white70,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Past
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 1 ? Colors.black : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.archive,
                                            size: 16,
                                            color: _selectedTab == 1
                                                ? Colors.white
                                                : Colors.white70),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Past",
                                          style: TextStyle(
                                            color: _selectedTab == 1
                                                ? Colors.white
                                                : Colors.white70,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h(context, 16)),
                  ],
                ),
              ),
            ),

            // SliverList
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final list =
                      _selectedTab == 0 ? currentEvents : pastEvents;
                  final item = list[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      left: w(context, 16),
                      right: w(context, 16),
                      bottom: h(context, 16),
                    ),
                    child: SizedBox(
                      height: h(context, 96),
                      child: CountdownCard(
                        key: ValueKey(
                            item.title + item.target.toIso8601String()),
                        item: item,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailsPage(item: item),
                            ),
                          );
                          setState(() {});
                        },
                        onDelete: () async {
                          _items.remove(item);
                          await CountdownStorage.saveItems(_items);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
                childCount: _selectedTab == 0
                    ? currentEvents.length
                    : pastEvents.length,
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: h(context, 100))),
          ],
        ),
      ),

      // FAB + BottomBar
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: Color(0xFFB5FF3E),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              color: Color(0xFF1D1D1F),
              shape: BoxShape.circle,
            ),
          ),
          FloatingActionButton(
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WriteEmptyPage(),
                ),
              );
              if (created != null && created is CountdownItem) {
                final items = await CountdownStorage.loadItems();
                items.add(created);
                await CountdownStorage.saveItems(items);
                _loadItems();
              }
            },
            backgroundColor: const Color(0xFFB5FF3E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: const BorderSide(
                color: Color(0xFF1D1D1F),
                width: 3,
              ),
            ),
            elevation: 0,
            child: const Icon(
              LucideIcons.plus,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularOuterNotchedShape(extra: 10),
        notchMargin: 0,
        color: const Color(0xFF222225),
        elevation: 8,
        child: SizedBox(
          height: h(context, 90),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w(context, 60)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Events
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEventsSelected = 1;
                      _isWidgetsSelected = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.home,
                        color:
                            _isEventsSelected == 1 ? Colors.white : Colors.grey,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Events",
                        style: TextStyle(
                          color: _isEventsSelected == 1
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Widgets
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateWidgetScreen(),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.layoutGrid,
                        color: _isWidgetsSelected == 1
                            ? Colors.white
                            : Colors.grey,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Widgets",
                        style: TextStyle(
                          color: _isWidgetsSelected == 1
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _weekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}
