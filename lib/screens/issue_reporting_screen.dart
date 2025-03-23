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
// import 'package:flutter/material.dart';
// import 'package:dotted_border/dotted_border.dart';
// import '../widgets/base_scaffold.dart';

// void main() {
//   runApp(MaterialApp(
//     home: IssueReportingMaterialRequestScreen(),
//     theme: ThemeData(
//       fontFamily: 'SF Pro Display',
//     ),
//     debugShowCheckedModeBanner: false,
//   ));
// }

// class IssueReportingMaterialRequestScreen extends StatefulWidget {
//   @override
//   _IssueReportingMaterialRequestScreenState createState() =>
//       _IssueReportingMaterialRequestScreenState();
// }

// class _IssueReportingMaterialRequestScreenState
//     extends State<IssueReportingMaterialRequestScreen> {
//   // Collapse states
//   bool isIssueReportingExpanded = true;
//   bool isMaterialRequestExpanded = false;

//   // Issue Reporting Variables
//   String issueType = 'Delay';
//   String description = '';
//   String impactLevel = 'Low';

//   // Material Request Variables
//   List<String> materials = [];
//   String materialInput = '';
//   int quantity = 1;
//   String urgency = 'Low';
//   String comments = '';

//   // Form Validation
//   bool get isFormValid =>
//       description.isNotEmpty &&
//       materials.isNotEmpty &&
//       issueType.isNotEmpty &&
//       impactLevel.isNotEmpty;

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       title: 'Issue Reporting & Material Request',
//       currentIndex: 1,
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             issueReportingSection(),
//             SizedBox(height: 16.0),
//             materialRequestSection(),
//             SizedBox(height: 24.0),
//             submitButton(),
//           ],
//         ),
//       ),
//     );
//   }


//   // Issue Reporting Section
//   Widget issueReportingSection() {
//     return expansionCard(
//       title: 'Issue Reporting',
//       isExpanded: isIssueReportingExpanded,
//       onExpansionChanged: (value) {
//         setState(() {
//           isIssueReportingExpanded = value;
//         });
//       },
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           selectIssueType(),
//           SizedBox(height: 16.0),
//           descriptionField(),
//           SizedBox(height: 16.0),
//           attachPhotosField(),
//           SizedBox(height: 16.0),
//           specifyImpact(),
//         ],
//       ),
//     );
//   }

//   // Material Request Section
//   Widget materialRequestSection() {
//     return expansionCard(
//       title: 'Material Request',
//       isExpanded: isMaterialRequestExpanded,
//       onExpansionChanged: (value) {
//         setState(() {
//           isMaterialRequestExpanded = value;
//         });
//       },
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           selectMaterials(),
//           SizedBox(height: 16.0),
//           quantityAndUrgency(),
//           SizedBox(height: 16.0),
//           commentsField(),
//         ],
//       ),
//     );
//   }

//   // Expansion Card Widget
//   Widget expansionCard({
//     required String title,
//     required bool isExpanded,
//     required Function(bool) onExpansionChanged,
//     required Widget child,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF121212), // Slightly lighter than background
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Theme(
//         data: ThemeData().copyWith(dividerColor: Colors.transparent),
//         child: ExpansionTile(
//           initiallyExpanded: isExpanded,
//           onExpansionChanged: onExpansionChanged,
//           title: Text(
//             title,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18.0,
//               fontWeight: FontWeight.w500, // Medium
//             ),
//           ),
//           backgroundColor: Color(0xFF121212),
//           collapsedBackgroundColor: Color(0xFF121212),
//           iconColor: Colors.white,
//           collapsedIconColor: Colors.white,
//           children: [
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: child,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Select Issue Type Widget
//   Widget selectIssueType() {
//     List<String> issueTypes = ['Delay', 'Safety Concern', 'Equipment Failure'];
//     return columnWithLabel(
//       label: 'Select Issue Type',
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12.0),
//         decoration: BoxDecoration(),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: issueType,
//             dropdownColor: Color(0xFF1E1E1E),
//             iconEnabledColor: Colors.white,
//             items: issueTypes.map((type) {
//               return DropdownMenuItem<String>(
//                 value: type,
//                 child: Row(
//                   children: [
//                     Icon(
//                       _getIssueTypeIcon(type),
//                       color: Colors.white,
//                     ),
//                     SizedBox(width: 8.0),
//                     Text(type, style: TextStyle(color: Colors.white)),
//                   ],
//                 ),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 issueType = value!;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getIssueTypeIcon(String type) {
//     switch (type) {
//       case 'Delay':
//         return Icons.access_time;
//       case 'Safety Concern':
//         return Icons.warning;
//       case 'Equipment Failure':
//         return Icons.build;
//       default:
//         return Icons.error;
//     }
//   }

