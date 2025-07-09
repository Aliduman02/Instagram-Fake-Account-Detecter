import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  Map<String, dynamic>? profileData;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchProfileData(String username) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      profileData = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/get_profile?username=$username'),
      );

      if (response.statusCode == 200) {
        setState(() {
          profileData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Kullanıcı bulunamadı veya API hatası';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Bağlantı hatası: $e';
        isLoading = false;
      });
    }
  }

  Widget buildProfileInfo() {
    if (profileData == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profileData!['profile_pic_url'] != null)
          Image.network(profileData!['profile_pic_url']),
        SizedBox(height: 10),
        Text("Gönderi sayısı: ${profileData!['#posts']}"),
        Text("Takipçi sayısı: ${profileData!['#followers']}"),
        Text("Takip edilen sayısı: ${profileData!['#follows']}"),
        Text("Hesap gizli mi?: ${profileData!['private'] == 1 ? 'Evet' : 'Hayır'}"),
        Text("Rakam oranı (nums/length username): ${profileData!['nums_length_username']}"),
        Text("Biyografi uzunluğu: ${profileData!['description_length']}"),
        Text("Profil fotoğrafı var mı?: ${profileData!['hasProfilePic'] == 1 ? 'Evet' : 'Hayır'}"),
        Text("Sahte hesap olasılığı: ${profileData!['fake_probability_percent']}%"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram Profil Bilgileri'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Kullanıcı adı',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final username = _usernameController.text.trim();
                if (username.isNotEmpty) {
                  fetchProfileData(username);
                }
              },
              child: Text('Bilgileri Getir'),
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            buildProfileInfo(),
          ],
        ),
      ),
    );
  }
}
