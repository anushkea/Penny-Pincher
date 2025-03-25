// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class CategorySummary extends StatefulWidget {
//   final Map<String, double> categoryExpenses;
//   final Map<String, double> categoryIncome;
//   final bool isDarkMode;

//   const CategorySummary({
//     Key? key,
//     required this.categoryExpenses,
//     required this.categoryIncome,
//     required this.isDarkMode, required Future<void> Function() onDownloadPdf,
//   }) : super(key: key);

//   @override
//   _CategorySummaryState createState() => _CategorySummaryState();
// }

// class _CategorySummaryState extends State<CategorySummary> {
//   String _viewType = 'Expenses';
//   String _timeFilter = 'This Month';
//   Map<String, double> _filteredCategories = {};
//   double _total = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _updateFilteredData();
//   }

//   @override
//   void didUpdateWidget(CategorySummary oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _updateFilteredData();
//   }

//   void _updateFilteredData() {
//     setState(() {
//       if (_viewType == 'Expenses') {
//         _filteredCategories = Map.from(widget.categoryExpenses);
//         _total = widget.categoryExpenses.values.fold(0, (prev, amount) => prev + amount);
//       } else {
//         _filteredCategories = Map.from(widget.categoryIncome);
//         _total = widget.categoryIncome.values.fold(0, (prev, amount) => prev + amount);
//       }
//     });
//   }

//   Future<void> _downloadPdf() async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               pw.Text('Category Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 20),
//               pw.Table.fromTextArray(
//                 data: _buildPdfData(),
//                 headers: ['Category', 'Amount'],
//                 cellAlignment: pw.Alignment.centerRight,
//                 headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text('Total: ₹${_total.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             ],
//           );
//         },
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
//   }

//   List<List<String>> _buildPdfData() {
//     List<List<String>> data = [];
//     _filteredCategories.forEach((category, amount) {
//       data.add([category, '₹${amount.toStringAsFixed(2)}']);
//     });
//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Color(0xFF1E2736),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 8,
//       child: Padding(
//         padding: EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
          
//           children: [
//                             SizedBox(height: 30),
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 18,
//                   backgroundColor: Colors.purple,
//                   child: Icon(Icons.pie_chart, color: Colors.white, size: 18),
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   "Category Summary",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Spacer(),
//                 IconButton(
//                   icon: Icon(Icons.download, color: Colors.white, size: 18),
//                   onPressed: _downloadPdf,
//                   tooltip: 'Download PDF',
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildToggleButton(
//                     title: 'Expenses',
//                     icon: Icons.trending_down,
//                     color: Colors.red,
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildToggleButton(
//                     title: 'Income',
//                     icon: Icons.trending_up,
//                     color: Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                 color: Color(0xFF2A3547),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: DropdownButton<String>(
//                 value: _timeFilter,
//                 dropdownColor: Color(0xFF2A3547),
//                 style: TextStyle(color: Colors.white),
//                 isExpanded: true,
//                 underline: SizedBox(),
//                 icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
//                 items: [
//                   'This Month',
//                   'Last Month',
//                   'This Year',
//                   'All Time',
//                 ].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _timeFilter = value!;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'Category',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     'Amount',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                     textAlign: TextAlign.right,
//                   ),
//                 ),
//               ],
//             ),
//             Divider(color: Colors.white24),
//             if (_filteredCategories.isEmpty)
//               Container(
//                 height: 80,
//                 alignment: Alignment.center,
//                 child: Text(
//                   "No ${_viewType.toLowerCase()} found for this period",
//                   style: TextStyle(color: Colors.white70, fontSize: 14),
//                 ),
//               )
//             else
//               Container(
//                 height: 180,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: _filteredCategories.length,
//                   itemBuilder: (context, index) {
//                     final entry = _filteredCategories.entries.elementAt(index);
//                     return Padding(
//                       padding: EdgeInsets.symmetric(vertical: 6),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               entry.key,
//                               style: TextStyle(color: Colors.white, fontSize: 14),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               '₹${entry.value.toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 color: _viewType == 'Expenses' ? Colors.red : Colors.green,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                               textAlign: TextAlign.right,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             Divider(color: Colors.white24),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'Total',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     '₹${_total.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: _viewType == 'Expenses' ? Colors.red : Colors.green,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                     textAlign: TextAlign.right,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildToggleButton({
//     required String title,
//     required IconData icon,
//     required Color color,
//   }) {
//     bool isSelected = _viewType == title;
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isSelected ? color : Color(0xFF2A3547),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(0),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 10),
//       ),
//       onPressed: () {
//         setState(() {
//           _viewType = title;
//           _updateFilteredData();
//         });
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 14),
//           SizedBox(width: 6),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class CategorySummary extends StatefulWidget {
//   final Map<String, double> categoryExpenses;
//   final Map<String, double> categoryIncome;
//   final bool isDarkMode;

