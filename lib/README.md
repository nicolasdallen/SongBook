# Structure du répertoire /lib

Ce document décrit l'organisation du code source de l'application SongBook.

## 📁 Organisation

### /models
**Modèles de données** - Représentation des entités métier

- **song.dart**: Modèle de partition musicale
  - Propriétés: id, title, artist, tags, key, tempo, difficulty, fileType, filePath
  - Méthodes: toJson(), fromJson(), copyWith()
  
- **annotation.dart**: Modèle d'annotation sur partition
  - Types: text, drawing, marker
  - Position: x, y, width, height
  - Contenu et métadonnées temporelles
  
- **ai_analysis.dart**: Résultats d'analyse IA
  - Tonalité détectée et liste d'accords
  - Structure de la chanson (sections)
  - Suggestions d'amélioration
  - Score de confiance

### /services
**Services métier** - Logique applicative et intégrations externes

- **file_service.dart**: Gestion des fichiers
  - Importation de partitions (PDF, MusicXML)
  - Détection automatique du format
  - Stockage local et gestion des métadonnées
  - Opérations CRUD sur les fichiers
  
- **ai_service.dart**: Architecture agentique IA
  - 4 agents spécialisés travaillant en parallèle
  - Agent harmonique: tonalité et accords
  - Agent structure: sections et répétitions
  - Agent performance: tempo et dynamique
  - Agent suggestions: recommandations personnalisées

### /controllers
**Contrôleurs** - Gestion d'état et coordination

- **song_controller.dart**: Contrôleur principal des partitions
  - Gestion de la collection complète
  - Recherche et filtrage multicritères
  - Tri par différents attributs
  - Gestion des annotations
  - Notifications de changement d'état (ChangeNotifier)

### /ui/screens
**Écrans** - Interfaces utilisateur principales

- **home_screen.dart**: Écran d'accueil
  - Vue d'ensemble avec partitions récentes
  - Actions rapides (importer, rechercher)
  - Statistiques de la bibliothèque
  
- **library_screen.dart**: Bibliothèque complète
  - Liste exhaustive des partitions
  - Recherche par titre, artiste, tags
  - Filtres: tonalité, difficulté, tags
  - Tri: titre, artiste, date, difficulté
  - Actions: édition, suppression
  
- **reader_screen.dart**: Lecteur de partition
  - Affichage PDF/MusicXML
  - Navigation entre les pages
  - Gestion des annotations
  - Mode annotation avec édition
  - Informations de la partition
  
- **scene_mode_screen.dart**: Mode performance
  - Création de setlist personnalisée
  - Affichage plein écran
  - Navigation simplifiée
  - Écran toujours actif
  - Contrôles gestuels
  
- **settings_screen.dart**: Paramètres
  - Configuration de l'affichage
  - Clé API OpenAI
  - Gestion du stockage
  - Import/export de bibliothèque
  - À propos et documentation

### /ui/widgets
**Widgets réutilisables** - Composants UI modulaires

- **song_card.dart**: Carte d'affichage de partition
  - Miniature selon le type de fichier
  - Métadonnées visuelles (tonalité, tempo, difficulté)
  - Tags avec style personnalisé
  - Actions au tap et long press
  
- **annotation_widget.dart**: Widget d'annotation
  - Affichage selon le type (text, drawing, marker)
  - Mode édition avec contrôles
  - Repositionnement drag & drop
  - Actions: éditer, supprimer
  - Dialogue de sélection de type

## 🔄 Flux de données

### Navigation
```
HomeScreen
  ├─> LibraryScreen ──> ReaderScreen
  ├─> SceneModeScreen
  └─> SettingsScreen
```

### Gestion d'état
```
SongController (ChangeNotifier)
  ├─> FileService (importation, stockage)
  └─> Widgets (via ListenableBuilder)
```

### Analyse IA
```
AIService
  ├─> Agent Harmonique ─┐
  ├─> Agent Structure   ├─> Agrégation ──> AIAnalysis
  ├─> Agent Performance │
  └─> Agent Suggestions ─┘
```

## 🎨 Patterns utilisés

### Architecture
- **MVC**: Séparation modèle/vue/contrôleur
- **Repository**: FileService encapsule l'accès aux données
- **Observer**: ChangeNotifier pour la gestion d'état réactive

### Conception
- **Factory**: Constructeurs fromJson() pour la désérialisation
- **Builder**: Construction progressive des analyses IA
- **Strategy**: Différents types d'annotations

## 📚 Bonnes pratiques

### Code
1. **Immutabilité**: Utilisation de `final` partout où possible
2. **Null safety**: Gestion stricte des valeurs nullables
3. **Documentation**: Commentaires en français sur les classes et méthodes publiques
4. **Nommage**: Convention camelCase pour les variables, PascalCase pour les classes

### Widgets
1. **Composition**: Préférer la composition à l'héritage
2. **Stateless**: Utiliser StatelessWidget quand possible
3. **Keys**: Utiliser des keys pour l'optimisation des listes
4. **Const**: Constructeurs const pour les widgets immuables

### Performance
1. **Lazy loading**: Chargement à la demande des partitions
2. **Parallel**: Exécution parallèle des agents IA
3. **Caching**: Mise en cache des analyses
4. **Pagination**: Gestion par pages pour les grandes listes

## 🔮 Extensions futures

### Nouveaux modèles
- **Playlist**: Gestion de setlists sauvegardées
- **Settings**: Modèle pour les préférences utilisateur
- **User**: Support multi-utilisateurs

### Nouveaux services
- **SyncService**: Synchronisation cloud
- **AudioService**: Lecture audio et enregistrement
- **ExportService**: Export PDF avec annotations

### Nouveaux widgets
- **PdfViewer**: Lecteur PDF intégré
- **MusicXmlRenderer**: Rendu MusicXML natif
- **ChordDiagram**: Affichage de diagrammes d'accords

## 🛠️ Développement

### Ajout d'un nouveau modèle
1. Créer le fichier dans `/models`
2. Définir les propriétés avec `final`
3. Implémenter `toJson()` et `fromJson()`
4. Ajouter `copyWith()` si nécessaire
5. Override `==` et `hashCode` pour les comparaisons

### Ajout d'un nouveau service
1. Créer le fichier dans `/services`
2. Documenter la responsabilité du service
3. Injecter les dépendances via le constructeur
4. Utiliser `async/await` pour les opérations longues
5. Gérer les erreurs avec try/catch

### Ajout d'un nouvel écran
1. Créer le fichier dans `/ui/screens`
2. Étendre `StatefulWidget` si état local nécessaire
3. Documenter les fonctionnalités de l'écran
4. Utiliser les widgets réutilisables existants
5. Ajouter la route dans `main.dart`

### Ajout d'un nouveau widget
1. Créer le fichier dans `/ui/widgets`
2. Rendre le widget le plus générique possible
3. Exposer les callbacks pour les actions
4. Documenter les paramètres requis et optionnels
5. Tester la réutilisabilité dans différents contextes
