import 'dart:convert';
import 'package:flutter/material.dart';

class AvatarUsuario extends StatelessWidget {
  final String? fotoUrl;
  final String nombre;
  final double radio;
  final IconData iconoDefecto;

  const AvatarUsuario({
    super.key,
    this.fotoUrl,
    required this.nombre,
    this.radio = 24,
    this.iconoDefecto = Icons.person,
  });

  String get _inicial {
    final limpio = nombre.trim();
    if (limpio.isEmpty) return '';
    return limpio.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final url = fotoUrl?.trim() ?? '';

    if (url.isNotEmpty) {
      if (url.startsWith('data:image')) {
        try {
          final base64Data = url.split(',').last;
          final bytes = base64Decode(base64Data);
          return CircleAvatar(
            radius: radio,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: MemoryImage(bytes),
          );
        } catch (_) {}
      } else if (url.startsWith('http://') || url.startsWith('https://')) {
        return CircleAvatar(
          radius: radio,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: NetworkImage(url),
          onBackgroundImageError: (exception, stackTrace) {},
          child: null,
        );
      }
    }

    if (_inicial.isNotEmpty) {
      return CircleAvatar(
        radius: radio,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          _inicial,
          style: TextStyle(
            fontSize: radio * 0.9,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radio,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Icon(
        iconoDefecto,
        size: radio * 1.1,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
