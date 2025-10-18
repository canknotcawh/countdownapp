import 'package:countdown_app/utils/helper.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _allowNotifications = true;

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
                  "Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: h(context, 19),
                  ),
                ),
                const Spacer()
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w(context, 16),
                      vertical: h(context, 16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Upgrade
                        SizedBox(
                          width: w(context, 343),
                          height: h(context, 110),
                          child: Card(
                            color: const Color(0xFF222225),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Upgrade",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              height: 1.0,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "Ticky",
                                            style: TextStyle(
                                              color: Color(0xFFB5FF3E),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                              height: 1.0,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "Unlock all features",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              height: 1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.rocket_launch,
                                        color: Colors.redAccent, size: 50),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Support + FAQ
                        Row(
                          children: [
                            // Support
                            Expanded(
                              child: SizedBox(
                                width: w(context, 164),
                                height: h(context, 114),
                                child: Card(
                                  color: const Color(0xFF222225),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Icon(Icons.info_outline,
                                              color: Color(0xFFB5FF3E), size: 24),
                                          SizedBox(height: 6),
                                          Text(
                                            "Support",
                                            style: TextStyle(
                                              color: Color(0xFFB5FF3E),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "Help and \nTroubleshooting",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              height: 1.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),                              
                            ),

                            const SizedBox(width: 8),

                            // FAQ
                            Expanded(
                              child: SizedBox(
                                width: w(context, 164),
                                height: h(context, 114),
                                child: Card(
                                  color: const Color(0xFF222225),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Icon(Icons.question_mark,
                                              color: Color(0xFFB5FF3E), size: 24),
                                          SizedBox(height: 6),
                                          Text(
                                            "FAQ",
                                            style: TextStyle(
                                              color: Color(0xFFB5FF3E),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "Frequently Asked \nQuestions",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              height: 1.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
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

                        const SizedBox(height: 16),

                        // Notifications
                        const SectionTitle(title: "Notifications"),
                        const SizedBox(height: 8),

                        SizedBox(
                          width: w(context, 343),
                          height: h(context, 56),
                          child: Card(
                            color: const Color(0xFF1E1E1E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SwitchListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: w(context, 12)),
                              secondary: const Icon(Icons.notifications,
                                  color: Colors.white),
                              title: const Text(
                                "Allow Notifications",
                                style: TextStyle(color: Colors.white),
                              ),
                              value: _allowNotifications,
                              onChanged: (val) =>
                                  setState(() => _allowNotifications = val),
                              activeThumbColor: const Color(0xFFB5FF3E),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Info
                        const SectionTitle(title: "Info"),
                        const SizedBox(height: 8),

                        Container(
                          width: w(context, 343),
                          decoration: BoxDecoration(
                            color: Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: const [
                              SettingItem(
                                icon: Icons.privacy_tip,
                                text: "Privacy Policy",
                              ),
                              Divider(height: 1, color: Colors.white10),
                              SettingItem(
                                icon: Icons.article,
                                text: "Terms & Conditions",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // App
                        const SectionTitle(title: "App"),
                        const SizedBox(height: 8),

                        Container(
                          width: w(context, 343),
                          decoration: BoxDecoration(
                            color: Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: const [
                              SettingItem(
                                icon: Icons.share,
                                text: "Share App",
                              ),
                              Divider(height: 1, color: Colors.white10),
                              SettingItem(
                                icon: Icons.star,
                                text: "Rate Ticky",
                              ),
                              Divider(height: 1, color: Colors.white10),
                              SettingItem(
                                icon: Icons.feedback,
                                text: "Feedback",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

// Title bar
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w(context, 343),
      height: h(context, 21),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

// Item
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const SettingItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(text, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      ),
    );
  }
}
