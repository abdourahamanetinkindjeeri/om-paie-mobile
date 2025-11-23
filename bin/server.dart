import 'dart:io';
import 'dart:convert';

late Map<String, dynamic> dbData;

Future<void> main() async {
  // Load db.json
  final dbFile = File('lib/data/db.json');
  final dbContent = await dbFile.readAsString();
  dbData = jsonDecode(dbContent);

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8000);
  print('Server running on http://localhost:8000');

  await for (HttpRequest request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  final response = request.response;

  // Set CORS headers
  response.headers.add('Access-Control-Allow-Origin', '*');
  response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  response.headers.add('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (request.method == 'OPTIONS') {
    response.statusCode = 200;
    response.close();
    return;
  }

  final path = request.uri.path;
  final method = request.method;

  print('$method $path');

  try {
    if (path.startsWith('/api/auth/login') && method == 'POST') {
      handleLogin(request, response);
    } else if (path.startsWith('/api/auth/login/confirm') && method == 'POST') {
      handleLoginConfirm(request, response);
    } else if (path.startsWith('/api/auth/register') && method == 'POST') {
      handleRegister(request, response);
    } else if (path.startsWith('/api/auth/me') && method == 'GET') {
      handleMe(request, response);
    } else if (path.startsWith('/api/users/') && method == 'GET') {
      handleGetUser(request, response);
    } else if (path == '/api/users' && method == 'GET') {
      handleGetUsers(request, response);
    } else {
      response.statusCode = 404;
      response.write(jsonEncode({'error': 'Not found'}));
      response.close();
    }
  } catch (e) {
    response.statusCode = 500;
    response.write(jsonEncode({'error': e.toString()}));
    response.close();
  }
}

void handleLogin(HttpRequest request, HttpResponse response) async {
  final body = await utf8.decodeStream(request);
  final data = jsonDecode(body);

  final telephone = data['telephone'];
  final code = data['code'];

  // Find user by telephone
  final users = dbData['users'] as List;
  final user = users.firstWhere(
    (u) => u['telephone'] == telephone,
    orElse: () => null,
  );

  if (user == null) {
    response.statusCode = 401;
    response.write(jsonEncode({'message': 'Utilisateur non trouvé'}));
    response.close();
    return;
  }

  // For demo, accept code "1234" for test user
  if (code != '1234') {
    response.statusCode = 401;
    response.write(jsonEncode({'message': 'Code incorrect'}));
    response.close();
    return;
  }

  // Generate OTP
  final otp = '944903'; // Fixed for demo

  response.statusCode = 200;
  response.write(jsonEncode({
    'message': 'Code OTP envoyé pour la connexion',
    'code_otp': otp,
  }));
  response.close();
}

void handleLoginConfirm(HttpRequest request, HttpResponse response) async {
  final body = await utf8.decodeStream(request);
  final data = jsonDecode(body);

  final telephone = data['telephone'];
  final otpCode = data['otp_code'];

  if (otpCode != '944903') {
    response.statusCode = 401;
    response.write(jsonEncode({'message': 'OTP incorrect'}));
    response.close();
    return;
  }

  // Find user
  final users = dbData['users'] as List;
  final user = users.firstWhere(
    (u) => u['telephone'] == telephone,
    orElse: () => null,
  );

  if (user == null) {
    response.statusCode = 401;
    response.write(jsonEncode({'message': 'Utilisateur non trouvé'}));
    response.close();
    return;
  }

  // Generate tokens (mock)
  final accessToken = 'mock_access_token_${user['id']}';
  final refreshToken = 'mock_refresh_token_${user['id']}';

  response.statusCode = 200;
  response.write(jsonEncode({
    'message': 'Connexion réussie',
    'access_token': accessToken,
    'refresh_token': refreshToken,
  }));
  response.close();
}

void handleRegister(HttpRequest request, HttpResponse response) async {
  // Mock register
  response.statusCode = 200;
  response.write(jsonEncode({
    'message': 'Inscription réussie',
    'code_otp': '123456',
  }));
  response.close();
}

void handleMe(HttpRequest request, HttpResponse response) {
  // Mock me
  response.statusCode = 200;
  response.write(jsonEncode({
    'id': 'user_id',
    'nom': 'Test',
    'prenom': 'User',
    'telephone': '+221781465554',
  }));
  response.close();
}

void handleGetUser(HttpRequest request, HttpResponse response) {
  final userId = request.uri.pathSegments.last;
  final users = dbData['users'] as List;
  final user = users.firstWhere(
    (u) => u['id'] == userId,
    orElse: () => null,
  );

  if (user == null) {
    response.statusCode = 404;
    response.write(jsonEncode({'error': 'User not found'}));
    response.close();
    return;
  }

  response.statusCode = 200;
  response.write(jsonEncode(user));
  response.close();
}

void handleGetUsers(HttpRequest request, HttpResponse response) {
  final users = dbData['users'] as List;
  response.statusCode = 200;
  response.write(jsonEncode(users));
  response.close();
}
