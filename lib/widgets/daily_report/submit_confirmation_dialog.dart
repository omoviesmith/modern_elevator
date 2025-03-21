// // lib/widgets/daily_report/submit_confirmation_dialog.dart

// import 'package:flutter/material.dart';

// class SubmitConfirmationDialog extends StatelessWidget {
//   final Function() onConfirm;
//   final int regularHours;
//   final int overtimeHours;

//   const SubmitConfirmationDialog({
//     Key? key,
//     required this.onConfirm,
//     required this.regularHours,
//     required this.overtimeHours,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Format hours for display
//     final regularHoursText = '${regularHours ~/ 60}h ${regularHours % 60}m';
//     final overtimeHoursText = '${overtimeHours ~/ 60}h ${overtimeHours % 60}m';
//     final hasOvertime = overtimeHours > 0;

//     return AlertDialog(
//       title: const Text('Submit Daily Report'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Are you sure you want to submit your daily report?'),
//           const SizedBox(height: 16),
//           const Text(
//             'Hours Summary:',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           _buildHourRow('Regular Hours:', regularHoursText),
//           _buildHourRow('Overtime Hours:', overtimeHoursText),
//           const SizedBox(height: 12),
//           if (hasOvertime)
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.orange.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.orange),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'Please confirm that you worked $overtimeHoursText of overtime.',
//                       style: TextStyle(color: Colors.orange),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           const SizedBox(height: 8),
//           const Text(
//             'Once submitted, you cannot make further changes to this report.',
//             style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             onConfirm();
//             Navigator.of(context).pop();
//           },
//           child: const Text('Confirm & Submit'),
//         ),
//       ],
//     );
//   }

//   Widget _buildHourRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label),
//           Text(
//             value,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/widgets/daily_report/submit_confirmation_dialog.dart

import 'package:flutter/material.dart';

class SubmitConfirmationDialog extends StatelessWidget {
  final Function() onConfirm;
  final int regularHours;
  final int overtimeHours;

  const SubmitConfirmationDialog({
    Key? key,
    required this.onConfirm,
    required this.regularHours,
    required this.overtimeHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format hours for display
    final regularHoursText = '${regularHours ~/ 60}h ${regularHours % 60}m';
    final overtimeHoursText = '${overtimeHours ~/ 60}h ${overtimeHours % 60}m';
    final hasOvertime = overtimeHours > 0;

    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      title: const Text(
        'Submit Daily Report',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are you sure you want to submit your daily report?',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Hours Summary:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          _buildHourRow('Regular Hours:', regularHoursText),
          _buildHourRow('Overtime Hours:', overtimeHoursText),
          const SizedBox(height: 12),
          if (hasOvertime)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please confirm that you worked $overtimeHoursText of overtime.',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Once submitted, you cannot make further changes to this report.',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF7D104),
            foregroundColor: Colors.black,
          ),
          child: const Text('Confirm & Submit'),
        ),
      ],
    );
  }

  Widget _buildHourRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}