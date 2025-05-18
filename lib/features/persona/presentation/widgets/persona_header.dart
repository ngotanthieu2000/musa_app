import 'package:flutter/material.dart';
import '../../domain/entities/persona.dart';

class PersonaHeader extends StatelessWidget {
  final Persona persona;

  const PersonaHeader({
    Key? key,
    required this.persona,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = persona.basicInfo['name'] as String? ?? 'User';
    final avatarUrl = persona.basicInfo['avatar'] as String?;
    final occupation = persona.basicInfo['occupation'] as String? ?? '';
    final location = persona.basicInfo['location'] as String? ?? '';

    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[200],
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
          child: avatarUrl == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (occupation.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    occupation,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              if (location.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
