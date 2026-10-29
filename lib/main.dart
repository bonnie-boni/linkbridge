import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const LinkBridgeApp());

class AppColors {
  static const navy = Color(0xFF0B1020);
  static const navyLight = Color(0xFF111A2E);
  static const panel = Color(0xFF151F35);
  static const panelRaised = Color(0xFF1B2740);
  static const purple = Color(0xFF9B7BFF);
  static const purpleDark = Color(0xFF7654E8);
  static const text = Color(0xFFE3E7F0);
  static const muted = Color(0xFF929DB2);
  static const border = Color(0xFF293650);
  static const green = Color(0xFF5DD6A0);
  static const amber = Color(0xFFFFC56D);
  static const red = Color(0xFFFF7D8A);
}

class LinkBridgeApp extends StatelessWidget {
  const LinkBridgeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'LinkBridge',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.navy,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        brightness: Brightness.dark,
        primary: AppColors.purple,
        surface: AppColors.panel,
        error: AppColors.red,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.text,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.text,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: AppColors.text,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.text, fontSize: 14),
        bodyMedium: TextStyle(color: AppColors.muted, fontSize: 13),
      ),
      cardTheme: CardThemeData(
        color: AppColors.panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.navyLight,
        hintStyle: const TextStyle(color: AppColors.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purpleDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    home: const AppShell(),
  );
}

class NavItem {
  final String label;
  final IconData icon;
  const NavItem(this.label, this.icon);
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;
  final items = const [
    NavItem('Overview', Icons.space_dashboard_outlined),
    NavItem('Devices', Icons.devices_outlined),
    NavItem('Send files', Icons.drive_folder_upload_outlined),
    NavItem('Clipboard', Icons.content_paste_outlined),
    NavItem('Transfers', Icons.swap_vert_circle_outlined),
    NavItem('Settings', Icons.settings_outlined),
  ];
  late final pages = <Widget>[
    OverviewPage(onNavigate: (i) => setState(() => selectedIndex = i)),
    const DevicesPage(),
    const SendFilesPage(),
    const ClipboardPage(),
    const TransfersPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Row(
      children: [
        Container(
          width: 232,
          decoration: const BoxDecoration(
            color: AppColors.navyLight,
            border: Border(right: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 22, 18, 28),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.purple.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.hub_rounded,
                          color: AppColors.purple,
                        ),
                      ),
                      const SizedBox(width: 11),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LinkBridge',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'LOCAL • CONNECTED',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 9,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'WORKSPACE',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ...List.generate(items.length, (i) {
                  final item = items[i];
                  final active = selectedIndex == i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => selectedIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.purple.withValues(alpha: 0.14)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: active
                                ? AppColors.purple.withValues(alpha: 0.28)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 19,
                              color: active
                                  ? AppColors.purple
                                  : AppColors.muted,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              item.label,
                              style: TextStyle(
                                color: active
                                    ? AppColors.text
                                    : AppColors.muted,
                                fontWeight: active
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: AppColors.panel,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.wifi, color: AppColors.green, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Local network',
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Ready to discover devices',
                        style: TextStyle(color: AppColors.muted, fontSize: 11),
                      ),
                      SizedBox(height: 9),
                      Text(
                        'NETWORKING NOT ENABLED',
                        style: TextStyle(
                          color: AppColors.amber,
                          fontSize: 9,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 0, 22, 18),
                  child: Text(
                    'LinkBridge • v0.1.0',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Text(
                      items[selectedIndex].label,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.desktop_windows_outlined,
                      color: AppColors.muted,
                      size: 17,
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      'This Linux device',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                    const SizedBox(width: 18),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.panelRaised,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.computer,
                        color: AppColors.purple,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(index: selectedIndex, children: pages),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class PageContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final List<Widget> actions;
  const PageContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions = const [],
  });
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 7),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            ...actions,
          ],
        ),
        const SizedBox(height: 26),
        child,
      ],
    ),
  );
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.panel,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const SectionTitle(this.title, {super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const Spacer(),
      if (trailing != null)
        Text(
          trailing!,
          style: const TextStyle(color: AppColors.purple, fontSize: 12),
        ),
    ],
  );
}

class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const StatusPill(this.label, {super.key, this.color = AppColors.amber});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(30),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: AppColors.purple, size: 30),
          ),
          const SizedBox(height: 17),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}

