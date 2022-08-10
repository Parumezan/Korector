import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const Korector());
}

class Korector extends StatelessWidget {
  const Korector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fieldText = "";
  String correctText = "";

  void _correctText() {
    setState(() {
      if (fieldText.isEmpty) {
        // print("Empty String to correct\n");
        return;
      }
      http.post(
        Uri.parse("https://orthographe.reverso.net/api/v1/Spelling/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "englishDialect": "indifferent",
          "autoReplace": true,
          "getCorrectionDetails": true,
          "interfaceLanguage": "fr",
          "locale": "",
          "language": "fra",
          "text": fieldText,
          "originalText": "",
          "spellingFeedbackOptions": {
            "insertFeedback": true,
            "userLoggedOn": false
          },
          "origin": "interactive"
        }),
      ).then((http.Response response) {
        if (response.body.isEmpty) {
          // print("Error: Request failed\n");
          return;
        }
        correctText = jsonDecode(response.body)["text"];
        setState(() {
          fieldText = correctText;
        });
        Clipboard.setData(ClipboardData(text: correctText));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Korector',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(255, 32, 32, 32)),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.topLeft,
                height: 120,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    width: 1,
                  ),
                ),
                child: Text(
                  correctText,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                height: 120,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    width: 1,
                  ),
                ),
                child: TextField(
                  obscureText: false,
                  maxLines: 5,
                  onChanged: (String value) {
                    fieldText = value;
                  },
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    border: InputBorder.none,
                    hintMaxLines: 5,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    hintText: "Enter text",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: _correctText,
                child: const Text("Correct & Copy"),
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
