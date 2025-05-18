import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/auth_service.dart';
import '../models/persona_model.dart';
import '../models/emotional_state_model.dart';
import '../models/goal_model.dart';
import '../models/personality_model.dart';
import '../models/interaction_preference_model.dart';
import '../models/motivation_factor_model.dart';
import '../models/ai_advisor_analysis_model.dart';

abstract class PersonaRemoteDataSource {
  Future<PersonaModel> getPersona();
  Future<PersonaModel> updatePersona(PersonaModel persona);
  Future<EmotionalStateModel> recordEmotionalState(EmotionalStateModel state);
  Future<GoalModel> addGoal(GoalModel goal);
  Future<GoalModel> updateGoal(GoalModel goal);
  Future<bool> deleteGoal(String goalId);
  Future<PersonalityModel> updatePersonality(PersonalityModel personality);
  Future<InteractionPreferenceModel> updateInteractionPreference(InteractionPreferenceModel preference);
  Future<List<MotivationFactorModel>> updateMotivationFactors(List<MotivationFactorModel> factors);
  Future<List<String>> generateInsights();
  Future<AIAdvisorAnalysisModel> analyzeWithAIAdvisor(String input);
}

class PersonaRemoteDataSourceImpl implements PersonaRemoteDataSource {
  final http.Client client;
  final AuthService authService;

  PersonaRemoteDataSourceImpl({
    required this.client,
    required this.authService,
  });

  @override
  Future<PersonaModel> getPersona() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/persona'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return PersonaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Failed to load persona',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<PersonaModel> updatePersona(PersonaModel persona) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/persona'),
      headers: await _getHeaders(),
      body: json.encode(persona.toJson()),
    );

    if (response.statusCode == 200) {
      return PersonaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Failed to update persona',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<EmotionalStateModel> recordEmotionalState(EmotionalStateModel state) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/persona/emotional-state'),
      headers: await _getHeaders(),
      body: json.encode(state.toJson()),
    );

    if (response.statusCode == 201) {
      return EmotionalStateModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Failed to record emotional state',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<GoalModel> addGoal(GoalModel goal) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/persona/goals'),
      headers: await _getHeaders(),
      body: json.encode(goal.toJson()),
    );

    if (response.statusCode == 201) {
      return GoalModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Failed to add goal',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<GoalModel> updateGoal(GoalModel goal) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/persona/goals/${goal.id}'),
      headers: await _getHeaders(),
      body: json.encode(goal.toJson()),
    );

    if (response.statusCode == 200) {
      return GoalModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Failed to update goal',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<bool> deleteGoal(String goalId) async {
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}/persona/goals/$goalId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw ServerException(
        message: 'Failed to delete goal',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<PersonalityModel> updatePersonality(PersonalityModel personality) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/persona/personality'),
      headers: await _getHeaders(),
      body: json.encode(personality.toJson()),
    );

    if (response.statusCode == 200) {
      return PersonalityModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Failed to update personality',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<InteractionPreferenceModel> updateInteractionPreference(InteractionPreferenceModel preference) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/persona/interaction-preference'),
      headers: await _getHeaders(),
      body: json.encode(preference.toJson()),
    );

    if (response.statusCode == 200) {
      return InteractionPreferenceModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Failed to update interaction preference',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<List<MotivationFactorModel>> updateMotivationFactors(List<MotivationFactorModel> factors) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/persona/motivation-factors'),
      headers: await _getHeaders(),
      body: json.encode(factors.map((e) => e.toJson()).toList()),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => MotivationFactorModel.fromJson(e)).toList();
    } else {
      throw ServerException(
        message: 'Failed to update motivation factors',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<List<String>> generateInsights() async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/persona/insights'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => e as String).toList();
    } else {
      throw ServerException(
        message: 'Failed to generate insights',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<AIAdvisorAnalysisModel> analyzeWithAIAdvisor(String input) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/ai-advisors/analyze'),
      headers: await _getHeaders(),
      body: json.encode({'input': input}),
    );

    if (response.statusCode == 200) {
      return AIAdvisorAnalysisModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Failed to analyze with AI advisor',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
