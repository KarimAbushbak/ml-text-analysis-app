import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'translation_cubit.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    String sourceLanguage = 'en';
    String targetLanguage = 'ar';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Translation"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Language Selection Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'From:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: sourceLanguage,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                            DropdownMenuItem(value: 'fr', child: Text('French')),
                            DropdownMenuItem(value: 'es', child: Text('Spanish')),
                            DropdownMenuItem(value: 'de', child: Text('German')),
                          ],
                          onChanged: (value) {
                            sourceLanguage = value ?? 'en';
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'To:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: targetLanguage,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                            DropdownMenuItem(value: 'fr', child: Text('French')),
                            DropdownMenuItem(value: 'es', child: Text('Spanish')),
                            DropdownMenuItem(value: 'de', child: Text('German')),
                          ],
                          onChanged: (value) {
                            targetLanguage = value ?? 'ar';
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Input Text Field
              SizedBox(
                height: 150,
                width: double.infinity,
                child: TextField(
                  controller: textController,
                  maxLines: 4,
                  decoration:  InputDecoration(
                    hintText: "Enter text to translate",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Translate Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  context.read<TranslationCubit>().translateText(
                    text: textController.text,
                    sourceLang: sourceLanguage,
                    targetLang: targetLanguage,
                  );
                },
                child: BlocBuilder<TranslationCubit, TranslationState>(
                  builder: (context, state) {
                    if (state is TranslationLoading) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    }
                    return const Text(
                      "Translate",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Error Display
              BlocBuilder<TranslationCubit, TranslationState>(
                builder: (context, state) {
                  if (state is TranslationError) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              // Translation Result Display
              BlocBuilder<TranslationCubit, TranslationState>(
                builder: (context, state) {
                  if (state is TranslationLoaded) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.shade200,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.translate,
                                color: Colors.blue.shade600,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Translation Result',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              state.translatedText,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.sourceLanguage.toUpperCase()} → ${state.targetLanguage.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

