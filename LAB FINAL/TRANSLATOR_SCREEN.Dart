import 'package:flutter/material.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  String sourceText = '';
  String translatedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Enter text'),
              onChanged: (value) => sourceText = value,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  translatedText = sourceText;
                });
              },
              child: const Text('Translate'),
            ),
            const SizedBox(height: 12),
            Text
