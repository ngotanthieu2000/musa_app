import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/persona_page.dart';
import '../presentation/pages/emotional_state_page.dart';
import '../presentation/pages/add_goal_page.dart';
import '../presentation/pages/edit_goal_page.dart';
import '../presentation/pages/personality_page.dart';
import '../presentation/pages/ai_advisor_page.dart';

List<RouteBase> getPersonaRoutes() {
  return [
    GoRoute(
      path: '/persona',
      name: 'persona',
      builder: (context, state) => const PersonaPage(),
    ),
    GoRoute(
      path: '/persona/emotional-state',
      name: 'emotionalState',
      builder: (context, state) => const EmotionalStatePage(),
    ),
    GoRoute(
      path: '/persona/add-goal',
      name: 'addGoal',
      builder: (context, state) => const AddGoalPage(),
    ),
    GoRoute(
      path: '/persona/edit-goal/:id',
      name: 'editGoal',
      builder: (context, state) {
        final goalId = state.pathParameters['id']!;
        return EditGoalPage(goalId: goalId);
      },
    ),
    GoRoute(
      path: '/persona/personality',
      name: 'personality',
      builder: (context, state) => const PersonalityPage(),
    ),
    GoRoute(
      path: '/persona/ai-advisor',
      name: 'aiAdvisor',
      builder: (context, state) => const AIAdvisorPage(),
    ),
  ];
}
