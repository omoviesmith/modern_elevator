// lib/widgets/daily_report/issues_summary.dart

import 'package:flutter/material.dart';
import '../../utils/time_formatter.dart';

class IssuesSummary extends StatelessWidget {
  final List<dynamic> issues;

  const IssuesSummary({
    super.key,
    required this.issues,
  });

  @override
  Widget build(BuildContext context) {
    if (issues.isEmpty) {
      return const Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No issues reported today.'),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).primaryColor.withAlpha(25),
            width: double.infinity,
            child: const Text(
              'Issues Reported',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: issues.length,
            itemBuilder: (context, index) => _buildIssueTile(context, issues[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueTile(BuildContext context, dynamic issue) {
    final title = issue['title'] ?? 'Unknown Issue';
    final type = issue['type'] ?? 'Unknown Type';
    final priorityRaw = issue['priority'] ?? 'MEDIUM';
    final priority = priorityRaw.toString().toUpperCase();
    final projectName = issue['project']?['name'] ?? 'Unknown Project';
    final elevatorName = issue['elevator']?['name'] ?? 'Unknown Elevator';
    final delayMinutes = issue['delayMinutes'] ?? 0;
    final description = issue['description'] ?? '';

    Color priorityColor;
    switch (priority) {
      case 'HIGH':
        priorityColor = Colors.red;
        break;
      case 'MEDIUM':
        priorityColor = Colors.orange;
        break;
      case 'LOW':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return ExpansionTile(
      title: Text(title),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: priorityColor.withAlpha(55),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              priority,
              style: TextStyle(
                color: priorityColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(type),
          if (delayMinutes > 0) ...[
            const SizedBox(width: 8),
            Text(
              'Delay: ${TimeFormatter.formatMinutes(delayMinutes)}',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Project: $projectName'),
                        Text('Elevator: $elevatorName'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (description.isNotEmpty) ...[
                const Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ],
          ),
        ),
      ],
    );
  }
}