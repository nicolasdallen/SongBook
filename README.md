# SongBook

Application Flutter pour la gestion et la lecture de partitions musicales avec annotations et analyse IA.

## 📱 Fonctionnalités

### Gestion des Partitions
- **Importation**: Support des formats PDF et MusicXML
- **Bibliothèque**: Organisation complète avec recherche et filtrage avancé
- **Métadonnées**: Titre, artiste, tonalité, tempo, difficulté, tags
- **Annotations**: Ajout de notes textuelles, dessins et marqueurs sur les partitions

### Lecteur de Partitions
- **Multi-formats**: Lecture de PDF et MusicXML
- **Navigation**: Contrôles intuitifs pour parcourir les pages
- **Annotations**: Création et édition directement sur la partition
- **Zoom**: Agrandissement pour une meilleure lisibilité

### Mode Scène
- **Performance optimisée**: Interface simplifiée pour les concerts
- **Setlist**: Création de listes de lecture personnalisées
- **Plein écran**: Affichage sans distractions
- **Navigation rapide**: Passage fluide entre les partitions

### Intelligence Artificielle
Architecture agentique avec 4 agents spécialisés:
1. **Agent Harmonique**: Détection de tonalité et accords
2. **Agent Structure**: Identification des sections (intro, verse, chorus, etc.)
3. **Agent Performance**: Analyse du tempo et des nuances
4. **Agent Suggestions**: Recommandations d'amélioration personnalisées

## 🏗️ Architecture

```
lib/
├── models/              # Modèles de données
│   ├── song.dart        # Modèle de partition
│   ├── annotation.dart  # Modèle d'annotation
│   └── ai_analysis.dart # Modèle d'analyse IA
├── services/            # Services métier
│   ├── file_service.dart # Gestion des fichiers
│   └── ai_service.dart   # Architecture agentique IA
├── controllers/         # Contrôleurs
│   └── song_controller.dart # Contrôleur de partitions
├── ui/
│   ├── screens/        # Écrans de l'application
│   │   ├── home_screen.dart
│   │   ├── library_screen.dart
│   │   ├── reader_screen.dart
│   │   ├── scene_mode_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/        # Widgets réutilisables
│       ├── song_card.dart
│       └── annotation_widget.dart
└── main.dart           # Point d'entrée
```

## 🚀 Installation

### Prérequis
- Flutter SDK >=2.12.0 <3.0.0
- Dart SDK compatible

### Dépendances
```yaml
dependencies:
  flutter:
    sdk: flutter
  pdf: ^4.0.0              # Lecture PDF
  musicxml: ^1.0.0         # Lecture MusicXML
  midi_player: ^2.0.0      # Lecture MIDI
  flutter_tts: ^3.0.0      # Synthèse vocale
  openai_api: ^1.0.0       # Intégration OpenAI
```

### Commandes
```bash
# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

# Construire pour production
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

## 📖 Utilisation

### 1. Importer une partition
- Cliquez sur le bouton "Importer" sur l'écran d'accueil
- Sélectionnez un fichier PDF ou MusicXML
- La partition est automatiquement ajoutée à votre bibliothèque

### 2. Organiser votre bibliothèque
- Accédez à la bibliothèque via le menu
- Utilisez la recherche pour trouver rapidement une partition
- Filtrez par tonalité, difficulté ou tags
- Triez par titre, artiste ou date d'ajout

### 3. Lire et annoter
- Ouvrez une partition depuis la bibliothèque
- Naviguez entre les pages avec les contrôles
- Activez le mode annotation pour ajouter des notes
- Vos annotations sont sauvegardées automatiquement

### 4. Mode performance
- Créez une setlist pour votre concert
- Activez le mode scène
- Utilisez le plein écran pour une meilleure visibilité
- Passez d'une partition à l'autre d'un simple geste

### 5. Analyse IA
- Configurez votre clé API OpenAI dans les paramètres
- Les nouvelles partitions sont analysées automatiquement
- Consultez les suggestions d'amélioration
- Explorez les accords et la structure détectés

## 🔧 Configuration

### Clé API OpenAI
1. Accédez aux Paramètres
2. Section "Intelligence Artificielle"
3. Entrez votre clé API OpenAI
4. L'analyse automatique sera activée

### Stockage
- Par défaut: `storage/songs/`
- Personnalisable dans les paramètres
- Gestion du cache disponible

## 🎯 Développements Futurs

### Phase 2: Lecteurs Avancés
- [ ] Intégration complète du lecteur PDF avec zoom/pan
- [ ] Lecteur MusicXML avec rendu natif
- [ ] Support du format MIDI
- [ ] Transposition en temps réel

### Phase 3: Outils Musicaux
- [ ] Accordeur intégré
- [ ] Métronome avec patterns personnalisés
- [ ] Enregistreur audio pour les répétitions
- [ ] Générateur de grilles d'accords

### Phase 4: IA Avancée
- [ ] Reconnaissance optique de partitions (OMR)
- [ ] Génération de variations harmoniques
- [ ] Suggestions de doigtés pour instruments
- [ ] Analyse de style et recommandations

### Phase 5: Collaboration
- [ ] Partage de partitions entre utilisateurs
- [ ] Annotations collaboratives
- [ ] Bibliothèque cloud synchronisée
- [ ] Groupes et ensembles

## 📝 Conventions de Code

### Style
- Utilisation de Dart Effective
- Commentaires en français
- Documentation des fonctions publiques
- Nommage explicite des variables

### Architecture
- Séparation modèle/vue/contrôleur
- Services pour la logique métier
- Widgets réutilisables et composables
- Gestion d'état avec ChangeNotifier

## 🤝 Contribution

Les contributions sont les bienvenues! Pour contribuer:
1. Forkez le projet
2. Créez une branche (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Auteurs

Développé avec ❤️ pour les musiciens

## 🙏 Remerciements

- Flutter et l'équipe Dart
- Communauté open source pour les packages utilisés
- Tous les contributeurs du projet
