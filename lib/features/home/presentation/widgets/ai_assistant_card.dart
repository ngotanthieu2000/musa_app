import 'package:flutter/material.dart';

class AiAssistantCard extends StatelessWidget {
  const AiAssistantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 8)
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.smart_toy_outlined, color: Colors.white, size: 40),
          SizedBox(width: 12),
          Expanded(
            child: Text('AI Assistant Help',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
