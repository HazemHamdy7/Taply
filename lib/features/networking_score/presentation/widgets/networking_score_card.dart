import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/networking_score/presentation/cubit/networking_score_cubit.dart';

class NetworkingScoreCard extends StatelessWidget {
  const NetworkingScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NetworkingScoreCubit, NetworkingScoreState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final score = state.score;
        final levelColor = _levelColor(score.score);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Networking Score',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: score.progressFraction,
                            strokeWidth: 10,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(levelColor),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${score.score}',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: levelColor,
                              ),
                            ),
                            Text(
                              '/ 100',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: levelColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      score.level,
                      style: TextStyle(
                        color: levelColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _levelColor(int score) {
    if (score <= 30) return Colors.red;
    if (score <= 60) return Colors.orange;
    if (score <= 80) return Colors.blue;
    return Colors.green;
  }
}
