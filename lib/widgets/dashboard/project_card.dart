// modern_elevator_app/lib/widgets/dashboard/project_card.dart
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String siteName;
  final String elevatorNumber;
  final VoidCallback? onTap;

  const ProjectCard({
    Key? key,
    required this.siteName,
    required this.elevatorNumber,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color(0xFF121212),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(
            Icons.location_on,
            color: Color(0xFFF7D104),
          ),
          title: Text(
            siteName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            elevatorNumber,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
            size: 16,
          ),
        ),
      ),
    );
  }
}