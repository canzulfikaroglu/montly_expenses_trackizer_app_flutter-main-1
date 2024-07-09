import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/firebase_options.dart';

const baseUrl =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAVRrvSmipcQ4Rh7dx-yjeRg3s5r0kSfTQ";
final header = {
  "Content-Type": "application/json",
};

Future<String?> getGeminiData(String input) async {
  var message = {
    "contents": [
      {
        "parts": [
          {"text": "$input ."}
        ]
      }
    ]
  };
  try {
    final response = await http.post(Uri.parse(baseUrl),
        headers: header, body: jsonEncode(message));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var responseText =
          result["candidates"][0]["content"]["parts"][0]["text"].toString();
      return responseText;
    } else {
      return ("Request failed with status: ${response.statusCode}");
    }
  } catch (e) {
    return ("Error: $e");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "dev project", options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyWallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: ColorScheme.fromSeed(
          seedColor: TColor.primary,
          background: TColor.gray80,
          primary: TColor.primary,
          primaryContainer: TColor.gray60,
          secondary: TColor.secondary,
        ),
        useMaterial3: false,
      ),
      home: const GeminiDataPage(),
    );
  }
}

class GeminiDataPage extends StatefulWidget {
  const GeminiDataPage({super.key});

  @override
  _GeminiDataPageState createState() => _GeminiDataPageState();
}

class _GeminiDataPageState extends State<GeminiDataPage> {
  late Future<String?> futureGeminiData;
  final TextEditingController _controller = TextEditingController();
  String userInput = "";

  @override
  void initState() {
    super.initState();
    futureGeminiData = getGeminiData("Your input text here");
  }

  void _getResponse() {
    setState(() {
      futureGeminiData = getGeminiData(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(51, 205, 224, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Sanal Asistanına Soru sor !",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                userInput = value;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getResponse,
              child: const Text("Cevabı Getir"),
            ),
            const SizedBox(height: 16),
            FutureBuilder<String?>(
              future: futureGeminiData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Text('Cevap: ${snapshot.data}');
                } else {
                  return const Text('No data received');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
