// lib/widgets/daily_report/material_requests_summary.dart

import 'package:flutter/material.dart';

class MaterialRequestsSummary extends StatelessWidget {
  final List<dynamic> materialRequests;

  const MaterialRequestsSummary({
    Key? key,
    required this.materialRequests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (materialRequests.isEmpty) {
      return const Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No material requests today.'),
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
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            width: double.infinity,
            child: const Text(
              'Material Requests',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: materialRequests.length,
            itemBuilder: (context, index) => _buildRequestTile(context, materialRequests[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestTile(BuildContext context, dynamic request) {
    final projectName = request['project']?['name'] ?? 'Unknown Project';
    final elevatorName = request['elevator']?['name'] ?? 'Unknown Elevator';
    final urgency = request['urgency'] ?? 'NORMAL';
    final status = request['status'] ?? 'PENDING';
    final items = request['items'] ?? [];
    final notes = request['notes'] ?? '';
    final neededByDate = request['neededByDate'];

    Color urgencyColor;
    switch (urgency.toString().toUpperCase()) {
      case 'URGENT':
        urgencyColor = Colors.red;
        break;
      case 'HIGH':
        urgencyColor = Colors.orange;
        break;
      case 'NORMAL':
        urgencyColor = Colors.blue;
        break;
      case 'LOW':
        urgencyColor = Colors.green;
        break;
      default:
        urgencyColor = Colors.grey;
    }

    Color statusColor;
    switch (status.toString().toUpperCase()) {
      case 'APPROVED':
        statusColor = Colors.green;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        break;
      case 'PENDING':
        statusColor = Colors.orange;
        break;
      case 'DELIVERED':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return ExpansionTile(
      title: Text('$projectName - $elevatorName'),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: urgencyColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              urgency.toString().toUpperCase(),
              style: TextStyle(
                color: urgencyColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status.toString().toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (neededByDate != null) ...[
                Text('Needed by: ${_formatDate(neededByDate)}'),
                const SizedBox(height: 8),
              ],
              const Text(
                'Requested Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...items.map((item) => _buildItemRow(item)).toList(),
              if (notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Notes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(notes),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemRow(dynamic item) {
    final materialName = item['material']?['name'] ?? 'Unknown Material';
    final quantity = item['quantity'] ?? 0;
    final unit = item['material']?['unit'] ?? 'pcs';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(materialName),
          ),
          Text('$quantity $unit'),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}