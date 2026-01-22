import 'package:flutter/material.dart';
import '../../models/annotation.dart';

/// Widget d'affichage et d'édition d'annotations
/// 
/// Permet de:
/// - Afficher une annotation sur la partition
/// - Éditer le contenu
/// - Repositionner l'annotation
/// - Supprimer l'annotation
class AnnotationWidget extends StatefulWidget {
  final Annotation annotation;
  final bool isEditable;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AnnotationWidget({
    Key? key,
    required this.annotation,
    this.isEditable = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  State<AnnotationWidget> createState() => _AnnotationWidgetState();
}

class _AnnotationWidgetState extends State<AnnotationWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isEditable ? widget.onEdit : null,
        child: Container(
          width: widget.annotation.position['width'],
          height: widget.annotation.position['height'],
          child: Stack(
            children: [
              _buildAnnotationContent(),
              if (widget.isEditable && _isHovered) _buildEditControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnotationContent() {
    switch (widget.annotation.type) {
      case 'text':
        return _buildTextAnnotation();
      case 'drawing':
        return _buildDrawingAnnotation();
      case 'marker':
        return _buildMarkerAnnotation();
      default:
        return _buildTextAnnotation();
    }
  }

  Widget _buildTextAnnotation() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.yellow[100]?.withOpacity(0.9),
        border: Border.all(
          color: _isHovered ? Colors.orange : Colors.yellow[700]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          if (_isHovered)
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: SingleChildScrollView(
        child: Text(
          widget.annotation.content,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawingAnnotation() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isHovered ? Colors.blue : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.brush,
          color: Colors.blue[700],
          size: 24,
        ),
      ),
    );
  }

  Widget _buildMarkerAnnotation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[100]?.withOpacity(0.7),
        border: Border.all(
          color: _isHovered ? Colors.red : Colors.red[700]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.location_on,
          color: Colors.red[700],
          size: 32,
        ),
      ),
    );
  }

  Widget _buildEditControls() {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 16),
              iconSize: 16,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
              onPressed: widget.onEdit,
              tooltip: 'Modifier',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 16),
              iconSize: 16,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
              onPressed: widget.onDelete,
              color: Colors.red,
              tooltip: 'Supprimer',
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour créer une nouvelle annotation
class NewAnnotationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NewAnnotationButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.add_comment),
      label: const Text('Ajouter une annotation'),
    );
  }
}

/// Dialogue pour choisir le type d'annotation
class AnnotationTypeDialog extends StatelessWidget {
  const AnnotationTypeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Type d\'annotation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Texte'),
            subtitle: const Text('Ajouter une note textuelle'),
            onTap: () => Navigator.pop(context, 'text'),
          ),
          ListTile(
            leading: const Icon(Icons.brush),
            title: const Text('Dessin'),
            subtitle: const Text('Dessiner sur la partition'),
            onTap: () => Navigator.pop(context, 'drawing'),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Marqueur'),
            subtitle: const Text('Marquer une position importante'),
            onTap: () => Navigator.pop(context, 'marker'),
          ),
        ],
      ),
    );
  }
}