class OverviewPage extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  const OverviewPage({super.key, required this.onNavigate});
  @override
  Widget build(BuildContext context) => PageContent(
    title: 'Good to see you.',
    subtitle: 'Move files and clipboard content between your devices, locally.',
    actions: [
      ElevatedButton.icon(
        onPressed: () => onNavigate(1),
        icon: const Icon(Icons.radar, size: 18),
        label: const Text('Discover devices'),
      ),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF29204F), Color(0xFF171D38), AppColors.panel],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusPill(
                      'Local-first transfer',
                      color: AppColors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your devices,\none connected space.',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Transfer files over your local network without relying on cloud storage.',
                      style: TextStyle(color: AppColors.muted, height: 1.5),
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: () => onNavigate(1),
                      icon: const Icon(Icons.add_link, size: 17),
                      label: const Text('Pair a device'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 115,
                height: 115,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.devices_rounded,
                  size: 60,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Your workspace'),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, c) {
            final n = c.maxWidth > 850 ? 3 : (c.maxWidth > 540 ? 2 : 1);
            final w = (c.maxWidth - (n - 1) * 14) / n;
            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _StatCard(
                  width: w,
                  icon: Icons.devices,
                  label: 'Devices online',
                  value: '0',
                  note: 'No devices paired',
                  color: AppColors.purple,
                ),
                _StatCard(
                  width: w,
                  icon: Icons.swap_horiz,
                  label: 'Transfers today',
                  value: '0',
                  note: 'Ready when you are',
                  color: AppColors.green,
                ),
                _StatCard(
                  width: w,
                  icon: Icons.content_paste,
                  label: 'Clipboard sync',
                  value: 'Off',
                  note: 'Manual mode available',
                  color: AppColors.amber,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        const SectionTitle('Recent activity', trailing: 'Nothing yet'),
        const SizedBox(height: 14),
        const Panel(
          child: Row(
            children: [
              Icon(Icons.history, color: AppColors.muted, size: 22),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No recent transfers',
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Your file activity will appear here once transfers are enabled.',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              StatusPill('Waiting'),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StatCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String label;
  final String value;
  final String note;
  final Color color;
  const _StatCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
    required this.note,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note,
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});
  @override
  Widget build(BuildContext context) => PageContent(
    title: 'Devices',
    subtitle:
        'Discover devices on your local network and manage trusted pairings.',
    actions: [
      ElevatedButton.icon(
        onPressed: () =>
            showInfo(context, 'Device discovery service is not connected yet.'),
        icon: const Icon(Icons.radar, size: 18),
        label: const Text('Scan network'),
      ),
    ],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Panel(
          child: Row(
            children: [
              Icon(Icons.wifi_find, color: AppColors.purple, size: 28),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to discover',
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Devices will be discovered when they run LinkBridge on the same Wi-Fi or hotspot.',
                      style: TextStyle(color: AppColors.muted, height: 1.5),
                    ),
                  ],
                ),
              ),
              StatusPill('Demo mode'),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const SectionTitle('Available devices'),
        const SizedBox(height: 12),
        const Panel(
          child: EmptyState(
            icon: Icons.devices_other,
            title: 'No devices found yet',
            message: 'Connect another device to the same local network. Discovery and secure pairing will be added next.',
          ),
        ),
        const SizedBox(height: 22),
        const SectionTitle('Trusted devices'),
        const SizedBox(height: 12),
        const Panel(
          child: Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: AppColors.muted,
                size: 22,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Paired devices will appear here. You will be able to revoke trust at any time.',
                  style: TextStyle(color: AppColors.muted, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class SendFilesPage extends StatefulWidget {
  const SendFilesPage({super.key});

  @override
  State<SendFilesPage> createState() => _SendFilesPageState();
}

class _SendFilesPageState extends State<SendFilesPage> {
  String? file;
  String? destination;

  @override
  Widget build(BuildContext context) {
    return PageContent(
      title: 'Send files',
      subtitle: 'Choose a file, select a trusted device, and send it directly.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('1. Choose a file'),
                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 26,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.navyLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.upload_file,
                        size: 38,
                        color: AppColors.purple,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        file ?? 'No file selected',
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Demo selector only. Native file picker comes next.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            file = 'example-document.pdf (demo)';
                          });
                        },
                        child: const Text('Choose demo file'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),
                const SectionTitle('2. Select destination'),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: destination,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.devices_outlined),
                    hintText: 'Choose a paired device',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'android',
                      child: Text('Android phone (demo)'),
                    ),
                    DropdownMenuItem(
                      value: 'windows',
                      child: Text('Windows PC (demo)'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      destination = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: file != null && destination != null
                        ? () {
                            showInfo(
                              context,
                              'UI demo only: transfer service is not implemented yet.',
                            );
                          }
                        : null,
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Start transfer'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.green, size: 18),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Design goal: local transfers with verified device identity and integrity checks.',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ClipboardPage extends StatefulWidget {
  const ClipboardPage({super.key});
  @override
  State<ClipboardPage> createState() => _ClipboardPageState();
}

class _ClipboardPageState extends State<ClipboardPage> {
  final controller = TextEditingController();
  bool syncEnabled = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> copyText() async {
    await Clipboard.setData(ClipboardData(text: controller.text));
    if (!mounted) return;
    showInfo(context, 'Text copied to this computer’s clipboard.');
  }

  @override
  Widget build(BuildContext context) => PageContent(
    title: 'Clipboard',
    subtitle:
        'Review text locally and prepare it for sharing with a paired device.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Clipboard workspace'),
              const SizedBox(height: 8),
              const Text(
                'This editor is local to this app. Cross-device clipboard sync is not connected yet.',
                style: TextStyle(color: AppColors.muted, height: 1.5),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                minLines: 8,
                maxLines: 14,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Paste or type text you want to work with…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.text.isEmpty ? null : copyText,
                    icon: const Icon(Icons.content_copy, size: 17),
                    label: const Text('Copy to local clipboard'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      controller.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.delete_outline, size: 17),
                    label: const Text('Clear editor'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Panel(
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: syncEnabled,
            onChanged: (v) => setState(() => syncEnabled = v),
            activeThumbColor: AppColors.purple,
            title: const Text(
              'Enable clipboard sync',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'UI preference only; background sync is not implemented yet.',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ),
        ),
      ],
    ),
  );
}

class TransfersPage extends StatefulWidget {
  const TransfersPage({super.key});
  @override
  State<TransfersPage> createState() => _TransfersPageState();
}

class _TransfersPageState extends State<TransfersPage> {
  String filter = 'All';
  @override
  Widget build(BuildContext context) => PageContent(
    title: 'Transfers',
    subtitle: 'Monitor progress and review your transfer history.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: ['All', 'In progress', 'Completed', 'Failed'].map((item) {
            final selected = filter == item;
            return ChoiceChip(
              label: Text(item),
              selected: selected,
              onSelected: (_) => setState(() => filter = item),
              selectedColor: AppColors.purple.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: selected ? AppColors.text : AppColors.muted,
              ),
              side: BorderSide(
                color: selected ? AppColors.purple : AppColors.border,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        const Panel(
          child: EmptyState(
            icon: Icons.swap_horiz_rounded,
            title: 'Nothing to show yet',
            message: 'Transfer progress, destination, file size and results will appear here once the transfer service is implemented.',
          ),
        ),
        const SizedBox(height: 18),
        const Panel(
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.purple),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Transfer history will be stored locally. Persistent history will be added after the transfer service is ready.',
                  style: TextStyle(color: AppColors.muted, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool launchAtStartup = false, notifications = true, confirmIncoming = true;
  @override
  Widget build(BuildContext context) => PageContent(
    title: 'Settings',
    subtitle: 'Configure your local sharing experience.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('General'),
        const SizedBox(height: 12),
        Panel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SettingRow(
                icon: Icons.rocket_launch_outlined,
                title: 'Launch at startup',
                description: 'Open LinkBridge when you sign in.',
                value: launchAtStartup,
                onChanged: (v) => setState(() => launchAtStartup = v),
              ),
              const Divider(height: 1),
              SettingRow(
                icon: Icons.notifications_none,
                title: 'Desktop notifications',
                description: 'Show transfer and connection notifications.',
                value: notifications,
                onChanged: (v) => setState(() => notifications = v),
              ),
              const Divider(height: 1),
              SettingRow(
                icon: Icons.verified_user_outlined,
                title: 'Confirm incoming transfers',
                description: 'Ask before accepting files from another device.',
                value: confirmIncoming,
                onChanged: (v) => setState(() => confirmIncoming = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Connection'),
        const SizedBox(height: 12),
        const Panel(
          child: Column(
            children: [
              InfoRow(
                label: 'Connection mode',
                value: 'Local network (planned)',
              ),
              Divider(height: 22),
              InfoRow(label: 'Device discovery', value: 'Not implemented'),
              Divider(height: 22),
              InfoRow(label: 'Encryption', value: 'Required before transfers'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('Appearance'),
        const SizedBox(height: 12),
        const Panel(
          child: Row(
            children: [
              Icon(Icons.palette_outlined, color: AppColors.purple, size: 22),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Midnight purple',
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Navy backgrounds · Gray text · Purple accents',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              StatusPill('Active', color: AppColors.green),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'These preferences currently last only while the app is open. Startup integration and saved settings will be added later.',
          style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5),
        ),
      ],
    ),
  );
}

class SettingRow extends StatelessWidget {
  final IconData icon;
  final String title, description;
  final bool value;
  final ValueChanged<bool> onChanged;
  const SettingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    child: Row(
      children: [
        Icon(icon, color: AppColors.muted, size: 21),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    ),
  );
}

class InfoRow extends StatelessWidget {
  final String label, value;
  const InfoRow({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(label, style: const TextStyle(color: AppColors.muted)),
      ),
      Text(
        value,
        style: const TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

void showInfo(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
