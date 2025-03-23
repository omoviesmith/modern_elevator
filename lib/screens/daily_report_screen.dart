// lib/screens/daily_report_review_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/daily_report_provider.dart';
import '../utils/time_formatter.dart';
import '../widgets/daily_report/category_section.dart';
import '../widgets/daily_report/task_detail_dialog.dart';
import '../widgets/daily_report/issues_summary.dart';
import '../widgets/daily_report/material_requests_summary.dart';
import '../widgets/daily_report/hours_summary.dart';
import '../widgets/daily_report/submit_confirmation_dialog.dart';
import '../widgets/base_scaffold.dart';

class DailyReportReviewScreen extends StatefulWidget {
  final String? reportId;
  final String? date;

  const DailyReportReviewScreen({
    super.key,
    this.reportId,
    this.date,
  });

  @override
  _DailyReportReviewScreenState createState() => _DailyReportReviewScreenState();
}

class _DailyReportReviewScreenState extends State<DailyReportReviewScreen> {
  final ScrollController _scrollController = ScrollController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Defer the call to _loadReport until after the current build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReport();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadReport() async {
    final provider = Provider.of<DailyReportProvider>(context, listen: false);

    // If specific reportId is provided, fetch that report
    if (widget.reportId != null) {
      await provider.fetchReportById(widget.reportId!);
    }
    // If date is provided, fetch report for that date
    else if (widget.date != null) {
      await provider.fetchReportByDate(widget.date!);
      try {
        _selectedDate = DateTime.parse(widget.date!);
      } catch (e) {
        // If date parsing fails, keep current date
      }
    }
    // Otherwise fetch today's report
    else {
      await provider.fetchTodayReport();
    }
  }