//   const CategorySummary({
//     Key? key,
//     required this.categoryExpenses,
//     required this.categoryIncome,
//     required this.isDarkMode,
//     required Future<void> Function() onDownloadPdf,
//   }) : super(key: key);

//   @override
//   _CategorySummaryState createState() => _CategorySummaryState();
// }

// class _CategorySummaryState extends State<CategorySummary> {
//   String _viewType = 'Expenses';
//   String _timeFilter = 'This Month';
//   Map<String, double> _filteredCategories = {};
//   double _total = 0.0;
  
//   // Spotify-themed colors
//   static const Color spotifyBackground = Color(0xFF121212);
//   static const Color spotifyCardBackground = Color(0xFF181818);
//   static const Color spotifyItemBackground = Color(0xFF282828);
//   static const Color spotifyGreen = Color(0xFF1DB954);
//   static const Color spotifySecondary = Color(0xFFB3B3B3);
//   static const Color spotifyError = Color(0xFFE35252);

//   @override
//   void initState() {
//     super.initState();
//     _updateFilteredData();
//   }

//   @override
//   void didUpdateWidget(CategorySummary oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _updateFilteredData();
//   }

//   void _updateFilteredData() {
//     setState(() {
//       if (_viewType == 'Expenses') {
//         _filteredCategories = Map.from(widget.categoryExpenses);
//         _total = widget.categoryExpenses.values.fold(0, (prev, amount) => prev + amount);
//       } else {
//         _filteredCategories = Map.from(widget.categoryIncome);
//         _total = widget.categoryIncome.values.fold(0, (prev, amount) => prev + amount);
//       }
//     });
//   }

//   Future<void> _downloadPdf() async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               pw.Text('Category Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 20),
//               pw.Table.fromTextArray(
//                 data: _buildPdfData(),
//                 headers: ['Category', 'Amount'],
//                 cellAlignment: pw.Alignment.centerRight,
//                 headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text('Total: ₹${_total.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             ],
//           );
//         },
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
//   }

//   List<List<String>> _buildPdfData() {
//     List<List<String>> data = [];
//     _filteredCategories.forEach((category, amount) {
//       data.add([category, '₹${amount.toStringAsFixed(2)}']);
//     });
//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFF212121), spotifyBackground],
//           stops: [0.0, 0.3],
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: spotifyGreen.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     Icons.pie_chart,
//                     color: spotifyGreen,
//                     size: 22,
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   "Category Summary",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 Spacer(),
//                 IconButton(
//                   icon: Icon(Icons.download, color: spotifySecondary),
//                   onPressed: _downloadPdf,
//                   tooltip: 'Download PDF',
//                   splashRadius: 22,
//                 ),
//               ],
//             ),
//             SizedBox(height: 24),
//             _buildToggleBar(),
//             SizedBox(height: 16),
//             _buildTimeFilterDropdown(),
//             SizedBox(height: 24),
//             _buildCategoryHeader(),
//             Divider(color: Colors.white10, thickness: 1, height: 1),
//             SizedBox(height: 8),
//             _buildCategoryList(),
//             SizedBox(height: 8),
//             Divider(color: Colors.white10, thickness: 1, height: 1),
//             SizedBox(height: 12),
//             _buildTotalRow(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildToggleBar() {
//     return Container(
//       height: 40,
//       decoration: BoxDecoration(
//         color: spotifyItemBackground,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildToggleButton(
//               title: 'Expenses',
//               icon: Icons.trending_down,
//               color: spotifyError,
//             ),
//           ),
//           Expanded(
//             child: _buildToggleButton(
//               title: 'Income',
//               icon: Icons.trending_up,
//               color: spotifyGreen,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildToggleButton({
//     required String title,
//     required IconData icon,
//     required Color color,
//   }) {
//     bool isSelected = _viewType == title;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _viewType = title;
//           _updateFilteredData();
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 16,
//               color: isSelected ? color : spotifySecondary,
//             ),
//             SizedBox(width: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 color: isSelected ? color : spotifySecondary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// Widget _buildTimeFilterDropdown() {
//   return Material(
//     color: Colors.transparent,
//     child: Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: spotifyItemBackground,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: _timeFilter,
//           dropdownColor: spotifyItemBackground,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//           isExpanded: true,
//           icon: Icon(Icons.keyboard_arrow_down, color: spotifySecondary, size: 18),
//           items: [
//             'This Month',
//             'Last Month',
//             'This Year',
//             'All Time',
//           ].map((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               _timeFilter = value!;
//             });
//           },
//         ),
//       ),
//     ),
//   );
// }

//   Widget _buildCategoryHeader() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               'Category',
//               style: TextStyle(
//                 color: spotifySecondary,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               'Amount',
//               style: TextStyle(
//                 color: spotifySecondary,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: 0.5,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryList() {
//     if (_filteredCategories.isEmpty) {
//       return Container(
//         height: 180,
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               _viewType == 'Expenses' ? Icons.receipt_long : Icons.account_balance_wallet,
//               color: spotifySecondary.withOpacity(0.5),
//               size: 36,
//             ),
//             SizedBox(height: 16),
//             Text(
//               "No ${_viewType.toLowerCase()} found for this period",
//               style: TextStyle(
//                 color: spotifySecondary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Container(
//       height: 180,
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: _filteredCategories.length,
//         itemBuilder: (context, index) {
//           final entry = _filteredCategories.entries.elementAt(index);
//           final Color valueColor = _viewType == 'Expenses' ? spotifyError : spotifyGreen;
          
//           return Container(
//             margin: EdgeInsets.symmetric(vertical: 4),
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//             decoration: BoxDecoration(
//               color: spotifyItemBackground.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     entry.key,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     '₹${entry.value.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: valueColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                     textAlign: TextAlign.right,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTotalRow() {
//     final Color totalColor = _viewType == 'Expenses' ? spotifyError : spotifyGreen;
    
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//       decoration: BoxDecoration(
//         color: spotifyItemBackground,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               'Total',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               '₹${_total.toStringAsFixed(2)}',
//               style: TextStyle(
//                 color: totalColor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class CategorySummary extends StatefulWidget {
//   final Map<String, double> categoryExpenses;
//   final Map<String, double> categoryIncome;
//   final bool isDarkMode;

//   const CategorySummary({
//     Key? key,
//     required this.categoryExpenses,
//     required this.categoryIncome,
//     required this.isDarkMode,
//     required Future<void> Function() onDownloadPdf,
//   }) : super(key: key);

//   @override
//   _CategorySummaryState createState() => _CategorySummaryState();
// }

// class _CategorySummaryState extends State<CategorySummary> {
//   String _viewType = 'Expenses';
//   String _timeFilter = 'This Month';
//   Map<String, double> _filteredCategories = {};
//   double _total = 0.0;

//   // Enhanced Spotify-themed colors
//   static const Color spotifyBackground = Color(0xFF121212);
//   static const Color spotifyCardBackground = Color(0xFF181818);
//   static const Color spotifyItemBackground = Color(0xFF282828);
//   static const Color spotifyGreen = Color(0xFF1DB954);
//   static const Color spotifyLightGreen = Color(0xFF1ED760);
//   static const Color spotifySecondary = Color(0xFFB3B3B3);
//   static const Color spotifyError = Color(0xFFE35252);

//   @override
//   void initState() {
//     super.initState();
//     _updateFilteredData();
//   }

//   @override
//   void didUpdateWidget(CategorySummary oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _updateFilteredData();
//   }

//   void _updateFilteredData() {
//     setState(() {
//       if (_viewType == 'Expenses') {
//         _filteredCategories = Map.from(widget.categoryExpenses);
//         _total = widget.categoryExpenses.values.fold(0, (prev, amount) => prev + amount);
//       } else {
//         _filteredCategories = Map.from(widget.categoryIncome);
//         _total = widget.categoryIncome.values.fold(0, (prev, amount) => prev + amount);
//       }
//     });
//   }

//   Future<void> _downloadPdf() async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               pw.Text('Category Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 20),
//               pw.Table.fromTextArray(
//                 data: _buildPdfData(),
//                 headers: ['Category', 'Amount'],
//                 cellAlignment: pw.Alignment.centerRight,
//                 headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text('Total: ₹${_total.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             ],
//           );
//         },
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
//   }

