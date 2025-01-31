// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:dotted_border/dotted_border.dart'; // Import the package

// class IssueReportingScreen extends StatefulWidget {
//   @override
//   _IssueReportingScreenState createState() => _IssueReportingScreenState();
// }

// class _IssueReportingScreenState extends State<IssueReportingScreen>
//     with SingleTickerProviderStateMixin {
//   int _selectedIndex = 0; // 0: Issue Reporting, 1: Material Request
//   TabController? _tabController;

//   // Issue Reporting Variables
//   String _selectedIssueType = 'Safety Hazard';
//   TextEditingController _descriptionController = TextEditingController();
//   int _descriptionCharCount = 0;
//   List<String> _attachedImages = [];
//   double _impactLevel = 0;

//   // Material Request Variables
//   TextEditingController _materialSearchController = TextEditingController();
//   List<String> _materials = [
//     'Elevator Cable',
//     'Hydraulic Fluid',
//     'Control Panel',
//   ];
//   String? _selectedMaterial;
//   int _materialQuantity = 1;
//   String _selectedUrgency = 'Standard';

//   // Common Variables
//   bool _isSubmitting = false;
//   bool _isDarkMode = false; // Assume false for now, can be toggled based on theme

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _descriptionController.addListener(() {
//       setState(() {
//         _descriptionCharCount = _descriptionController.text.length;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _tabController?.dispose();
//     _descriptionController.dispose();
//     _materialSearchController.dispose();
//     super.dispose();
//   }

//   void _navigateBack() {
//     Navigator.of(context).pop();
//   }

//   // For consistency, header widget
//   Widget _buildHeaderSection() {
//     return AppBar(
//       backgroundColor: _isDarkMode ? Color(0xFF040404) : Colors.white,
//       elevation: 4,
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back_ios,
//             color: _isDarkMode ? Colors.white : Color(0xFF2A2A2A)),
//         onPressed: _navigateBack,
//       ),
//       title: Text(
//         'Report & Request',
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'SFProDisplay',
//           color: _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
//         ),
//       ),
//       centerTitle: true,
//       bottom: PreferredSize(
//         preferredSize: Size.fromHeight(50),
//         child: Container(
//           decoration: BoxDecoration(
//             color: _isDarkMode ? Color(0xFF1C1C1C) : Color(0xFFF8F8F8),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4,
//               ),
//             ],
//           ),
//           child: TabBar(
//             controller: _tabController,
//             indicatorColor: Color(0xFFF7D104),
//             labelColor: _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
//             unselectedLabelColor:
//                 _isDarkMode ? Colors.white70 : Colors.black54,
//             labelStyle: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'SFProDisplay',
//             ),
//             tabs: [
//               Tab(text: 'Issue Reporting'),
//               Tab(text: 'Material Request'),
//             ],
//             onTap: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(100),
//         child: _buildHeaderSection(),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildIssueReportingForm(),
//           _buildMaterialRequestForm(),
//         ],
//       ),
//     );
//   }

//   // Issue Reporting Form
//   Widget _buildIssueReportingForm() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Issue Type Selection
//           Text(
//             'Issue Type',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'SFProDisplay',
//               color: _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
//             ),
//           ),
//           SizedBox(height: 8),
//           _buildIssueTypeSelection(),
//           SizedBox(height: 16),
//           // Description Field
//           Text(
//             'Description',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'SFProDisplay',
//               color: _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
//             ),
//           ),
//           SizedBox(height: 8),
//           _buildDescriptionField(),
//           SizedBox(height: 16),
//           // Photo/Document Attachment
//           Text(
//             'Attachments',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'SFProDisplay',
//               color: _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
//             ),
//           ),
//           SizedBox(height: 8),
//           _buildAttachmentSection(),
//           SizedBox(height: 16),
//           // Impact Selection
//           Text(
//             'Impact Level',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'SFProDisplay',
//               color: _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
//             ),
//           ),
//           SizedBox(height: 8),
//           _buildImpactSlider(),
//           SizedBox(height: 24),
//           // Submit Button
//           _buildSubmitButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildIssueTypeSelection() {
//     List<String> issueTypes = [
//       'Safety Hazard',
//       'Equipment Malfunction',
//       'Environmental',
//       'Other',
//     ];
//     List<IconData> icons = [
//       Icons.warning,
//       Icons.build,
//       Icons.eco,
//       Icons.help_outline,
//     ];
//     return Wrap(
//       spacing: 12,
//       children: List.generate(issueTypes.length, (index) {
//         String type = issueTypes[index];
//         IconData icon = icons[index];
//         bool isSelected = _selectedIssueType == type;
//         return ChoiceChip(
//           label: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 color: isSelected ? Colors.white : Color(0xFFF7D104),
//               ),
//               SizedBox(width: 4),
//               Text(
//                 type,
//                 style: TextStyle(
//                   fontFamily: 'SFProDisplay',
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: isSelected ? Colors.white : Color(0xFF2A2A2A),
//                 ),
//               ),
//             ],
//           ),
//           selected: isSelected,
//           selectedColor: Color(0xFFF7D104),
//           backgroundColor: _isDarkMode ? Color(0xFF1E1E1E) : Colors.grey[200],
//           onSelected: (selected) {
//             setState(() {
//               _selectedIssueType = type;
//             });
//           },
//         );
//       }),
//     );
//   }

//   Widget _buildDescriptionField() {
//     return TextField(
//       controller: _descriptionController,
//       maxLines: 5,
//       maxLength: 500,
//       decoration: InputDecoration(
//         hintText: 'Enter issue description',
//         hintStyle: TextStyle(
//           fontFamily: 'SFProDisplay',
//           fontSize: 16,
//           color: Colors.grey,
//         ),
//         filled: true,
//         fillColor: _isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFF8F8F8),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         counterText: '${_descriptionCharCount}/500',
//         counterStyle: TextStyle(
//           fontFamily: 'SFProDisplay',
//           fontSize: 12,
//           color: Colors.grey,
//         ),
//       ),
//       style: TextStyle(
//         fontFamily: 'SFProDisplay',
//         fontSize: 16,
//         color: _isDarkMode ? Colors.white : Colors.black,
//       ),
//     );
//   }

//   Widget _buildAttachmentSection() {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: [
//         // Existing attachments
//         ..._attachedImages.map((image) {
//           return Stack(
//             alignment: Alignment.topRight,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: DecorationImage(
//                     image: AssetImage('assets/images/$image'), // Placeholder
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _attachedImages.remove(image);
//                   });
//                 },
//                 child: CircleAvatar(
//                   radius: 12,
//                   backgroundColor: Colors.red,
//                   child: Icon(
//                     Icons.close,
//                     size: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//         // Add attachment button
//         GestureDetector(
//           onTap: () {
//             // Implement image picker functionality
//             setState(() {
//               _attachedImages.add('placeholder.png'); // Placeholder
//             });
//           },
//           child: DottedBorder(
//             color: Colors.grey,
//             strokeWidth: 1,
//             borderType: BorderType.RRect,
//             radius: Radius.circular(8),
//             dashPattern: [4, 4],
//             child: Container(
//               width: 80,
//               height: 80,
//               color: Colors.transparent,
//               child: Center(
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildImpactSlider() {
//     return Column(
//       children: [
//         SliderTheme(
//           data: SliderThemeData(
//             activeTrackColor: Color(0xFFF7D104),
//             inactiveTrackColor: Colors.grey[300],
//             thumbColor: Color(0xFFF7D104),
//             overlayColor: Color(0xFFF7D104).withOpacity(0.2),
//             valueIndicatorColor: Color(0xFFF7D104),
//           ),
//           child: Slider(
//             value: _impactLevel,
//             min: 0,
//             max: 100,
//             divisions: 5,
//             label: '${(_impactLevel / 20).round()}',
//             onChanged: (value) {
//               HapticFeedback.lightImpact();
//               setState(() {
//                 _impactLevel = value;
//               });
//             },
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(6, (index) {
//             return Text(
//               '$index',
//               style: TextStyle(
//                 fontFamily: 'SFProDisplay',
//                 fontSize: 12,
//                 color: _isDarkMode ? Colors.white70 : Colors.black54,
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   // Material Request Form
//   Widget _buildMaterialRequestForm() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Material Selection
//           Text(
//             'Material',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'SFProDisplay',
//               color: _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
//             ),
//           ),
//           SizedBox(height: 8),
//           _buildMaterialSearchField(),
//           SizedBox(height: 16),
//           // Quantity and Urgency
//           Text(
//             'Quantity & Urgency',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'SFProDisplay',
//               color: _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
//             ),
//           ),
//           SizedBox(height: 8),
//           _buildQuantityAndUrgency(),
//           SizedBox(height: 24),
//           // Submit Button
//           _buildSubmitButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMaterialSearchField() {
//     return TextField(
//       controller: _materialSearchController,
//       decoration: InputDecoration(
//         hintText: 'Search Material',
//         hintStyle: TextStyle(
//           fontFamily: 'SFProDisplay',
//           fontSize: 16,
//           color: Colors.grey,
//         ),
//         filled: true,
//         fillColor: _isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFF8F8F8),
//         prefixIcon: Icon(
//           Icons.search,
//           color: Color(0xFFF7D104),
//         ),
//         suffixIcon: GestureDetector(
//           onTap: () {
//             // Implement add new material functionality
//           },
//           child: Icon(
//             Icons.add,
//             color: Color(0xFFF7D104),
//           ),
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       style: TextStyle(
//         fontFamily: 'SFProDisplay',
//         fontSize: 16,
//         color: _isDarkMode ? Colors.white : Colors.black,
//       ),
//       onChanged: (value) {
//         // Implement search functionality
//       },
//       onTap: () {
//         // Show autocomplete dropdown
//         _showMaterialDropdown();
//       },
//     );
//   }

//   void _showMaterialDropdown() {
//     // Implement material dropdown with recent selections
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return ListView(
//           children: _materials.map((material) {
//             return ListTile(
//               title: Text(
//                 material,
//                 style: TextStyle(
//                   fontFamily: 'SFProDisplay',
//                   fontSize: 16,
//                 ),
//               ),
//               onTap: () {
//                 setState(() {
//                   _selectedMaterial = material;
//                   _materialSearchController.text = material;
//                 });
//                 Navigator.of(context).pop();
//               },
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   Widget _buildQuantityAndUrgency() {
//     return Row(
//       children: [
//         // Quantity Selector
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Quantity',
//                   style: TextStyle(
//                     fontFamily: 'SFProDisplay',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: _isDarkMode ? Colors.white70 : Colors.black54,
//                   )),
//               SizedBox(height: 8),
//               Container(
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: _isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFF8F8F8),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           if (_materialQuantity > 1) _materialQuantity--;
//                         });
//                       },
//                       icon: Icon(Icons.remove_circle_outline,
//                           color: Color(0xFFF7D104)),
//                     ),
//                     Expanded(
//                       child: Center(
//                         child: AnimatedSwitcher(
//                           duration: Duration(milliseconds: 300),
//                           child: Text(
//                             '$_materialQuantity',
//                             key: ValueKey<int>(_materialQuantity),
//                             style: TextStyle(
//                               fontFamily: 'SFProDisplay',
//                               fontSize: 16,
//                               color:
//                                   _isDarkMode ? Colors.white : Color(0xFF2A2A2A),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _materialQuantity++;
//                         });
//                       },
//                       icon: Icon(Icons.add_circle_outline,
//                           color: Color(0xFFF7D104)),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(width: 16),
//         // Urgency Selector
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Urgency',
//                   style: TextStyle(
//                     fontFamily: 'SFProDisplay',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: _isDarkMode ? Colors.white70 : Colors.black54,
//                   )),
//               SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: _selectedUrgency,
//                 items: ['Standard', 'High', 'Critical'].map((urgency) {
//                   Color urgencyColor;
//                   switch (urgency) {
//                     case 'High':
//                       urgencyColor = Colors.orange;
//                       break;
//                     case 'Critical':
//                       urgencyColor = Colors.red;
//                       break;
//                     default:
//                       urgencyColor = Color(0xFFF7D104);
//                   }
//                   return DropdownMenuItem(
//                     value: urgency,
//                     child: Text(
//                       urgency,
//                       style: TextStyle(
//                         fontFamily: 'SFProDisplay',
//                         fontSize: 16,
//                         color: urgencyColor,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedUrgency = value!;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor:
//                       _isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFF8F8F8),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 icon: Icon(Icons.keyboard_arrow_down,
//                     color: Color(0xFFF7D104)),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _isSubmitting ? null : _handleSubmit,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Color(0xFFF7D104),
//           padding: EdgeInsets.symmetric(vertical: 16),
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: _isSubmitting
//             ? CircularProgressIndicator(
//                 color: Colors.white,
//               )
//             : Text(
//                 'Submit',
//                 style: TextStyle(
//                   fontFamily: 'SFProDisplay',
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//       ),
//     );
//   }

//   void _handleSubmit() {
//     setState(() {
//       _isSubmitting = true;
//     });

//     // Simulate async operation
//     Future.delayed(Duration(seconds: 2), () {
//       setState(() {
//         _isSubmitting = false;
//       });

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Submission Successful!',
//             style: TextStyle(
//               fontFamily: 'SFProDisplay',
//             ),
//           ),
//           backgroundColor: Colors.green,
//         ),
//       );

//       // Clear form
//       _clearForm();
//     });
//   }

//   void _clearForm() {
//     setState(() {
//       // Issue Reporting Variables
//       _selectedIssueType = 'Safety Hazard';
//       _descriptionController.clear();
//       _attachedImages.clear();
//       _impactLevel = 0;

//       // Material Request Variables
//       _materialSearchController.clear();
//       _selectedMaterial = null;
//       _materialQuantity = 1;
//       _selectedUrgency = 'Standard';
//     });
//   }
// }

// modern_elevator_app/lib/screens/issue_reporting_screen.dart
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../widgets/base_scaffold.dart';

void main() {
  runApp(MaterialApp(
    home: IssueReportingMaterialRequestScreen(),
    theme: ThemeData(
      fontFamily: 'SF Pro Display',
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class IssueReportingMaterialRequestScreen extends StatefulWidget {
  @override
  _IssueReportingMaterialRequestScreenState createState() =>
      _IssueReportingMaterialRequestScreenState();
}

class _IssueReportingMaterialRequestScreenState
    extends State<IssueReportingMaterialRequestScreen> {
  // Collapse states
  bool isIssueReportingExpanded = true;
  bool isMaterialRequestExpanded = false;

  // Issue Reporting Variables
  String issueType = 'Delay';
  String description = '';
  String impactLevel = 'Low';

  // Material Request Variables
  List<String> materials = [];
  String materialInput = '';
  int quantity = 1;
  String urgency = 'Low';
  String comments = '';

  // Form Validation
  bool get isFormValid =>
      description.isNotEmpty &&
      materials.isNotEmpty &&
      issueType.isNotEmpty &&
      impactLevel.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Issue Reporting & Material Request',
      currentIndex: 1,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            issueReportingSection(),
            SizedBox(height: 16.0),
            materialRequestSection(),
            SizedBox(height: 24.0),
            submitButton(),
          ],
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Color(0xFF040404), // Dark background
  //     appBar: AppBar(
  //       title: Text(
  //         'Issue Reporting & Material Request',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       backgroundColor: Color(0xFF040404),
  //       elevation: 0,
  //     ),
  //     body: SingleChildScrollView(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           issueReportingSection(),
  //           SizedBox(height: 16.0),
  //           materialRequestSection(),
  //           SizedBox(height: 24.0),
  //           submitButton(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Issue Reporting Section
  Widget issueReportingSection() {
    return expansionCard(
      title: 'Issue Reporting',
      isExpanded: isIssueReportingExpanded,
      onExpansionChanged: (value) {
        setState(() {
          isIssueReportingExpanded = value;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectIssueType(),
          SizedBox(height: 16.0),
          descriptionField(),
          SizedBox(height: 16.0),
          attachPhotosField(),
          SizedBox(height: 16.0),
          specifyImpact(),
        ],
      ),
    );
  }

  // Material Request Section
  Widget materialRequestSection() {
    return expansionCard(
      title: 'Material Request',
      isExpanded: isMaterialRequestExpanded,
      onExpansionChanged: (value) {
        setState(() {
          isMaterialRequestExpanded = value;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectMaterials(),
          SizedBox(height: 16.0),
          quantityAndUrgency(),
          SizedBox(height: 16.0),
          commentsField(),
        ],
      ),
    );
  }

  // Expansion Card Widget
  Widget expansionCard({
    required String title,
    required bool isExpanded,
    required Function(bool) onExpansionChanged,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF121212), // Slightly lighter than background
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500, // Medium
            ),
          ),
          backgroundColor: Color(0xFF121212),
          collapsedBackgroundColor: Color(0xFF121212),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  // Select Issue Type Widget
  Widget selectIssueType() {
    List<String> issueTypes = ['Delay', 'Safety Concern', 'Equipment Failure'];
    return columnWithLabel(
      label: 'Select Issue Type',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: issueType,
            dropdownColor: Color(0xFF1E1E1E),
            iconEnabledColor: Colors.white,
            items: issueTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Row(
                  children: [
                    Icon(
                      _getIssueTypeIcon(type),
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(type, style: TextStyle(color: Colors.white)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                issueType = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  IconData _getIssueTypeIcon(String type) {
    switch (type) {
      case 'Delay':
        return Icons.access_time;
      case 'Safety Concern':
        return Icons.warning;
      case 'Equipment Failure':
        return Icons.build;
      default:
        return Icons.error;
    }
  }

  // Description Field Widget
  Widget descriptionField() {
    return columnWithLabel(
      label: 'Description',
      child: TextFormField(
        maxLines: 4,
        maxLength: 500,
        style: TextStyle(color: Colors.white),
        decoration: inputDecoration(
          hintText: 'Enter a detailed description...',
        ),
        onChanged: (value) {
          setState(() {
            description = value;
          });
        },
      ),
    );
  }

  // Attach Photos Field Widget
  Widget attachPhotosField() {
    return columnWithLabel(
      label: 'Attach Photos/Documents OR Take Photos',
      child: InkWell(
        onTap: () {
          // Handle file picker or camera
        },
        child: DottedBorder(
          color: Color(0xFFF7D104), // Yellow
          borderType: BorderType.RRect,
          radius: Radius.circular(8.0),
          dashPattern: [6, 3],
          child: Container(
            height: 100.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: Color(0xFFF7D104),
                size: 40.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Specify Impact Widget
  Widget specifyImpact() {
    List<String> impactLevels = ['Low', 'Medium', 'High'];
    return columnWithLabel(
      label: 'Specify Impact',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: impactLevel,
            dropdownColor: Color(0xFF1E1E1E),
            iconEnabledColor: Colors.white,
            items: impactLevels.map((level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: _getImpactColor(level),
                    ),
                    SizedBox(width: 8.0),
                    Text(level, style: TextStyle(color: Colors.white)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                impactLevel = value!;
              });
            },
          ),
        ),
      ),
    );
  }

  Color _getImpactColor(String level) {
    switch (level) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.yellow;
      case 'High':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  // Select Materials Widget
  Widget selectMaterials() {
    return columnWithLabel(
      label: 'Select Materials',
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: inputDecoration(
              hintText: 'Search or add materials...',
              suffixIcon: IconButton(
                icon: Icon(Icons.add, color: Color(0xFFF7D104)),
                onPressed: () {
                  if (materialInput.isNotEmpty) {
                    setState(() {
                      materials.add(materialInput);
                      materialInput = '';
                    });
                  }
                },
              ),
            ),
            onChanged: (value) {
              materialInput = value;
            },
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  materials.add(value);
                  materialInput = '';
                });
              }
            },
          ),
          SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: materials.map((material) {
              return Chip(
                label: Text(material),
                backgroundColor: Color(0xFF1E1E1E),
                labelStyle: TextStyle(color: Colors.white),
                deleteIconColor: Color(0xFFF7D104),
                onDeleted: () {
                  setState(() {
                    materials.remove(material);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Quantity and Urgency Widget
  Widget quantityAndUrgency() {
    return Row(
      children: [
        Expanded(
          child: columnWithLabel(
            label: 'Quantity',
            child: Container(
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: Color(0xFFF7D104)),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      quantity.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Color(0xFFF7D104)),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: columnWithLabel(
            label: 'Urgency',
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: urgency,
                  dropdownColor: Color(0xFF1E1E1E),
                  iconEnabledColor: Colors.white,
                  items: ['Low', 'Medium', 'High'].map((level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: _getImpactColor(level),
                          ),
                          SizedBox(width: 8.0),
                          Text(level, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      urgency = value!;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Comments Field Widget
  Widget commentsField() {
    return columnWithLabel(
      label: 'Comments (Optional)',
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      ),
      child: TextFormField(
        maxLines: 2,
        style: TextStyle(color: Colors.white),
        decoration: inputDecoration(
          hintText: 'Add any additional comments...',
        ),
        onChanged: (value) {
          setState(() {
            comments = value;
          });
        },
      ),
    );
  }

  // Submit Button Widget
  Widget submitButton() {
    return ElevatedButton(
      onPressed: isFormValid ? _handleSubmit : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xFF040404), backgroundColor: isFormValid ? Color(0xFFF7D104) : Colors.grey,
        minimumSize: Size(double.infinity, 50.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: isFormValid ? 4.0 : 0.0,
      ),
      child: Text(
        'Submit',
        style: TextStyle(
          fontWeight: FontWeight.w600, // SemiBold
          fontSize: 16.0,
        ),
      ),
    );
  }

  void _handleSubmit() {
    // Handle form submission
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8.0),
            Text('Report submitted successfully!'),
          ],
        ),
        backgroundColor: Color(0xFF1E1E1E),
      ),
    );
  }

  // Helper Widgets
  Widget columnWithLabel({
    required String label,
    required Widget child,
    TextStyle? labelStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ??
              TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8.0),
        child,
      ],
    );
  }

  InputDecoration inputDecoration({String? hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      suffixIcon: suffixIcon,
    );
  }
}