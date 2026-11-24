
import 'package:flutter/material.dart';

void main() {
  runApp(const TreasureHuntApp());
}

class TreasureHuntApp extends StatelessWidget {
  const TreasureHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Treasure Hunt',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF10131B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC247),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  bool sinhala = true;

  String get t => sinhala ? 'නිධන් සෙවීම' : 'Treasure Hunt';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '💎 TREASURE HUNT',
          style: TextStyle(
            color: Color(0xFFFFC247),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => sinhala = !sinhala),
            child: Text(sinhala ? 'EN' : 'සිං'),
          ),
        ],
      ),
      body: IndexedStack(
        index: tab,
        children: [
          homePage(),
          huntersPage(),
          const PinPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: sinhala ? 'මුල් පිටුව' : 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_alt_outlined),
            label: sinhala ? 'Hunters' : 'Hunters',
          ),
          NavigationDestination(
            icon: const Icon(Icons.lock_outline),
            label: 'PIN',
          ),
        ],
      ),
    );
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(t, style: const TextStyle(
          fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(sinhala
            ? 'සැබෑ ලෝකයේ නිධන් සොයා ජයග්‍රහණය කරන්න!'
            : 'Find real treasures. Win real rewards!'),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF76501C), Color(0xFF292016)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.diamond,
                  size: 45, color: Color(0xFFFFD36B)),
              const SizedBox(height: 12),
              Text(
                sinhala ? 'ඔබේ Treasure Hunt එක අරඹන්න'
                    : 'Start Your Treasure Hunt',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(sinhala
                  ? 'සිතියම හරහා Treasure සොයා යන්න.'
                  : 'Explore the map and find hidden treasures.'),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () => setState(() => tab = 1),
                child: Text(sinhala ? 'Hunters බලන්න' : 'Explore Hunters'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          sinhala ? 'Active Treasure Hunts' : 'Active Treasure Hunts',
          style: const TextStyle(
              fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        treasureCard('Golden Treasure', 'Cash Reward'),
        treasureCard('Mystery Box', 'Special Gift'),
        const SizedBox(height: 18),
        Text(sinhala
            ? 'ඔබගේ ආරක්ෂාව සහ අවසරය සහිතව Location භාවිතා කෙරේ.'
            : 'Location sharing requires your permission.'),
      ],
    );
  }

  Widget treasureCard(String name, String reward) {
    return Card(
      color: const Color(0xFF202532),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF57401D),
          child: Icon(Icons.inventory_2, color: Color(0xFFFFC247)),
        ),
        title: Text(name),
        subtitle: Text(reward),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget huntersPage() {
    final hunters = [
      ['🧑', 'Hunter One', '2.4 km'],
      ['👩', 'Hunter Two', '5.1 km'],
      ['🧔', 'Hunter Three', '8.7 km'],
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Nearby Hunters',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Hunters within 10 KM'),
        const SizedBox(height: 18),
        ...hunters.map((h) => Card(
          color: const Color(0xFF202532),
          child: ListTile(
            leading: CircleAvatar(child: Text(h[0])),
            title: Text(h[1]),
            subtitle: const Text('Active Hunter'),
            trailing: Text(h[2],
                style: const TextStyle(color: Color(0xFFFFC247))),
          ),
        )),
        const SizedBox(height: 12),
        const Text(
          'Demo hunters only. Live GPS and real player locations '
          'will be connected in the next development phase.',
          style: TextStyle(color: Colors.orangeAccent),
        ),
      ],
    );
  }
}

class PinPage extends StatelessWidget {
  const PinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pin = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 65, color: Color(0xFFFFC247)),
          const SizedBox(height: 20),
          const Text('Treasure PIN Verification',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: pin,
            keyboardType: TextInputType.number,
            maxLength: 8,
            decoration: const InputDecoration(
              labelText: 'Enter Secret PIN',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.password),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PIN verification will be connected to server.'),
                ),
              );
            },
            child: const Text('Verify PIN'),
          ),
        ],
      ),
    );
  }
}