//   // Description Field Widget
//   Widget descriptionField() {
//     return columnWithLabel(
//       label: 'Description',
//       child: TextFormField(
//         maxLines: 4,
//         maxLength: 500,
//         style: TextStyle(color: Colors.white),
//         decoration: inputDecoration(
//           hintText: 'Enter a detailed description...',
//         ),
//         onChanged: (value) {
//           setState(() {
//             description = value;
//           });
//         },
//       ),
//     );
//   }

//   // Attach Photos Field Widget
//   Widget attachPhotosField() {
//     return columnWithLabel(
//       label: 'Attach Photos/Documents OR Take Photos',
//       child: InkWell(
//         onTap: () {
//           // Handle file picker or camera
//         },
//         child: DottedBorder(
//           color: Color(0xFFF7D104), // Yellow
//           borderType: BorderType.RRect,
//           radius: Radius.circular(8.0),
//           dashPattern: [6, 3],
//           child: Container(
//             height: 100.0,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Color(0xFF1E1E1E),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Center(
//               child: Icon(
//                 Icons.add,
//                 color: Color(0xFFF7D104),
//                 size: 40.0,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Specify Impact Widget
//   Widget specifyImpact() {
//     List<String> impactLevels = ['Low', 'Medium', 'High'];
//     return columnWithLabel(
//       label: 'Specify Impact',
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12.0),
//         decoration: BoxDecoration(),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: impactLevel,
//             dropdownColor: Color(0xFF1E1E1E),
//             iconEnabledColor: Colors.white,
//             items: impactLevels.map((level) {
//               return DropdownMenuItem<String>(
//                 value: level,
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.circle,
//                       color: _getImpactColor(level),
//                     ),
//                     SizedBox(width: 8.0),
//                     Text(level, style: TextStyle(color: Colors.white)),
//                   ],
//                 ),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 impactLevel = value!;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getImpactColor(String level) {
//     switch (level) {
//       case 'Low':
//         return Colors.green;
//       case 'Medium':
//         return Colors.yellow;
//       case 'High':
//         return Colors.red;
//       default:
//         return Colors.white;
//     }
//   }

