import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_model.dart';
import 'theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    final client = HttpClient();
    try {
      final request = await client
          .getUrl(Uri.parse('https://jsonplaceholder.typicode.com/users'))
          .timeout(const Duration(seconds: 15));
      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> jsonData = json.decode(responseBody);
        return jsonData.map((item) => User.fromJson(item)).toList();
      }

      throw Exception('Failed to load users from API');
    } finally {
      client.close(force: true);
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open $urlString')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Directory'),
        actions: [
          Row(
            children: [
              Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  leading: CircleAvatar(child: Text('${user.id}')),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user.email),
                  childrenPadding: const EdgeInsets.all(16.0),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.account_circle, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Username: ${user.username}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Address: ${user.address}')),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          // Normal Press: KRS Instagram
          _launchUrl('https://www.instagram.com/kiit_robotics.society');
        },
        onLongPress: () {
          // Long Press / Hold: KRS Website
          _launchUrl('https://krs.kiit.ac.in/');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.link,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'KRS Links',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