  void _selectDate(BuildContext context) async {
    final provider = Provider.of<DailyReportProvider>(context, listen: false);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFF7D104),
              onPrimary: Colors.black,
              surface: Color(0xFF040404),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF121212),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      // Format the date as required by the API (YYYY-MM-DD)
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);

      await provider.fetchReportByDate(formattedDate);
    }
  }

  void _handleTimeEntryTap(dynamic timeEntry) {
    showDialog(
      context: context,
      builder: (context) => TaskDetailDialog(
        timeEntry: timeEntry,
        onUpdate: _canEditReport() ? _handleUpdateTimeEntry : null,
      ),
    );
  }

  bool _canEditReport() {
    final provider = Provider.of<DailyReportProvider>(context, listen: false);
    final report = provider.currentReport;
    if (report == null) return false;

    return report.status.toLowerCase() == 'draft';
  }

  Future<void> _handleUpdateTimeEntry(dynamic entry, Map<String, dynamic> data) async {
    final provider = Provider.of<DailyReportProvider>(context, listen: false);
    await provider.updateTimeEntry(entry['id'], data);
  }

  Future<void> _handleSubmitReport() async {
    final provider = Provider.of<DailyReportProvider>(context, listen: false);
    final report = provider.currentReport;

    if (report == null) return;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => SubmitConfirmationDialog(
        onConfirm: () async {
          final success = await provider.submitReport();
          if (!mounted) return; // Ensure the widget is still mounted
          final currentContext = context; // Store context to use after async gap
          if (success) {
            ScaffoldMessenger.of(currentContext).showSnackBar(
              const SnackBar(
                content: Text('Report submitted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(currentContext).showSnackBar(
              SnackBar(
                content: Text('Failed to submit report: ${provider.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        regularHours: report.totalRegularMinutes,
        overtimeHours: report.totalOvertimeMinutes,
      ),
    );
  }

  Future<void> _refreshReport() async {
    final provider = Provider.of<DailyReportProvider>(context, listen: false);

    if (widget.reportId != null) {
      await provider.fetchReportById(widget.reportId!);
    } else {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      await provider.fetchReportByDate(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Daily Report Review',
      currentIndex: 2, // Update to match the index in BaseScaffold
      showFAB: true, // Show the FAB as in other screens
      body: Consumer<DailyReportProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF7D104),
              ),
            );
          }

          final report = provider.currentReport;

          if (report == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.assignment_late_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No report available for ${DateFormat('MMMM d, yyyy').format(_selectedDate)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7D104),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: _refreshReport,
                    child: const Text('Refresh'),
                  )
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshReport,
            color: const Color(0xFFF7D104),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeaderSection(report),
                    const SizedBox(height: 16),

                    // Error message if any
                    if (provider.error != null && provider.error!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(26), // Replaced withOpacity(0.1) with withAlpha(26)
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                provider.error!,
                                style: TextStyle(color: Colors.red.shade300),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: provider.clearError,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Hours Summary Section
                    HoursSummary(
                      regularMinutes: report.totalRegularMinutes,
                      overtimeMinutes: report.totalOvertimeMinutes,
                      onSubmit: _canEditReport() ? _handleSubmitReport : null,
                      isSubmitting: provider.isSubmitting,
                      reportStatus: report.status,
                    ),

                    const SizedBox(height: 24),

                    // Activities Section Title
                    const Text(
                      'Daily Activities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Task Categories
                    if (report.taskCategories.isEmpty)
                      _buildEmptyActivitiesCard()
                    else
                      ...report.taskCategories.map((category) => CategorySection(
                            categoryName: category['name'],
                            timeEntries: category['timeEntries'] ?? [],
                            onEntryTap: _handleTimeEntryTap,
                          )),

                    const SizedBox(height: 24),

                    // Issues Section Title
                    const Text(
                      'Issues & Materials',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Issues Summary
                    IssuesSummary(issues: report.issues),

                    const SizedBox(height: 16),

                    // Material Requests Summary
                    MaterialRequestsSummary(materialRequests: report.materialRequests),

                    // Submit button at the end of the screen
                    if (_canEditReport()) ...[
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          backgroundColor: const Color(0xFFF7D104),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: provider.isSubmitting ? null : _handleSubmitReport,
                        child: provider.isSubmitting
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Submitting...',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'SUBMIT DAILY REPORT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],

                    // Add space at bottom for better scrolling
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyActivitiesCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.assignment_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'No activities recorded for this day',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(dynamic report) {
    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFF7D104),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          TimeFormatter.formatDate(report.reportDate),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.date_range, color: Color(0xFFF7D104)),
                  onPressed: () => _selectDate(context),
                  tooltip: 'Select Date',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Color(0xFFF7D104),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    report.mechanicName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.assignment,
                  color: Color(0xFFF7D104),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(report.status).withAlpha(51), // Replaced withOpacity(0.2) with withAlpha(51)
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Status: ${report.status.toUpperCase()}',
                    style: TextStyle(
                      color: _getStatusColor(report.status),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return Colors.orange;
      case 'SUBMITTED':
        return Colors.green;
      case 'APPROVED':
        return Colors.blue;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// // // lib/screens/daily_report_review_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../providers/daily_report_provider.dart';
// import '../utils/time_formatter.dart';
// import '../widgets/daily_report/category_section.dart';
// import '../widgets/daily_report/task_detail_dialog.dart';
// import '../widgets/daily_report/issues_summary.dart';
// import '../widgets/daily_report/material_requests_summary.dart';
// import '../widgets/daily_report/hours_summary.dart';
// import '../widgets/daily_report/submit_confirmation_dialog.dart';
// import '../widgets/base_scaffold.dart';

// class DailyReportReviewScreen extends StatefulWidget {
//   final String? reportId;
//   final String? date;

//   const DailyReportReviewScreen({
//     super.key,
//     this.reportId,
//     this.date,
//   });

//   @override
//   DailyReportReviewScreenState createState() => DailyReportReviewScreenState();
// }

// class DailyReportReviewScreenState extends State<DailyReportReviewScreen> {
//   final ScrollController _scrollController = ScrollController();
//   DateTime _selectedDate = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     // Defer the call to _loadReport until after the current build phase
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadReport();
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadReport() async {
//     final provider = Provider.of<DailyReportProvider>(context, listen: false);

//     // If specific reportId is provided, fetch that report
//     if (widget.reportId != null) {
//       await provider.fetchReportById(widget.reportId!);
//     }
//     // If date is provided, fetch report for that date
//     else if (widget.date != null) {
//       await provider.fetchReportByDate(widget.date!);
//       try {
//         _selectedDate = DateTime.parse(widget.date!);
//       } catch (e) {
//         // If date parsing fails, keep current date
//       }
//     }
//     // Otherwise fetch today's report
//     else {
//       await provider.fetchTodayReport();
//     }
//   }

//   void _selectDate(BuildContext context) async {
//     final provider = Provider.of<DailyReportProvider>(context, listen: false); // Capture provider before async call

//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.dark().copyWith(
//             colorScheme: ColorScheme.dark(
//               primary: const Color(0xFFF7D104),
//               onPrimary: Colors.black,
//               surface: const Color(0xFF040404),
//               onSurface: Colors.white,
//             ),
//             dialogBackgroundColor: const Color(0xFF121212),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });

//       // Format the date as required by the API (YYYY-MM-DD)
//       final formattedDate = DateFormat('yyyy-MM-dd').format(picked);

//       await provider.fetchReportByDate(formattedDate); // Use the captured provider
//     }
//   }

//   void _handleTimeEntryTap(dynamic timeEntry) {
//     showDialog(
//       context: context,
//       builder: (context) => TaskDetailDialog(
//         timeEntry: timeEntry,
//         onUpdate: _canEditReport() ? _handleUpdateTimeEntry : null,
//       ),
//     );
//   }

//   bool _canEditReport() {
//     final provider = Provider.of<DailyReportProvider>(context, listen: false);
//     final report = provider.currentReport;
//     if (report == null) return false;

//     return report.status.toLowerCase() == 'draft';
//   }

//   Future<void> _handleUpdateTimeEntry(dynamic entry, Map<String, dynamic> data) async {
//     final provider = Provider.of<DailyReportProvider>(context, listen: false); // Capture provider before async call
//     await provider.updateTimeEntry(entry['id'], data);
//   }

//   Future<void> _handleSubmitReport() async {
//     final provider = Provider.of<DailyReportProvider>(context, listen: false); // Capture provider before async call
//     final report = provider.currentReport;

//     if (report == null) return;

//     // Show confirmation dialog
//     showDialog(
//       context: context,
//       builder: (context) => SubmitConfirmationDialog(
//         onConfirm: () async {
//           final success = await provider.submitReport();
//           if (success) {
//             if (!mounted) return; // Ensure the widget is still mounted
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Report submitted successfully'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           } else {
//             if (!mounted) return; // Ensure the widget is still mounted
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Failed to submit report: ${provider.error}'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         regularHours: report.totalRegularMinutes,
//         overtimeHours: report.totalOvertimeMinutes,
//       ),
//     );
//   }

//   Future<void> _refreshReport() async {
//     final provider = Provider.of<DailyReportProvider>(context, listen: false); // Capture provider before async call

//     if (widget.reportId != null) {
//       await provider.fetchReportById(widget.reportId!);
//     } else {
//       final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
//       await provider.fetchReportByDate(formattedDate);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       title: 'Daily Report Review',
//       currentIndex: 2, // Update to match the index in BaseScaffold
//       showFAB: true, // Show the FAB as in other screens
//       body: Consumer<DailyReportProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFFF7D104),
//               ),
//             );
//           }

//           final report = provider.currentReport;

//           if (report == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.assignment_late_outlined,
//                     size: 64,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No report available for ${DateFormat('MMMM d, yyyy').format(_selectedDate)}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFF7D104),
//                       foregroundColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                     onPressed: _refreshReport,
//                     child: const Text('Refresh'),
//                   )
//                 ],
//               ),
//             );
//           }

//           return RefreshIndicator(
//             onRefresh: _refreshReport,
//             color: const Color(0xFFF7D104),
//             child: SingleChildScrollView(
//               controller: _scrollController,
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header Section
//                     _buildHeaderSection(report),
//                     const SizedBox(height: 16),

//                     // Error message if any
//                     if (provider.error != null && provider.error!.isNotEmpty) ...[
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.red.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.red.shade300),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.error_outline, color: Colors.red),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 provider.error!,
//                                 style: TextStyle(color: Colors.red.shade300),
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.close, color: Colors.red),
//                               onPressed: provider.clearError,
//                             )
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                     ],

//                     // Hours Summary Section
//                     HoursSummary(
//                       regularMinutes: report.totalRegularMinutes,
//                       overtimeMinutes: report.totalOvertimeMinutes,
//                       onSubmit: _canEditReport() ? _handleSubmitReport : null,
//                       isSubmitting: provider.isSubmitting,
//                       reportStatus: report.status,
//                     ),

//                     const SizedBox(height: 24),

//                     // Activities Section Title
//                     const Text(
//                       'Daily Activities',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Task Categories
//                     if (report.taskCategories.isEmpty)
//                       _buildEmptyActivitiesCard()
//                     else
//                       ...report.taskCategories.map((category) => CategorySection(
//                             categoryName: category['name'],
//                             timeEntries: category['timeEntries'] ?? [],
//                             onEntryTap: _handleTimeEntryTap,
//                           )),

//                     const SizedBox(height: 24),

//                     // Issues Section Title
//                     const Text(
//                       'Issues & Materials',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Issues Summary
//                     IssuesSummary(issues: report.issues),

//                     const SizedBox(height: 16),

//                     // Material Requests Summary
//                     MaterialRequestsSummary(materialRequests: report.materialRequests),

//                     // Submit button at the end of the screen
//                     if (_canEditReport()) ...[
//                       const SizedBox(height: 32),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size(double.infinity, 54),
//                           backgroundColor: const Color(0xFFF7D104),
//                           foregroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 4,
//                         ),
//                         onPressed: provider.isSubmitting ? null : _handleSubmitReport,
//                         child: provider.isSubmitting
//                             ? const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.black,
//                                       strokeWidth: 2,
//                                     ),
//                                   ),
//                                   SizedBox(width: 12),
//                                   Text(
//                                     'Submitting...',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : const Text(
//                                 'SUBMIT DAILY REPORT',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                       ),
//                     ],

//                     // Add space at bottom for better scrolling
//                     const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildEmptyActivitiesCard() {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       color: const Color(0xFF1E1E1E),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Icon(
//               Icons.assignment_outlined,
//               size: 48,
//               color: Colors.grey,
//             ),
//             SizedBox(height: 12),
//             Text(
//               'No activities recorded for this day',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(dynamic report) {
//     return Card(
//       color: const Color(0xFF1E1E1E),
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.calendar_today,
//                         color: Color(0xFFF7D104),
//                         size: 18,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           TimeFormatter.formatDate(report.reportDate),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.date_range, color: Color(0xFFF7D104)),
//                   onPressed: () => _selectDate(context),
//                   tooltip: 'Select Date',
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 const Icon(
//                   Icons.person,
//                   color: Color(0xFFF7D104),
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     report.mechanicName,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 const Icon(
//                   Icons.assignment,
//                   color: Color(0xFFF7D104),
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(report.status).withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     'Status: ${report.status.toUpperCase()}',
//                     style: TextStyle(
//                       color: _getStatusColor(report.status),
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toUpperCase()) {
//       case 'DRAFT':
//         return Colors.orange;
//       case 'SUBMITTED':
//         return Colors.green;
//       case 'APPROVED':
//         return Colors.blue;
//       case 'REJECTED':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }