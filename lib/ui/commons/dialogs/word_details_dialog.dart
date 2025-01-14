import 'package:flutter/material.dart';

import '../../../constants/custom_colors.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../screens/vocabulary/widgets/phonetic.dart';
import '../banner_ads.dart';
import '../rounded_button.dart';

class WordDetailsDialog extends StatelessWidget {
  final Word word;
  final VoidCallback? onMastered;

  const WordDetailsDialog({
    super.key,
    required this.word,
    required this.onMastered,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SelectableText(
                word.word,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Phonetic(
                    phonetic: word.phonetic,
                    phoneticText: word.phoneticText,
                    backgroundColor: CustomColors.green,
                  ),
                  const SizedBox(width: 8),
                  Phonetic(
                    phonetic: word.phoneticAm,
                    phoneticText: word.phoneticAmText,
                    backgroundColor: CustomColors.red,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...List.generate(word.senses.length, (index) {
                final sense = word.senses[index];
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        '${index + 1}. ${sense.definition}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (sense.examples.isNotEmpty) ...[
                        Text("Examples:"),
                        const SizedBox(height: 8),
                        ...List.generate(
                          sense.examples.length,
                          (index) {
                            final example = sense.examples[index];
                            return SelectableText(
                              '${index + 1}.${example.cf.isNotEmpty ? ' (${example.cf})' : ''} ${example.x}',
                              style: textTheme.bodyMedium,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                );
              }),
              if (word.status != WordStatus.mastered) ...[
                const SizedBox(height: 8),
                RoundedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onMastered?.call();
                  },
                  child: const Text('Mask as mastered'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
