import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Input extends StatefulWidget {
  const Input({super.key});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  List<String> definitions = [];
  String word = "";

  Future<void> fetch(String word) async {
    FocusScope.of(context).unfocus(); // Hide the keyboard

    final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final meanings = jsonResponse[0]['meanings'];
      final fetcheddefinitions = <String>[];

      for (final meaning in meanings) {
        for (final definition in meaning['definitions']) {
          fetcheddefinitions.add(definition['definition']);
        }
      }
      setState(() {
        definitions = fetcheddefinitions;
      });
      // return definitions;
    }
    else if (response.statusCode == 404) {
        // No definitions found for the word
        setState(() {
          definitions = ["No definition found.please try with another word"];
           // Clear any previous definitions
        });
      }
    else {
      throw Exception('Failed to load definitions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Dictionary App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
          margin: const EdgeInsets.only(left: 40, top: 60, right: 40),
          child: Column(
            children: [
              TextFormField(
                initialValue: word,
                onChanged: (value) {
                  word = value.toString();
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          fetch(word);
                        },
                        icon: const Icon(Icons.search)),
                    label: const Text("search"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40))),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Stack(children: [
                ListView.builder(
                  itemCount: definitions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(definitions[index]),
                    );
                  },
                ),
                Center(
                  child: Visibility(
                      visible: word.isEmpty,
                      child: const Text("Enter a word to get its meaning!!")),
                ),
              ]))
            ],
          )),
    );
  }
}
