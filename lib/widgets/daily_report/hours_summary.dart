// lib/widgets/daily_report/hours_summary.dart

import 'package:flutter/material.dart';
import '../../utils/time_formatter.dart';

class HoursSummary extends StatelessWidget {
  final int regularMinutes;
  final int overtimeMinutes;
  final Function()? onSubmit;
  final bool isSubmitting;
  final String reportStatus;

  const HoursSummary({
    Key? key,
    required this.regularMinutes,
    required this.overtimeMinutes,
    this.onSubmit,
    this.isSubmitting = false,
    required this.reportStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalMinutes = regularMinutes + overtimeMinutes;
    final bool canSubmit = reportStatus == 'DRAFT' && onSubmit != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hours Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            _buildHourRow('Regular Hours:', regularMinutes, Colors.green),
            const SizedBox(height: 4),
            _buildHourRow('Overtime Hours:', overtimeMinutes, Colors.orange),
            const Divider(height: 24),
            _buildHourRow('Total Hours:', totalMinutes, Colors.blue, isBold: true),
            const SizedBox(height: 16),
            if (canSubmit)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Submitting Report...'),
                        ],
                      )
                    : const Text(
                        'Submit Daily Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            if (!canSubmit && reportStatus == 'SUBMITTED')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: const Text(
                  'Report Submitted',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourRow(String label, int minutes, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          TimeFormatter.formatMinutes(minutes),
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}