import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/persona.dart';
import '../../domain/entities/ai_advisor_analysis.dart';
import '../bloc/persona_bloc.dart';

class AIAdvisorChat extends StatefulWidget {
  final Persona persona;
  final Function(String) onAnalyze;

  const AIAdvisorChat({
    Key? key,
    required this.persona,
    required this.onAnalyze,
  }) : super(key: key);

  @override
  State<AIAdvisorChat> createState() => _AIAdvisorChatState();
}

class _AIAdvisorChatState extends State<AIAdvisorChat> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final name = widget.persona.basicInfo['name'] as String? ?? 'there';
    final personality = widget.persona.personality.value;
    final mood = widget.persona.currentEmotionalState.mood;

    String welcomeMessage = 'Hello $name! ';
    welcomeMessage += 'I notice you have an $personality personality type and are feeling $mood today. ';
    welcomeMessage += 'How can I assist you?';

    setState(() {
      _messages.add(ChatMessage(
        text: welcomeMessage,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _handleSubmit() {
    if (_inputController.text.trim().isEmpty) return;

    final userMessage = _inputController.text.trim();
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isAnalyzing = true;
      _inputController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Send to AI Advisor
    widget.onAnalyze(userMessage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonaBloc, PersonaState>(
      listener: (context, state) {
        if (state is AIAdvisorAnalysisLoaded) {
          _handleAIResponse(state.analysis);
        } else if (state is PersonaError) {
          _handleError(state.message);
        }
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          if (_isAnalyzing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Analyzing...'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    // Determine if this is an advisor message
    bool isAdvisorMessage = false;
    String advisorRole = '';
    if (!isUser && message.text.contains(':')) {
      final parts = message.text.split(':');
      if (parts.length > 1 && parts[0].contains('Advisor')) {
        isAdvisorMessage = true;
        advisorRole = parts[0].trim();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            isAdvisorMessage
              ? _buildAdvisorAvatar(advisorRole)
              : _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primary
                    : isAdvisorMessage
                        ? _getAdvisorColor(advisorRole).withOpacity(0.1)
                        : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isAdvisorMessage) ...[
                    Text(
                      advisorRole,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getAdvisorColor(advisorRole),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.text.substring(message.text.indexOf(':') + 1).trim(),
                      style: TextStyle(
                        color: isUser ? Colors.white : null,
                      ),
                    ),
                  ] else ...[
                    Text(
                      message.text,
                      style: TextStyle(
                        color: isUser ? Colors.white : null,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isUser ? Colors.white70 : Colors.grey,
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          size: 12,
                          color: Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Color _getAdvisorColor(String advisorRole) {
    if (advisorRole.contains('Career')) {
      return Colors.blue;
    } else if (advisorRole.contains('Psychology')) {
      return Colors.purple;
    } else if (advisorRole.contains('Finance')) {
      return Colors.green;
    } else if (advisorRole.contains('Health')) {
      return Colors.red;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  Widget _buildAdvisorAvatar(String advisorRole) {
    IconData iconData = Icons.assistant;
    Color color = Theme.of(context).colorScheme.primary;

    if (advisorRole.contains('Career')) {
      iconData = Icons.work;
      color = Colors.blue;
    } else if (advisorRole.contains('Psychology')) {
      iconData = Icons.psychology;
      color = Colors.purple;
    } else if (advisorRole.contains('Finance')) {
      iconData = Icons.attach_money;
      color = Colors.green;
    } else if (advisorRole.contains('Health')) {
      iconData = Icons.favorite;
      color = Colors.red;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(
        iconData,
        color: color,
        size: 16,
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
      child: Icon(
        Icons.assistant,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildUserAvatar() {
    final avatarUrl = widget.persona.basicInfo['avatar'] as String?;
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
      child: avatarUrl == null ? const Icon(Icons.person) : null,
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Suggestion chips
          if (!_isAnalyzing) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSuggestionChip('How can I improve my productivity?'),
                  _buildSuggestionChip('What career path suits my personality?'),
                  _buildSuggestionChip('Help me manage stress'),
                  _buildSuggestionChip('Financial advice for my goals'),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Input field and send button
          Row(
            children: [
              // Microphone button (placeholder for voice input)
              IconButton(
                icon: Icon(
                  Icons.mic,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ),
                onPressed: () {
                  // Voice input functionality would go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Voice input coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              // Text input field
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: _inputController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _inputController.clear();
                              });
                            },
                          )
                        : null,
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSubmit(),
                  onChanged: (text) {
                    // Force rebuild to show/hide clear button
                    setState(() {});
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),

              // Send button
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _inputController.text.isNotEmpty
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: _inputController.text.isNotEmpty
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                  onPressed: _inputController.text.isNotEmpty ? _handleSubmit : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(
          suggestion,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        onPressed: () {
          setState(() {
            _inputController.text = suggestion;
          });
        },
      ),
    );
  }

  void _handleAIResponse(AIAdvisorAnalysis analysis) {
    // Add a small delay to simulate thinking time and make the response feel more natural
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnalyzing = false;

        // Add summary if available
        if (analysis.summary.isNotEmpty) {
          _messages.add(ChatMessage(
            text: analysis.summary,
            isUser: false,
            timestamp: DateTime.now(),
          ));

          // Add a small delay between messages
          Future.delayed(const Duration(milliseconds: 300));
        }

        // Add advisor opinions with staggered timing
        for (int i = 0; i < analysis.advisors.length; i++) {
          final advisor = analysis.advisors[i];

          // Add with delay to create a staggered effect
          Future.delayed(Duration(milliseconds: 500 * (i + 1)), () {
            setState(() {
              _messages.add(ChatMessage(
                text: '${advisor.role} Advisor: ${advisor.opinion}',
                isUser: false,
                timestamp: DateTime.now(),
              ));

              // Scroll to bottom after each message
              _scrollToBottom();
            });
          });
        }

        // Add conclusion after all advisor opinions
        Future.delayed(Duration(milliseconds: 500 * (analysis.advisors.length + 1)), () {
          setState(() {
            _messages.add(ChatMessage(
              text: 'Conclusion: ${analysis.conclusion}',
              isUser: false,
              timestamp: DateTime.now(),
            ));

            // Add provider info if available
            if (analysis.provider.isNotEmpty) {
              _messages.add(ChatMessage(
                text: 'Powered by ${analysis.provider}',
                isUser: false,
                timestamp: DateTime.now(),
              ));
            }

            // Scroll to bottom after conclusion
            _scrollToBottom();
          });
        });
      });

      // Initial scroll to bottom
      _scrollToBottom();
    });
  }

  void _handleError(String message) {
    setState(() {
      _isAnalyzing = false;

      // Add a more user-friendly error message
      _messages.add(ChatMessage(
        text: 'I apologize, but I encountered an issue while processing your request.',
        isUser: false,
        timestamp: DateTime.now(),
      ));

      // Add technical details if available
      if (message.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _messages.add(ChatMessage(
              text: 'Technical details: $message',
              isUser: false,
              timestamp: DateTime.now(),
            ));

            // Add retry suggestion
            _messages.add(ChatMessage(
              text: 'Please try again or rephrase your question.',
              isUser: false,
              timestamp: DateTime.now(),
            ));

            // Scroll to bottom
            _scrollToBottom();
          });
        });
      }
    });

    // Scroll to bottom
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
