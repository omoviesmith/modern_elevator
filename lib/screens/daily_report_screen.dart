// modern_elevator_app/lib/screens/daily_report_screen.dart

import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
import 'dart:async';

class DailyReportScreen extends StatefulWidget {
  @override
  _DailyReportScreenState createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  // Sample data for tasks
  List<TaskItem> tasks = [
    TaskItem(
      title: 'Install Car Rail Brackets',
      description: 'Completed installation on Level 3',
      timeSpent: Duration(hours: 2, minutes: 30),
      verified: false,
    ),
    TaskItem(
      title: 'Safety Discussions',
      description: 'Discussed safety protocols with team',
      timeSpent: Duration(hours: 1),
      verified: true,
    ),
    TaskItem(
      title: 'Install Controller',
      description: 'Set up controllers for elevators A and B',
      timeSpent: Duration(hours: 3, minutes: 15),
      verified: false,
    ),
  ];

  // Total hours calculation
  Duration totalRegularHours = Duration(hours: 8);
  Duration totalOvertimeHours = Duration(hours: 1);

  // Material Requests
  List<String> materialRequests = ['Gearbox', 'Hydraulic Fluid'];

  bool isSubmitting = false;
  bool allEntriesVerified = false;

  @override
  void initState() {
    super.initState();
    _checkAllEntriesVerified();
  }

  void _checkAllEntriesVerified() {
    bool verified = tasks.every((task) => task.verified == true);
    setState(() {
      allEntriesVerified = verified;
    });
  }

  void _editTask(int index) async {
    TaskItem task = tasks[index];
    // Open edit dialog or screen
    TaskItem? updatedTask = await showDialog<TaskItem>(
      context: context,
      builder: (context) {
        return TaskEditDialog(task: task);
      },
    );

    if (updatedTask != null) {
      setState(() {
        tasks[index] = updatedTask;
      });
      _checkAllEntriesVerified();
    }
  }

  void _submitReport() async {
    if (!allEntriesVerified) {
      // Show tooltip or notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all entries before submitting.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Simulate submission delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isSubmitting = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back or reset the screen
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Daily Report',
      currentIndex: 2, // Updated index corresponding to this screen
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tasks Summary Section
                _buildSectionHeader('Tasks Summary'),
                SizedBox(height: 8),
                ...tasks.asMap().entries.map((entry) {
                  int index = entry.key;
                  TaskItem task = entry.value;
                  return _buildTaskCard(task, index);
                }).toList(),
                SizedBox(height: 24),
                // Hour Totals Section
                _buildSectionHeader('Hour Totals'),
                SizedBox(height: 8),
                _buildHourTotals(),
                SizedBox(height: 24),
                // Material Requests Section
                _buildSectionHeader('Material Requests'),
                SizedBox(height: 8),
                _buildMaterialRequests(),
                SizedBox(height: 24.0),
                _buildSubmitButton(),
              ],
            ),
          ),
          // Submit Button at the bottom
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: _buildSubmitButton(),
          // ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'SF Pro Display',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: Color(0xFFF7D104),
        decoration: TextDecoration.underline,
      ),
    );
  }

  Widget _buildTaskCard(TaskItem task, int index) {
    return GestureDetector(
      onTap: () {
        _editTask(index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: task.verified ? Colors.transparent : Color(0xFFF7D104),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            // Time badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFF7D104),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatDuration(task.timeSpent),
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF040404),
                ),
              ),
            ),
            SizedBox(width: 8),
            // Edit indicator
            if (!task.verified)
              _buildPulsingDot(),
          ],
        ),
      ),
    );
  }

  Widget _buildPulsingDot() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Color(0xFFF7D104),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHourTotals() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Radial progress chart placeholder
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CustomPaint(
                  painter: HourProgressPainter(
                    regularHours: totalRegularHours,
                    overtimeHours: totalOvertimeHours,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${totalRegularHours.inHours}h ${totalRegularHours.inMinutes.remainder(60)}m',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFFF7D104),
                    ),
                  ),
                  Text(
                    'Total Hours',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          // Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHourInfo('Regular', totalRegularHours),
              _buildHourInfo('Overtime', totalOvertimeHours),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourInfo(String label, Duration duration) {
    return Column(
      children: [
        Text(
          '${duration.inHours}h ${duration.inMinutes.remainder(60)}m',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFFF7D104),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialRequests() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: materialRequests.map((material) {
        return Chip(
          label: Text(
            material,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          avatar: Icon(
            Icons.build,
            color: Color(0xFFF7D104),
          ),
          backgroundColor: Color(0xFF1C1C1E),
          shape: StadiumBorder(
            side: BorderSide(color: Color(0xFFF7D104)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: isSubmitting || !allEntriesVerified ? null : _submitReport,
      child: Container(
        height: 60,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: allEntriesVerified
              ? LinearGradient(
                  colors: [Color(0xFFF7D104), Color(0xFFFFD700)],
                )
              : null,
          color: allEntriesVerified ? null : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            allEntriesVerified
                ? BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                : BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Center(
          child: isSubmitting
              ? Container(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF040404)),
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Submit Report',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: allEntriesVerified ? Color(0xFF040404) : Colors.white70,
                  ),
                ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

class TaskItem {
  String title;
  String description;
  Duration timeSpent;
  bool verified;

  TaskItem({
    required this.title,
    required this.description,
    required this.timeSpent,
    this.verified = false,
  });
}

class TaskEditDialog extends StatefulWidget {
  final TaskItem task;

  TaskEditDialog({required this.task});

  @override
  _TaskEditDialogState createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  Duration _timeSpent = Duration();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _timeSpent = widget.task.timeSpent;
  }

  void _saveTask() {
    TaskItem updatedTask = TaskItem(
      title: _titleController.text,
      description: _descriptionController.text,
      timeSpent: _timeSpent,
      verified: true,
    );
    Navigator.of(context).pop(updatedTask);
  }

  void _selectTimeSpent() async {
    // Implement time picker dialog
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _timeSpent.inHours, minute: _timeSpent.inMinutes.remainder(60)),
    );

    if (timeOfDay != null) {
      setState(() {
        _timeSpent = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Field
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 12),
            // Description Field
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 12),
            // Time Spent Selector
            GestureDetector(
              onTap: _selectTimeSpent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Color(0xFFF7D104)),
                    SizedBox(width: 8),
                    Text(
                      'Time Spent: ${_formatDuration(_timeSpent)}',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Save Button
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF7D104),
                foregroundColor: Color(0xFF040404),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

class HourProgressPainter extends CustomPainter {
  final Duration regularHours;
  final Duration overtimeHours;

  HourProgressPainter({required this.regularHours, required this.overtimeHours});

  @override
  void paint(Canvas canvas, Size size) {
    int totalHours = regularHours.inMinutes + overtimeHours.inMinutes;
    double regularAngle = (regularHours.inMinutes / totalHours) * 360;
    double overtimeAngle = (overtimeHours.inMinutes / totalHours) * 360;

    Paint regularPaint = Paint()
      ..color = Color(0xFFF7D104)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    Paint overtimePaint = Paint()
      ..color = Color(0xFFF7D104).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2);

    // Draw regular hours arc
    canvas.drawArc(
      rect,
      -90 * (3.14 / 180),
      regularAngle * (3.14 / 180),
      false,
      regularPaint,
    );

    // Draw overtime hours arc
    canvas.drawArc(
      rect,
      (regularAngle - 90) * (3.14 / 180),
      overtimeAngle * (3.14 / 180),
      false,
      overtimePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}