//   // Select Materials Widget
//   Widget selectMaterials() {
//     return columnWithLabel(
//       label: 'Select Materials',
//       child: Column(
//         children: [
//           TextFormField(
//             style: TextStyle(color: Colors.white),
//             decoration: inputDecoration(
//               hintText: 'Search or add materials...',
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.add, color: Color(0xFFF7D104)),
//                 onPressed: () {
//                   if (materialInput.isNotEmpty) {
//                     setState(() {
//                       materials.add(materialInput);
//                       materialInput = '';
//                     });
//                   }
//                 },
//               ),
//             ),
//             onChanged: (value) {
//               materialInput = value;
//             },
//             onFieldSubmitted: (value) {
//               if (value.isNotEmpty) {
//                 setState(() {
//                   materials.add(value);
//                   materialInput = '';
//                 });
//               }
//             },
//           ),
//           SizedBox(height: 8.0),
//           Wrap(
//             spacing: 8.0,
//             children: materials.map((material) {
//               return Chip(
//                 label: Text(material),
//                 backgroundColor: Color(0xFF1E1E1E),
//                 labelStyle: TextStyle(color: Colors.white),
//                 deleteIconColor: Color(0xFFF7D104),
//                 onDeleted: () {
//                   setState(() {
//                     materials.remove(material);
//                   });
//                 },
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   // Quantity and Urgency Widget
//   Widget quantityAndUrgency() {
//     return Row(
//       children: [
//         Expanded(
//           child: columnWithLabel(
//             label: 'Quantity',
//             child: Container(
//               decoration: BoxDecoration(),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.remove, color: Color(0xFFF7D104)),
//                     onPressed: () {
//                       setState(() {
//                         if (quantity > 1) quantity--;
//                       });
//                     },
//                   ),
//                   Expanded(
//                     child: Text(
//                       quantity.toString(),
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.white, fontSize: 16.0),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.add, color: Color(0xFFF7D104)),
//                     onPressed: () {
//                       setState(() {
//                         quantity++;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 16.0),
//         Expanded(
//           child: columnWithLabel(
//             label: 'Urgency',
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.0),
//               decoration: BoxDecoration(),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: urgency,
//                   dropdownColor: Color(0xFF1E1E1E),
//                   iconEnabledColor: Colors.white,
//                   items: ['Low', 'Medium', 'High'].map((level) {
//                     return DropdownMenuItem<String>(
//                       value: level,
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.circle,
//                             color: _getImpactColor(level),
//                           ),
//                           SizedBox(width: 8.0),
//                           Text(level, style: TextStyle(color: Colors.white)),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       urgency = value!;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Comments Field Widget
//   Widget commentsField() {
//     return columnWithLabel(
//       label: 'Comments (Optional)',
//       labelStyle: TextStyle(
//         color: Colors.grey,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w400,
//       ),
//       child: TextFormField(
//         maxLines: 2,
//         style: TextStyle(color: Colors.white),
//         decoration: inputDecoration(
//           hintText: 'Add any additional comments...',
//         ),
//         onChanged: (value) {
//           setState(() {
//             comments = value;
//           });
//         },
//       ),
//     );
//   }

//   // Submit Button Widget
//   Widget submitButton() {
//     return ElevatedButton(
//       onPressed: isFormValid ? _handleSubmit : null,
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Color(0xFF040404), backgroundColor: isFormValid ? Color(0xFFF7D104) : Colors.grey,
//         minimumSize: Size(double.infinity, 50.0),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//         elevation: isFormValid ? 4.0 : 0.0,
//       ),
//       child: Text(
//         'Submit',
//         style: TextStyle(
//           fontWeight: FontWeight.w600, // SemiBold
//           fontSize: 16.0,
//         ),
//       ),
//     );
//   }

//   void _handleSubmit() {
//     // Handle form submission
//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green),
//             SizedBox(width: 8.0),
//             Text('Report submitted successfully!'),
//           ],
//         ),
//         backgroundColor: Color(0xFF1E1E1E),
//       ),
//     );
//   }

//   // Helper Widgets
//   Widget columnWithLabel({
//     required String label,
//     required Widget child,
//     TextStyle? labelStyle,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: labelStyle ??
//               TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.w500,
//               ),
//         ),
//         SizedBox(height: 8.0),
//         child,
//       ],
//     );
//   }

//   InputDecoration inputDecoration({String? hintText, Widget? suffixIcon}) {
//     return InputDecoration(
//       hintText: hintText,
//       hintStyle: TextStyle(color: Colors.grey),
//       filled: true,
//       fillColor: Color(0xFF1E1E1E),
//       border: OutlineInputBorder(
//         borderSide: BorderSide.none,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
//       suffixIcon: suffixIcon,
//     );
//   }
// }

// modern_elevator_app/lib/screens/issue_reporting_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import '../widgets/base_scaffold.dart';
import '../services/api_service.dart';

class IssueReportingMaterialRequestScreen extends StatefulWidget {
  const IssueReportingMaterialRequestScreen({super.key});

  @override
  _IssueReportingMaterialRequestScreenState createState() =>
      _IssueReportingMaterialRequestScreenState();
}

class _IssueReportingMaterialRequestScreenState
    extends State<IssueReportingMaterialRequestScreen> {
  // Current tab index
  int _selectedTabIndex = 0;

  // Loading states
  bool _isLoading = false;
  bool _isProjectsLoading = true;
  bool _isElevatorsLoading = false;
  bool _isMaterialsLoading = false;

  // Lists for dropdowns
  List<dynamic> _projects = [];
  List<dynamic> _elevators = [];
  List<dynamic> _materials = [];
  List<dynamic> _filteredMaterials = [];

  // Selected values
  dynamic _selectedProject;
  dynamic _selectedElevator;

  // Issue form controllers
  final _issueTitleController = TextEditingController();
  final _issueDescriptionController = TextEditingController();
  String _selectedIssueType = 'MECHANICAL';
  String _selectedIssuePriority = 'MEDIUM';
  int? _delayMinutes;
  List<File> _selectedPhotos = [];

  // Material request form controllers
  final _materialSearchController = TextEditingController();
  final _materialNotesController = TextEditingController();
  String _selectedMaterialUrgency = 'MEDIUM';
  List<Map<String, dynamic>> _selectedMaterials = [];

  // Form keys for validation
  final _issueFormKey = GlobalKey<FormState>();
  final _materialFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProjects();
    _loadMaterials();
  }

  @override
  void dispose() {
    _issueTitleController.dispose();
    _issueDescriptionController.dispose();
    _materialSearchController.dispose();
    _materialNotesController.dispose();
    super.dispose();
  }

  // Load projects for the current user
  Future<void> _loadProjects() async {
  try {
    setState(() {
      _isProjectsLoading = true;
    });
    final projects = await ApiService.getProjects();
    if (!mounted) return; // Ensure the widget is still mounted
    setState(() {
      _projects = projects;
      _isProjectsLoading = false;
      // Auto-select first project if available
      if (_projects.isNotEmpty) {
        _selectedProject = _projects[0];
        _loadElevatorsForProject(_selectedProject['id']);
      }
    });
  } catch (e) {
    if (!mounted) return; // Ensure the widget is still mounted
    setState(() {
      _isProjectsLoading = false;
    });
    _showErrorSnackBar("Failed to load projects: $e");
  }
}
  // Future<void> _loadProjects() async {
  //   try {
  //     setState(() {
  //       _isProjectsLoading = true;
  //     });
  //     final projects = await ApiService.getProjects();
  //     setState(() {
  //       _projects = projects;
  //       _isProjectsLoading = false;
  //       // Auto-select first project if available
  //       if (_projects.isNotEmpty) {
  //         _selectedProject = _projects[0];
  //         _loadElevatorsForProject(_selectedProject['id']);
  //       }
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isProjectsLoading = false;
  //     });
  //     _showErrorSnackBar("Failed to load projects: $e");
  //   }
  // }

  // Load elevators for selected project
  Future<void> _loadElevatorsForProject(String projectId) async {
    try {
      setState(() {
        _isElevatorsLoading = true;
        _selectedElevator = null;
      });
      final elevators = await ApiService.getElevatorsForProject(projectId);
      setState(() {
        _elevators = elevators;
        _isElevatorsLoading = false;
        // Auto-select first elevator if available
        if (_elevators.isNotEmpty) {
          _selectedElevator = _elevators[0];
        }
      });
    } catch (e) {
      setState(() {
        _isElevatorsLoading = false;
      });
      _showErrorSnackBar("Failed to load elevators: $e");
    }
  }

  // Load available materials
  Future<void> _loadMaterials({String? search}) async {
  try {
    setState(() {
      _isMaterialsLoading = true;
    });
    final materials = await ApiService.getMaterials(search: search);
    if (!mounted) return; // Ensure the widget is still mounted
    setState(() {
      _materials = materials;
      _filteredMaterials = materials;
      _isMaterialsLoading = false;
    });
  } catch (e) {
    if (!mounted) return; // Ensure the widget is still mounted
    setState(() {
      _isMaterialsLoading = false;
    });
    _showErrorSnackBar("Failed to load materials: $e");
  }
}
  // Future<void> _loadMaterials({String? search}) async {
  //   try {
  //     setState(() {
  //       _isMaterialsLoading = true;
  //     });
  //     final materials = await ApiService.getMaterials(search: search);
  //     setState(() {
  //       _materials = materials;
  //       _filteredMaterials = materials;
  //       _isMaterialsLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isMaterialsLoading = false;
  //     });
  //     _showErrorSnackBar("Failed to load materials: $e");
  //   }
  // }

  // Search materials
  void _searchMaterials(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredMaterials = _materials;
      });
      return;
    }

    setState(() {
      _filteredMaterials = _materials.where((material) {
        final name = material['name'].toString().toLowerCase();
        final code = material['code']?.toString().toLowerCase() ?? '';
        final description = material['description']?.toString().toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) ||
            code.contains(searchLower) ||
            description.contains(searchLower);
      }).toList();
    });
  }

  // Add material to selection
  void _addMaterial(dynamic material) {
    // Check if material is already selected
    final existingIndex = _selectedMaterials.indexWhere(
        (m) => m['materialId'] == material['id']);
    
    if (existingIndex != -1) {
      // Increment quantity if already selected
      setState(() {
        _selectedMaterials[existingIndex]['quantity']++;
      });
    } else {
      // Add new material
      setState(() {
        _selectedMaterials.add({
          'materialId': material['id'],
          'name': material['name'],
          'code': material['code'] ?? '',
          'unit': material['unit'] ?? 'pcs',
          'quantity': 1,
          'notes': ''
        });
      });
    }
    
    // Clear search
    _materialSearchController.clear();
    setState(() {
      _filteredMaterials = _materials;
    });
  }

  // Remove material from selection
  void _removeMaterial(int index) {
    setState(() {
      _selectedMaterials.removeAt(index);
    });
  }

  // Update material quantity
  void _updateMaterialQuantity(int index, int change) {
    final newQuantity = (_selectedMaterials[index]['quantity'] + change);
    if (newQuantity > 0) {
      setState(() {
        _selectedMaterials[index]['quantity'] = newQuantity;
      });
    }
  }

  // Pick images from gallery or camera
  Future<void> _pickImages(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      
      if (source == ImageSource.gallery) {
        final List<XFile> images = await picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _selectedPhotos.addAll(images.map((image) => File(image.path)).toList());
          });
        }
      } else {
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          setState(() {
            _selectedPhotos.add(File(photo.path));
          });
        }
      }
    } catch (e) {
      _showErrorSnackBar("Failed to pick images: $e");
    }
  }

  // Remove photo
  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  // Handle issue submission
  Future<void> _submitIssue() async {
    if (!_issueFormKey.currentState!.validate()) return;
    
    if (_selectedProject == null || _selectedElevator == null) {
      _showErrorSnackBar("Please select a project and elevator");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.reportIssue(
        type: _selectedIssueType,
        title: _issueTitleController.text,
        description: _issueDescriptionController.text,
        projectId: _selectedProject['id'],
        elevatorId: _selectedElevator['id'],
        priority: _selectedIssuePriority,
        delayMinutes: _delayMinutes,
        photos: _selectedPhotos.map((file) => file.path).toList(),
      );

      setState(() {
        _isLoading = false;
      });

      _showSuccessDialog("Issue reported successfully!");
      _resetIssueForm();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar("Failed to submit issue: $e");
    }
  }

  // Handle material request submission
  Future<void> _submitMaterialRequest() async {
    if (!_materialFormKey.currentState!.validate()) return;
    
    if (_selectedProject == null || _selectedElevator == null) {
      _showErrorSnackBar("Please select a project and elevator");
      return;
    }

    if (_selectedMaterials.isEmpty) {
      _showErrorSnackBar("Please add at least one material");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.requestMaterials(
        projectId: _selectedProject['id'],
        elevatorId: _selectedElevator['id'],
        urgency: _selectedMaterialUrgency,
        notes: _materialNotesController.text,
        items: _selectedMaterials.map((material) => {
          'materialId': material['materialId'],
          'quantity': material['quantity'],
          'notes': material['notes'],
        }).toList(),
      );

      setState(() {
        _isLoading = false;
      });

      _showSuccessDialog("Material request submitted successfully!");
      _resetMaterialForm();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar("Failed to submit material request: $e");
    }
  }

  // Reset issue form
  void _resetIssueForm() {
    setState(() {
      _issueTitleController.clear();
      _issueDescriptionController.clear();
      _selectedIssueType = 'MECHANICAL';
      _selectedIssuePriority = 'MEDIUM';
      _delayMinutes = null;
      _selectedPhotos = [];
    });
  }

  // Reset material request form
  void _resetMaterialForm() {
    setState(() {
      _materialSearchController.clear();
      _materialNotesController.clear();
      _selectedMaterialUrgency = 'MEDIUM';
      _selectedMaterials = [];
    });
  }

  // Show success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF121212),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Success', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: Text('OK', style: TextStyle(color: Color(0xFFF7D104))),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Issue & Material Request',
      currentIndex: 1,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          // Tab selection at the top
          _buildTabSelector(),
          
          // Project and elevator selector (common for both tabs)
          _buildProjectElevatorSelector(),
          
          // Main content area depends on selected tab
          Expanded(
            child: _isLoading 
                ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
                : _selectedTabIndex == 0 
                    ? _buildIssueReportingTab() 
                    : _buildMaterialRequestTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      color: Color(0xFF0A0A0A),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              title: 'Report Issue',
              icon: Icons.warning_amber_rounded,
              isSelected: _selectedTabIndex == 0,
              onTap: () => setState(() => _selectedTabIndex = 0),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildTabButton(
              title: 'Request Materials',
              icon: Icons.inventory,
              isSelected: _selectedTabIndex == 1,
              onTap: () => setState(() => _selectedTabIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF121212) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Color(0xFFF7D104) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xFFF7D104) : Colors.white54,
              size: 24,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectElevatorSelector() {
    return Container(
      color: Color(0xFF121212),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              // Project selector
              Expanded(
                child: _isProjectsLoading
                    ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
                    : _buildDropdownField(
                        label: 'Project',
                        hintText: 'Select Project',
                        value: _selectedProject,
                        items: _projects.map((project) => DropdownMenuItem(
                          value: project,
                          child: Text(
                            project['name'] ?? 'Unknown Project',
                            style: TextStyle(color: Colors.white),
                          ),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedProject = value;
                          });
                          if (value != null) {
                            _loadElevatorsForProject((value as Map<String, dynamic>)['id']);
                          }
                        },
                      ),
              ),
              SizedBox(width: 16),
              // Elevator selector
              Expanded(
                child: _isElevatorsLoading
                    ? Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
                    : _buildDropdownField(
                        label: 'Elevator',
                        hintText: 'Select Elevator',
                        value: _selectedElevator,
                        items: _elevators.map((elevator) => DropdownMenuItem(
                          value: elevator,
                          child: Text(
                            elevator['elevatorNumber'] ?? 'Unknown Elevator',
                            style: TextStyle(color: Colors.white),
                          ),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedElevator = value;
                          });
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ISSUE REPORTING TAB
  Widget _buildIssueReportingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _issueFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Issue details section
            _buildSectionTitle('Issue Details'),
            SizedBox(height: 16),
            
            // Issue type dropdown
            _buildDropdownField(
              label: 'Issue Type',
              hintText: 'Select Issue Type',
              value: _selectedIssueType,
              items: [
                // New values
                DropdownMenuItem(
                  value: 'MECHANICAL',
                  child: _buildDropdownItem(
                    icon: Icons.build, 
                    text: 'Mechanical',
                    color: Colors.orange,
                  ),
                ),
                DropdownMenuItem(
                  value: 'ELECTRICAL',
                  child: _buildDropdownItem(
                    icon: Icons.electric_bolt, 
                    text: 'Electrical',
                    color: Colors.blue,
                  ),
                ),
                DropdownMenuItem(
                  value: 'HYDRAULIC',
                  child: _buildDropdownItem(
                    icon: Icons.water_drop, 
                    text: 'Hydraulic',
                    color: Colors.lightBlue,
                  ),
                ),
                DropdownMenuItem(
                  value: 'SAFETY',
                  child: _buildDropdownItem(
                    icon: Icons.health_and_safety, 
                    text: 'Safety',
                    color: Colors.red,
                  ),
                ),
                DropdownMenuItem(
                  value: 'GENERAL',
                  child: _buildDropdownItem(
                    icon: Icons.info, 
                    text: 'General',
                    color: Colors.green,
                  ),
                ),
                // Original values with matching uppercase style
                DropdownMenuItem(
                  value: 'DELAY',
                  child: _buildDropdownItem(
                    icon: Icons.timer, 
                    text: 'Delay',
                    color: Colors.amber,
                  ),
                ),
                DropdownMenuItem(
                  value: 'PRODUCT_ISSUE',
                  child: _buildDropdownItem(
                    icon: Icons.warning, 
                    text: 'Product Issue',
                    color: Colors.purple,
                  ),
                ),
                DropdownMenuItem(
                  value: 'SAFETY_CONCERN',
                  child: _buildDropdownItem(
                    icon: Icons.security, 
                    text: 'Safety Concern',
                    color: Colors.deepOrange,
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedIssueType = value.toString();
                });
              },
            ),
            SizedBox(height: 16),
            // _buildDropdownField(
            //   label: 'Issue Type',
            //   hintText: 'Select Issue Type',
            //   value: _selectedIssueType,
            //   items: [
            //     DropdownMenuItem(
            //       value: 'MECHANICAL',
            //       child: _buildDropdownItem(
            //         icon: Icons.build, 
            //         text: 'Mechanical',
            //         color: Colors.orange,
            //       ),
            //     ),
            //     DropdownMenuItem(
            //       value: 'ELECTRICAL',
            //       child: _buildDropdownItem(
            //         icon: Icons.electric_bolt, 
            //         text: 'Electrical',
            //         color: Colors.blue,
            //       ),
            //     ),
            //     DropdownMenuItem(
            //       value: 'HYDRAULIC',
            //       child: _buildDropdownItem(
            //         icon: Icons.water_drop, 
            //         text: 'Hydraulic',
            //         color: Colors.lightBlue,
            //       ),
            //     ),
            //     DropdownMenuItem(
            //       value: 'SAFETY',
            //       child: _buildDropdownItem(
            //         icon: Icons.health_and_safety, 
            //         text: 'Safety',
            //         color: Colors.red,
            //       ),
            //     ),
            //     DropdownMenuItem(
            //       value: 'GENERAL',
            //       child: _buildDropdownItem(
            //         icon: Icons.info, 
            //         text: 'General',
            //         color: Colors.green,
            //       ),
            //     ),
            //   ],
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedIssueType = value.toString();
            //     });
            //   },
            // ),
            // SizedBox(height: 16),
            
            // Issue title
            _buildTextField(
              controller: _issueTitleController,
              label: 'Issue Title',
              hintText: 'Enter a short title for the issue',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an issue title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            // Issue description
            _buildTextField(
              controller: _issueDescriptionController,
              label: 'Description',
              hintText: 'Provide detailed description of the issue',
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            // Issue priority
            _buildDropdownField(
              label: 'Priority',
              hintText: 'Select Priority',
              value: _selectedIssuePriority,
              items: [
                DropdownMenuItem(
                  value: 'LOW',
                  child: _buildDropdownItem(
                    icon: Icons.arrow_downward, 
                    text: 'Low',
                    color: Colors.green,
                  ),
                ),
                DropdownMenuItem(
                  value: 'MEDIUM',
                  child: _buildDropdownItem(
                    icon: Icons.remove, 
                    text: 'Medium',
                    color: Colors.orange,
                  ),
                ),
                DropdownMenuItem(
                  value: 'HIGH',
                  child: _buildDropdownItem(
                    icon: Icons.arrow_upward, 
                    text: 'High',
                    color: Colors.red,
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedIssuePriority = value.toString();
                });
              },
            ),
            SizedBox(height: 16),
            
            // Delay minutes (optional)
            _buildTextField(
              label: 'Delay Minutes (optional)',
              hintText: 'Enter delay in minutes if applicable',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _delayMinutes = int.tryParse(value);
                });
              },
            ),
            SizedBox(height: 24),
            
            // Photo attachments section
            _buildSectionTitle('Attach Photos'),
            SizedBox(height: 16),
            
            // Photo grid
            _buildPhotoGrid(),
            SizedBox(height: 24),
            
            // Submit button
            _buildSubmitButton(
              text: 'Submit Issue Report',
              onPressed: _submitIssue,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // MATERIAL REQUEST TAB
  Widget _buildMaterialRequestTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _materialFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Materials section
            _buildSectionTitle('Select Materials'),
            SizedBox(height: 16),
            
            // Material search field
            TextField(
              controller: _materialSearchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1E1E1E),
                hintText: 'Search or enter material name',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              onChanged: _searchMaterials,
            ),
            SizedBox(height: 16),
            
            // Material search results
            if (_isMaterialsLoading)
              Center(child: CircularProgressIndicator(color: Color(0xFFF7D104)))
            else if (_filteredMaterials.isNotEmpty && _materialSearchController.text.isNotEmpty)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _filteredMaterials.length > 5 ? 5 : _filteredMaterials.length,
                  itemBuilder: (context, index) {
                    final material = _filteredMaterials[index];
                    return ListTile(
                      title: Text(
                        material['name'] ?? 'Unknown Material',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        material['code'] ?? 'No Code',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add_circle, color: Color(0xFFF7D104)),
                        onPressed: () => _addMaterial(material),
                      ),
                      onTap: () => _addMaterial(material),
                    );
                  },
                ),
              ),
            SizedBox(height: 24),
            
            // Selected materials
            _buildSectionTitle('Selected Materials'),
            SizedBox(height: 16),
            
            if (_selectedMaterials.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, 
                         color: Colors.grey, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'No materials selected yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Search and select materials above',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _selectedMaterials.length,
                itemBuilder: (context, index) {
                  final material = _selectedMaterials[index];
                  return Card(
                    color: Color(0xFF1E1E1E),
                    margin: EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      material['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (material['code'] != null && material['code'].isNotEmpty)
                                      Text(
                                        'Code: ${material['code']}',
                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeMaterial(index),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('Quantity:', style: TextStyle(color: Colors.white70)),
                              SizedBox(width: 8),
                              IconButton(
                                iconSize: 20,
                                icon: Icon(Icons.remove_circle, color: Color(0xFFF7D104)),
                                onPressed: () => _updateMaterialQuantity(index, -1),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${material['quantity']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                iconSize: 20,
                                icon: Icon(Icons.add_circle, color: Color(0xFFF7D104)),
                                onPressed: () => _updateMaterialQuantity(index, 1),
                              ),
                              SizedBox(width: 8),
                              Text(
                                material['unit'] ?? 'pcs',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Add notes for this material (optional)',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Colors.grey.shade800),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Colors.grey.shade800),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Color(0xFFF7D104)),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                material['notes'] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            SizedBox(height: 24),
            
            // Request details
            _buildSectionTitle('Request Details'),
            SizedBox(height: 16),
            
            // Urgency dropdown
            _buildDropdownField(
              label: 'Urgency',
              hintText: 'Select Urgency',
              value: _selectedMaterialUrgency,
              items: [
                DropdownMenuItem(
                  value: 'LOW',
                  child: _buildDropdownItem(
                    icon: Icons.arrow_downward, 
                    text: 'Low',
                    color: Colors.green,
                  ),
                ),
                DropdownMenuItem(
                  value: 'MEDIUM',
                  child: _buildDropdownItem(
                    icon: Icons.remove, 
                    text: 'Medium',
                    color: Colors.orange,
                  ),
                ),
                DropdownMenuItem(
                  value: 'HIGH',
                  child: _buildDropdownItem(
                    icon: Icons.arrow_upward, 
                    text: 'High',
                    color: Colors.red,
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMaterialUrgency = value.toString();
                });
              },
            ),
            SizedBox(height: 16),
            
            // Notes
            _buildTextField(
              controller: _materialNotesController,
              label: 'Additional Notes (optional)',
              hintText: 'Add any additional information',
              maxLines: 3,
            ),
            SizedBox(height: 24),
            
            // Submit button
            _buildSubmitButton(
              text: 'Submit Material Request',
              onPressed: _submitMaterialRequest,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // HELPER WIDGETS
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required String label,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF1E1E1E),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required String hintText,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<T>(
              value: value,
              hint: Text(hintText, style: TextStyle(color: Colors.grey)),
              dropdownColor: Color(0xFF1E1E1E),
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildPhotoGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photo picker buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text('Gallery'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Color(0xFFF7D104),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _pickImages(ImageSource.gallery),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text('Camera'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Color(0xFFF7D104),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _pickImages(ImageSource.camera),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        
        // Selected photos grid
        if (_selectedPhotos.isEmpty)
          DottedBorder(
            color: Color(0xFFF7D104),
            borderType: BorderType.RRect,
            radius: Radius.circular(8),
            dashPattern: [6, 3],
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    color: Color(0xFFF7D104),
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No photos selected',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _selectedPhotos.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(_selectedPhotos[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(179),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildSubmitButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Color(0xFFF7D104),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}