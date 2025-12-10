import 'package:flutter/material.dart';
import 'discount_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedRegion = 'Unspecified';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _start(BuildContext context) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageBuilder(
        name: name,
        region: _selectedRegion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Discount Optimizer'),
        leading: const Icon(Icons.local_offer_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Before we start, please enter your name and choose your VAT region.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // VAT region dropdown
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'VAT region',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRegion,
                  items: const [
                    DropdownMenuItem(
                      value: 'Unspecified',
                      child: Text('Unspecified'),
                    ),
                    DropdownMenuItem(
                      value: 'Lebanon',
                      child: Text('Lebanon'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedRegion = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _selectedRegion == 'Lebanon'
                        ? 'For Lebanon, VAT will be locked at 11%.'
                        : 'If region is unspecified, you can edit the VAT value later.',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _start(context),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Start',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small helper so the transition stays animated and clean
class MaterialPageBuilder extends PageRouteBuilder {
  final String name;
  final String region;

  MaterialPageBuilder({required this.name, required this.region})
      : super(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: DiscountPage(
        userName: name,
        region: region,
      ),
    ),
  );
}
