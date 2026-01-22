import 'package:flutter/material.dart';

/// Écran des paramètres de l'application
/// 
/// Permet de configurer:
/// - Préférences d'affichage
/// - Configuration de l'IA
/// - Gestion du stockage
/// - À propos de l'application
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _keepScreenOn = true;
  bool _autoAnalyzeNewSongs = true;
  String _storageLocation = 'Par défaut';
  final _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Affichage',
            children: [
              SwitchListTile(
                title: const Text('Mode sombre'),
                subtitle: const Text('Activer le thème sombre'),
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                  // TODO: Implémenter le changement de thème
                },
              ),
              SwitchListTile(
                title: const Text('Garder l\'écran allumé'),
                subtitle: const Text('Empêche l\'écran de se mettre en veille pendant la lecture'),
                value: _keepScreenOn,
                onChanged: (value) {
                  setState(() {
                    _keepScreenOn = value;
                  });
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            title: 'Intelligence Artificielle',
            children: [
              ListTile(
                title: const Text('Clé API OpenAI'),
                subtitle: const Text('Configurer pour activer l\'analyse IA'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showApiKeyDialog,
              ),
              SwitchListTile(
                title: const Text('Analyse automatique'),
                subtitle: const Text('Analyser automatiquement les nouvelles partitions'),
                value: _autoAnalyzeNewSongs,
                onChanged: (value) {
                  setState(() {
                    _autoAnalyzeNewSongs = value;
                  });
                },
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            title: 'Stockage',
            children: [
              ListTile(
                title: const Text('Emplacement de stockage'),
                subtitle: Text(_storageLocation),
                trailing: const Icon(Icons.chevron_right),
                onTap: _changeStorageLocation,
              ),
              ListTile(
                title: const Text('Gérer le stockage'),
                subtitle: const Text('Voir l\'utilisation et nettoyer le cache'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showStorageManagement,
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            title: 'Bibliothèque',
            children: [
              ListTile(
                title: const Text('Importer depuis un dossier'),
                subtitle: const Text('Importer plusieurs partitions à la fois'),
                trailing: const Icon(Icons.folder_open),
                onTap: _importFromFolder,
              ),
              ListTile(
                title: const Text('Exporter la bibliothèque'),
                subtitle: const Text('Sauvegarder toutes vos partitions'),
                trailing: const Icon(Icons.upload),
                onTap: _exportLibrary,
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            title: 'À propos',
            children: [
              ListTile(
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: const Text('Licences'),
                subtitle: const Text('Voir les licences open source'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showLicenses,
              ),
              ListTile(
                title: const Text('Documentation'),
                subtitle: const Text('Guide d\'utilisation et aide'),
                trailing: const Icon(Icons.help_outline),
                onTap: _showDocumentation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  void _showApiKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clé API OpenAI'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entrez votre clé API OpenAI pour activer les fonctionnalités d\'analyse IA.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Clé API',
                border: OutlineInputBorder(),
                hintText: 'sk-...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Sauvegarder la clé API de manière sécurisée
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clé API enregistrée'),
                ),
              );
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _changeStorageLocation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emplacement de stockage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Par défaut'),
              value: 'Par défaut',
              groupValue: _storageLocation,
              onChanged: (value) {
                setState(() {
                  _storageLocation = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Personnalisé'),
              value: 'Personnalisé',
              groupValue: _storageLocation,
              onChanged: (value) {
                setState(() {
                  _storageLocation = value!;
                });
                Navigator.pop(context);
                // TODO: Ouvrir le sélecteur de dossier
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStorageManagement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gestion du stockage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Utilisation du stockage:'),
            const SizedBox(height: 16),
            _buildStorageItem('Partitions', '125 MB'),
            _buildStorageItem('Annotations', '2.3 MB'),
            _buildStorageItem('Cache', '15 MB'),
            const Divider(),
            _buildStorageItem('Total', '142.3 MB', isBold: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implémenter le nettoyage du cache
              Navigator.pop(context);
            },
            child: const Text('Nettoyer le cache'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(String label, String size, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            size,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _importFromFolder() {
    // TODO: Implémenter l'importation depuis un dossier
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonction d\'importation de dossier à implémenter'),
      ),
    );
  }

  void _exportLibrary() {
    // TODO: Implémenter l'exportation de la bibliothèque
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonction d\'exportation à implémenter'),
      ),
    );
  }

  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'SongBook',
      applicationVersion: '1.0.0',
    );
  }

  void _showDocumentation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Documentation'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guide d\'utilisation rapide',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Importez vos partitions (PDF ou MusicXML)'),
              Text('2. Organisez votre bibliothèque avec des tags'),
              Text('3. Ajoutez des annotations sur vos partitions'),
              Text('4. Utilisez le mode scène pour vos performances'),
              SizedBox(height: 16),
              Text(
                'Fonctionnalités IA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('- Détection automatique de la tonalité'),
              Text('- Analyse des accords'),
              Text('- Identification de la structure'),
              Text('- Suggestions d\'amélioration'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
