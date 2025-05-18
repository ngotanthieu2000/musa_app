import 'package:flutter/material.dart';
import 'dart:math';

class MinimalAIAdvisorPage extends StatefulWidget {
  const MinimalAIAdvisorPage({Key? key}) : super(key: key);

  @override
  State<MinimalAIAdvisorPage> createState() => _MinimalAIAdvisorPageState();
}

class _MinimalAIAdvisorPageState extends State<MinimalAIAdvisorPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    
    // Add initial message
    _messages.add(
      ChatMessage(
        text: 'Hello! I\'m your AI Advisor. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Advisor'),
        backgroundColor: colorScheme.surface,
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation with your AI Advisor',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          
          // Analyzing indicator
          if (_isAnalyzing)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: colorScheme.primary.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Analyzing your request...',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          
          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }
  
  Widget _buildInputArea() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
                  color: colorScheme.primary.withOpacity(0.7),
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
                      ? colorScheme.primary
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(
          suggestion,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.primary,
          ),
        ),
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        onPressed: () {
          setState(() {
            _inputController.text = suggestion;
          });
        },
      ),
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: colorScheme.primary,
              radius: 16,
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? colorScheme.primary
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: colorScheme.primary,
              radius: 16,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  void _handleSubmit() {
    if (_inputController.text.isEmpty) return;
    
    final userMessage = _inputController.text;
    
    // Add user message to chat
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _inputController.clear();
      _isAnalyzing = true;
    });
    
    // Scroll to bottom
    _scrollToBottom();
    
    // Simulate AI response after a delay
    Future.delayed(const Duration(seconds: 2), () {
      _simulateAIResponse(userMessage);
    });
  }
  
  void _simulateAIResponse(String userMessage) {
    // Generate a random number of advisors (1-3)
    final random = Random();
    final advisorCount = random.nextInt(3) + 1;
    
    // List of advisor roles
    final advisorRoles = [
      'Career',
      'Productivity',
      'Health',
      'Financial',
      'Relationship',
    ];
    
    // Shuffle and take the first few
    advisorRoles.shuffle();
    final selectedRoles = advisorRoles.take(advisorCount).toList();
    
    // Add advisor opinions with staggered timing
    for (int i = 0; i < selectedRoles.length; i++) {
      final role = selectedRoles[i];
      
      Future.delayed(Duration(milliseconds: 500 * (i + 1)), () {
        setState(() {
          _messages.add(ChatMessage(
            text: '$role Advisor: ${_generateAdvisorOpinion(role, userMessage)}',
            isUser: false,
            timestamp: DateTime.now(),
          ));
          
          // Scroll to bottom after each message
          _scrollToBottom();
        });
      });
    }
    
    // Add conclusion after all advisor opinions
    Future.delayed(Duration(milliseconds: 500 * (selectedRoles.length + 1)), () {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Conclusion: ${_generateConclusion(userMessage)}',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        
        _isAnalyzing = false;
        
        // Scroll to bottom after conclusion
        _scrollToBottom();
      });
    });
  }
  
  String _generateAdvisorOpinion(String role, String userMessage) {
    // Simple mock responses based on role
    switch (role) {
      case 'Career':
        return 'Based on your personality profile, you might excel in roles that require analytical thinking and independent work. Consider exploring opportunities in research, software development, or strategic planning.';
      case 'Productivity':
        return 'Your data shows you\'re most productive in the morning. Try scheduling your most important tasks before noon, and use the Pomodoro technique to maintain focus.';
      case 'Health':
        return 'Regular physical activity has been shown to reduce your stress levels. Consider incorporating a 30-minute walk into your daily routine.';
      case 'Financial':
        return 'Given your long-term goals, you might want to consider allocating more of your budget to savings and investments. A 70/20/10 rule could work well for your situation.';
      case 'Relationship':
        return 'Your communication style tends to be direct and logical. When dealing with more emotional personalities, try to acknowledge feelings before offering solutions.';
      default:
        return 'I\'ve analyzed your question and believe you should approach this methodically, breaking it down into smaller, manageable steps.';
    }
  }
  
  String _generateConclusion(String userMessage) {
    // Simple mock conclusion
    return 'Taking all factors into account, I recommend focusing on a balanced approach that aligns with your personal values and long-term goals. Start with small, consistent changes and track your progress regularly.';
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
