import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sentiment_cubit.dart';

class SentimentScreen extends StatelessWidget {
  const SentimentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(title: const Text("Analyze"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: TextField(
                  controller: textController,
                  maxLines: 4,
                  decoration:  InputDecoration(
                    hintText: "Enter text to analyze",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.read<SentimentCubit>().analyzeSentiment(textController.text);
                },
                child: BlocBuilder<SentimentCubit, SentimentState>(
                  builder: (context, state) {
                    if (state is SentimentLoading) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    }
                    return const Text("Analyze");
                  },
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<SentimentCubit, SentimentState>(
                builder: (context, state) {
                  if (state is SentimentError) {
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
              BlocBuilder<SentimentCubit, SentimentState>(
                builder: (context, state) {
                  if (state is SentimentLoaded) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getSentimentColor(state.sentiment).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getSentimentColor(state.sentiment),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.sentiment_satisfied,
                                color: _getSentimentColor(state.sentiment),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sentiment: ${state.sentiment.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getSentimentColor(state.sentiment),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Confidence: ${(state.confidence * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
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

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      case 'neutral':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
