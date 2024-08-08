import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:googleapis_auth/auth_io.dart';

class DialogflowService {
  static const _scopes = ['https://www.googleapis.com/auth/cloud-platform'];

  final String _projectId;
  final String _sessionId;

  DialogflowService(this._projectId, this._sessionId);

  Future<http.Client> _getAuthenticatedClient() async {
    try {
      // Load the service account credentials from the asset bundle
      final jsonString = await rootBundle.loadString('assets/agent1-oafx-5b0dbaf519f2.json');
      final serviceAccountCredentials = ServiceAccountCredentials.fromJson(jsonString);

      // Create an authenticated HTTP client
      final client = await clientViaServiceAccount(serviceAccountCredentials, _scopes);
      return client;
    } catch (e) {
      throw Exception('Failed to authenticate with Dialogflow: $e');
    }
  }

  Future<String> sendMessage(String message) async {
    final client = await _getAuthenticatedClient();
    final url = 'https://dialogflow.googleapis.com/v2/projects/$_projectId/agent/sessions/$_sessionId:detectIntent';

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'queryInput': {
            'text': {
              'text': message,
              'languageCode': 'en-US',
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String botResponse = responseData['queryResult']['fulfillmentText'];
        return botResponse;
      } else {
        throw Exception('Failed to communicate with Dialogflow: ${response.statusCode} ${response.body}');
      }
    } finally {
      client.close(); // Close the client after use
    }
  }
}