//   List<List<String>> _buildPdfData() {
//     List<List<String>> data = [];
//     _filteredCategories.forEach((category, amount) {
//       data.add([category, '₹${amount.toStringAsFixed(2)}']);
//     });
//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF1E1E1E),
//             spotifyBackground,
//             Color(0xFF0A0A0A),
//           ],
//           stops: [0.0, 0.5, 1.0],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 8), // Added spacing for the title to move down
//             Row(
//               children: [
//                 Container(
//                   width: 46,
//                   height: 46,
//                   decoration: BoxDecoration(
//                     color: spotifyGreen.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.pie_chart,
//                     color: spotifyLightGreen,
//                     size: 24,
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Text(
//                   "Category Summary",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 26, // Increased title size
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 Spacer(),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: spotifyItemBackground.withOpacity(0.6),
//                     borderRadius: BorderRadius.circular(22),
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.download_rounded, color: spotifyLightGreen, size: 22),
//                     onPressed: _downloadPdf,
//                     tooltip: 'Download PDF',
//                     splashRadius: 22,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 32), // Increased spacing
//             _buildToggleBar(),
//             SizedBox(height: 20),
//             _buildTimeFilterDropdown(),
//             SizedBox(height: 28), // Increased spacing
//             _buildCategoryHeader(),
//             Divider(color: Colors.white12, thickness: 1, height: 1),
//             SizedBox(height: 12),
//             _buildCategoryList(),
//             SizedBox(height: 12),
//             Divider(color: Colors.white12, thickness: 1, height: 1),
//             SizedBox(height: 16),
//             _buildTotalRow(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildToggleBar() {
//     return Container(
//       height: 46, // Increased height
//       decoration: BoxDecoration(
//         color: spotifyItemBackground.withOpacity(0.7),
//         borderRadius: BorderRadius.circular(23),
//         border: Border.all(color: Colors.white10, width: 1),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildToggleButton(
//               title: 'Expenses',
//               icon: Icons.trending_down,
//               color: spotifyError,
//             ),
//           ),
//           Expanded(
//             child: _buildToggleButton(
//               title: 'Income',
//               icon: Icons.trending_up,
//               color: spotifyLightGreen,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildToggleButton({
//     required String title,
//     required IconData icon,
//     required Color color,
//   }) {
//     bool isSelected = _viewType == title;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _viewType = title;
//           _updateFilteredData();
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
//           borderRadius: BorderRadius.circular(23),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 18,
//               color: isSelected ? color : spotifySecondary,
//             ),
//             SizedBox(width: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 15, // Increased font size
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 color: isSelected ? color : spotifySecondary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeFilterDropdown() {
//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         height: 48, // Increased height
//         decoration: BoxDecoration(
//           color: spotifyItemBackground.withOpacity(0.7),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.white10, width: 1),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: _timeFilter,
//             dropdownColor: Color(0xFF333333),
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//             ),
//             isExpanded: true,
//             icon: Icon(Icons.keyboard_arrow_down, color: spotifyGreen, size: 20),
//             items: [
//               'This Month',
//               'Last Month',
//               'This Year',
//               'All Time',
//             ].map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _timeFilter = value!;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryHeader() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               'Category',
//               style: TextStyle(
//                 color: spotifySecondary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               'Amount',
//               style: TextStyle(
//                 color: spotifySecondary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.5,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryList() {
//     if (_filteredCategories.isEmpty) {
//       return Container(
//         height: 180,
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               _viewType == 'Expenses' ? Icons.receipt_long : Icons.account_balance_wallet,
//               color: spotifySecondary.withOpacity(0.5),
//               size: 40, // Increased icon size
//             ),
//             SizedBox(height: 16),
//             Text(
//               "No ${_viewType.toLowerCase()} found for this period",
//               style: TextStyle(
//                 color: spotifySecondary,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Container(
//       height: 180,
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: _filteredCategories.length,
//         itemBuilder: (context, index) {
//           final entry = _filteredCategories.entries.elementAt(index);
//           final Color valueColor = _viewType == 'Expenses' ? spotifyError : spotifyLightGreen;

//           return Container(
//             margin: EdgeInsets.symmetric(vertical: 5),
//             padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//             decoration: BoxDecoration(
//               color: spotifyItemBackground.withOpacity(0.6),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.white10, width: 0.5),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     entry.key,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Text(
//                     '₹${entry.value.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: valueColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                     textAlign: TextAlign.right,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTotalRow() {
//     final Color totalColor = _viewType == 'Expenses' ? spotifyError : spotifyLightGreen;

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: spotifyItemBackground.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: totalColor.withOpacity(0.3), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: totalColor.withOpacity(0.1),
//             blurRadius: 8,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               'Total',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               '₹${_total.toStringAsFixed(2)}',
//               style: TextStyle(
//                 color: totalColor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 17,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }