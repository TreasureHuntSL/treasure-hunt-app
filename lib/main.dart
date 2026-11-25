
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl =
    'https://mntfywvzfuwsnsbvmota.supabase.co';

const String supabasePublishableKey =
    'sb_publishable_Wrx_uQtAGWQ2uWwx9wyzVg_T8ZYCxtY';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabasePublishableKey,
    );

    runApp(const TreasureHuntApp());
  } catch (e) {
    runApp(StartupErrorApp(error: e.toString()));
  }
}

class TreasureHuntApp extends StatelessWidget {
  const TreasureHuntApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Treasure Hunt',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class StartupErrorApp extends StatelessWidget {
  final String error;

  const StartupErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF101010),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'App initialization failed:\n$error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    TreasurePage(),
    HuntersPage(),
    PinPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TREASURE HUNT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Hunters',
          ),
          NavigationDestination(
            icon: Icon(Icons.key_outlined),
            selectedIcon: Icon(Icons.key),
            label: 'Enter PIN',
          ),
        ],
      ),
    );
  }
}

class TreasurePage extends StatelessWidget {
  const TreasurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(height: 10),
        const Icon(
          Icons.workspace_premium,
          color: Colors.amber,
          size: 75,
        ),
        const SizedBox(height: 15),
        const Text(
          'Find The Treasure!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Explore. Discover. Win.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 25),
        const TreasureCard(
          title: 'Golden Treasure',
          reward: 'Cash Reward',
          description: 'Follow the clues and discover the hidden treasure.',
          icon: Icons.diamond,
        ),
        const SizedBox(height: 15),
        const TreasureCard(
          title: 'Mystery Box',
          reward: 'Special Gift',
          description: 'A mysterious reward is waiting for the winner.',
          icon: Icons.card_giftcard,
        ),
        const SizedBox(height: 20),
        const Text(
          'Treasure information shown here is demo content.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54),
        ),
      ],
    );
  }
}

class TreasureCard extends StatelessWidget {
  final String title;
  final String reward;
  final String description;
  final IconData icon;

  const TreasureCard({
    super.key,
    required this.title,
    required this.reward,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF252525),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Colors.amber),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(reward),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70),
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

class HuntersPage extends StatelessWidget {
  const HuntersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hunters = [
      {'name': 'Hunter One', 'distance': '2.4 km'},
      {'name': 'Hunter Two', 'distance': '5.1 km'},
      {'name': 'Hunter Three', 'distance': '8.7 km'},
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Nearby Hunters',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hunters within 10 km',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        ...hunters.map(
          (hunter) => Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(hunter['name']!),
              trailing: Text(hunter['distance']!),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          'Demo hunters only. Live GPS locations will be added later.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.orangeAccent),
        ),
      ],
    );
  }
}

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController pinController =
      TextEditingController();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  void submitPin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'PIN verification will be connected to the server.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_open,
            color: Colors.amber,
            size: 75,
          ),
          const SizedBox(height: 20),
          const Text(
            'Enter Treasure PIN',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Secret PIN',
              prefixIcon: Icon(Icons.key),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submitPin,
              child: const Text('VERIFY PIN'),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Server verification will be added in the next phase.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
