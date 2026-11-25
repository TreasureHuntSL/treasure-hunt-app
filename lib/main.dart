
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
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Connection error:\n$error'),
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

  final pages = const [
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
          setState(() => selectedIndex = index);
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

class TreasurePage extends StatefulWidget {
  const TreasurePage({super.key});

  @override
  State<TreasurePage> createState() => _TreasurePageState();
}

class _TreasurePageState extends State<TreasurePage> {
  late Future<List<Map<String, dynamic>>> treasures;

  @override
  void initState() {
    super.initState();
    loadTreasures();
  }

  void loadTreasures() {
    treasures = Supabase.instance.client
        .from('treasures')
        .select(
          'id, title, description, reward, clue, is_active, created_at',
        )
        .eq('is_active', true)
        .order('created_at', ascending: false);
  }

  Future<void> refreshTreasures() async {
    setState(loadTreasures);
    await treasures;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshTreasures,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: treasures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          if (snapshot.hasError) {
            return ListView(
              padding: const EdgeInsets.all(25),
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Could not load treasures',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(loadTreasures);
                  },
                  child: const Text('TRY AGAIN'),
                ),
              ],
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(25),
              children: const [
                SizedBox(height: 50),
                Icon(
                  Icons.workspace_premium,
                  color: Colors.amber,
                  size: 75,
                ),
                SizedBox(height: 20),
                Text(
                  'No Active Treasures Yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'New treasure hunts will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Icon(
                Icons.workspace_premium,
                color: Colors.amber,
                size: 65,
              ),
              const Text(
                'Find The Treasure!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...items.map((item) => TreasureCard(item: item)),
            ],
          );
        },
      ),
    );
  }
}

class TreasureCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const TreasureCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final title = item['title']?.toString() ?? 'Treasure';
    final description =
        item['description']?.toString() ?? '';
    final reward = item['reward']?.toString() ?? '';
    final clue = item['clue']?.toString() ?? '';

    return Card(
      color: const Color(0xFF252525),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.diamond,
              color: Colors.amber,
              size: 42,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(description),
            ],
            if (reward.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Reward: $reward',
                style: const TextStyle(color: Colors.amber),
              ),
            ],
            if (clue.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('Clue: $clue'),
            ],
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
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 65, color: Colors.amber),
            SizedBox(height: 15),
            Text(
              'Nearby Hunters',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Live GPS and nearby hunter sharing '
              'will be connected in the next phase.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
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
          const SizedBox(height: 20),
          TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Secret PIN',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Secure server PIN verification '
            'will be added in the next phase.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
