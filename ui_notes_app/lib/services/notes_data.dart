import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String baseUrl = "http://192.168.1.64:8000";
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

Future<void> storeTokens(String accessToken, String refreshToken) async {
  await _secureStorage.write(key: 'access_token', value: accessToken);
  await _secureStorage.write(key: 'refresh_token', value: refreshToken);
}

Future<bool> checkAndAuthenticate() async {
  // Get the access and refresh tokens from secure storage
  String? accessToken = await _secureStorage.read(key: 'access_token');
  String? refreshToken = await _secureStorage.read(key: 'refresh_token');

  if (accessToken != null && refreshToken != null) {
    bool isAuthenticated = await authenticateWithAccessToken(accessToken);

    if (!isAuthenticated) {
      String? newAccessToken = await refreshAccessToken(refreshToken);

      if (newAccessToken != null) {
        await storeTokens(newAccessToken, refreshToken);
        return true;
      }
    } else {
      return true;
    }
  }
  return false;
}

Future<bool> authenticateWithAccessToken(String? accessToken) async {
  try {
    String url = '$baseUrl/check-access/';
    String? accessToken = await _secureStorage.read(key: 'access_token');

    Response response = await Dio().post(
      url,
      data: {"access": accessToken},
    );
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return true;
  } catch (e) {
    return false;
  }
}

Future<String?> refreshAccessToken(String refreshToken) async {
  await fetchaccestoken();
  String? accessToken = await _secureStorage.read(key: 'access_token');

  return accessToken;
}

Future<void> createAccount(String email, String password) async {
  try {
    String url = '$baseUrl/signup/';
    Response response = await Dio().post(
      url,
      data: {
        "email": email,
        "password": password,
      },
    );
    await fetchRefreshtoken(email, password);
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } catch (e) {
    throw e;
  }
}

Future<void> login(String email, String password) async {
  try {
    String url = '$baseUrl/login/';
    Response response = await Dio().post(
      url,
      data: {"email": email, "password": password},
    );
    await fetchRefreshtoken(email, password);
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } catch (e) {
    throw e;
  }
}

Future<void> fetchaccestoken() async {
  try {
    String? refreshToken = await _secureStorage.read(key: 'refresh_token');
    String url = '$baseUrl/api/token/refresh/';
    Response response = await Dio().post(
      url,
      data: {"refresh": refreshToken},
    );

    Map<String, dynamic> jsonData = response.data;
    String accesstoken = jsonData['access'];
    await _secureStorage.write(key: 'access_token', value: accesstoken);
    print('Response data: $accesstoken');
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<String?> fetchRefreshtoken(String email, String password) async {
  try {
    String url = '$baseUrl/api/token/';
    Response response =
        await Dio().post(url, data: {"email": email, "password": password});

    Map<String, dynamic> jsonData = response.data;
    String accesstoken = jsonData['access'];
    String refreshtoken = jsonData['refresh'];
    await storeTokens(accesstoken, refreshtoken);
    return refreshtoken;
  } catch (e) {
    print('Error occurred: $e');
    return "";
  }
}

Future<List<dynamic>> fetchAllNotes() async {
  try {
    bool isAuthenticated = await checkAndAuthenticate();
    if (!isAuthenticated) {
      throw Exception("Authentication failed");
    }

    String? accessToken = await _secureStorage.read(key: 'access_token');
    String url = "$baseUrl/all_notes/";
    Response response = await Dio().get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response.data;
  } catch (e) {
    print('Error occurred: $e');
    return [];
  }
}

// Create a new note
Future<void> createNote(String title, String content) async {
  try {
    bool isAuthenticated = await checkAndAuthenticate();
    if (!isAuthenticated) {
      throw Exception("Authentication failed");
    }

    String? accessToken = await _secureStorage.read(key: 'access_token');
    String url = '$baseUrl/create_note/';
    Response response = await Dio().post(
      url,
      data: {"title": title, "content": content},
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
    );
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } catch (e) {
    print('Error occurred: $e');
  }
}

// Update a note
Future<void> updateNote(String title, String content, int id) async {
  try {
    bool isAuthenticated = await checkAndAuthenticate();
    if (!isAuthenticated) {
      throw Exception("Authentication failed");
    }

    String? accessToken = await _secureStorage.read(key: 'access_token');
    String url = '$baseUrl/update_note/$id/'; // work
    Response response = await Dio().put(
      url,
      data: {"title": title, "content": content},
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
    );
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } catch (e) {
    print('Error occurred: $e');
  }
}

// Delete a note
Future<void> deleteNote(int id) async {
  try {
    bool isAuthenticated = await checkAndAuthenticate();
    if (!isAuthenticated) {
      throw Exception("Authentication failed");
    }

    String? accessToken = await _secureStorage.read(key: 'access_token');
    String url = '$baseUrl/delete_note/$id/'; // work
    Response response = await Dio().delete(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
    );
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<void> logout() async {
  try {
    bool isAuthenticated = await checkAndAuthenticate();

    if (!isAuthenticated) {
      throw Exception('User is not authenticated');
    }

    final String? refreshToken =
        await _secureStorage.read(key: 'refresh_token');

    if (refreshToken == null) {
      throw Exception('No refresh token found');
    }

    String url = '$baseUrl/logout/';

    String? accessToken = await _secureStorage.read(key: 'access_token');

    final response = await Dio().post(
      url,
      data: {
        'refresh_token': refreshToken,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 205) {
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');

      print('Logout successful');
    } else {
      throw Exception('Failed to logout: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during logout: $e');
    throw Exception('Failed to logout: $e');
  }
}
