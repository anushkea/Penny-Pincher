// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class TransactionItem {
//   final double amount;
//   final String type;
//   final String category;
//   final String? description;
//   final DateTime date;

//   TransactionItem({
//     required this.amount,
//     required this.type,
//     required this.category,
//     this.description,
//     required this.date,
//   });
// }

// class TransactionsList extends StatefulWidget {
//   final List<TransactionItem> transactions;
//   final bool isDarkMode;

//   const TransactionsList({
//     Key? key,
//     required this.transactions,
//     required this.isDarkMode, required Future<void> Function() onDownloadPdf,
//   }) : super(key: key);

//   @override
//   _TransactionsListState createState() => _TransactionsListState();
// }

// class _TransactionsListState extends State<TransactionsList> {
//   String _filterType = 'All';
//   List<TransactionItem> _filteredTransactions = [];

//   @override
//   void initState() {
//     super.initState();
//     _updateFilteredTransactions();
//   }

//   @override
//   void didUpdateWidget(TransactionsList oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _updateFilteredTransactions();
//   }

//   void _updateFilteredTransactions() {
//     setState(() {
//       if (_filterType == 'All') {
//         _filteredTransactions = List.from(widget.transactions);
//       } else {
//         _filteredTransactions = widget.transactions
//             .where((t) => t.type == (_filterType == 'Income' ? 'income' : 'expense'))
//             .toList();
//       }
//       _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
//     });
//   }

//   Future<void> _downloadPdf() async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               pw.Text('Transactions', style: pw.TextStyle(fontSize: 24)),
//               pw.SizedBox(height: 20),
//               ..._filteredTransactions.map((transaction) {
//                 return pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Text(transaction.category),
//                     pw.Text(
//                       '${transaction.type == 'income' ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
//                     ),
//                     pw.Text(DateFormat('dd/MM/yyyy').format(transaction.date)),
//                   ],
//                 );
//               }).toList(),
//             ],
//           );
//         },
//       ),
//     );
//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Color(0xFF1E2736),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 8,
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Colors.blue,
//                   child: Icon(Icons.list_alt, color: Colors.white),
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   "Transactions",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Spacer(),
//                 IconButton(
//                   icon: Icon(Icons.download, color: Colors.white),
//                   onPressed: _downloadPdf,
//                   tooltip: 'Download PDF',
//                 ),
//               ],
//             ),
//             SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildFilterButton('All'),
//                 SizedBox(width: 8),
//                 _buildFilterButton('Income'),
//                 SizedBox(width: 8),
//                 _buildFilterButton('Expenses'),
//               ],
//             ),
//             SizedBox(height: 15),
//             if (_filteredTransactions.isEmpty)
//               Container(
//                 height: 100,
//                 alignment: Alignment.center,
//                 child: Text(
//                   "No transactions found",
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//               )
//             else
//               Container(
//                 constraints: BoxConstraints(maxHeight: 300),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: _filteredTransactions.length,
//                   itemBuilder: (context, index) {
//                     final transaction = _filteredTransactions[index];
//                     return Card(
//                       color: Color(0xFF2A3547),
//                       margin: EdgeInsets.symmetric(vertical: 5),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: transaction.type == 'income'
//                               ? Colors.green.withOpacity(0.2)
//                               : Colors.red.withOpacity(0.2),
//                           child: Icon(
//                             transaction.type == 'income'
//                                 ? Icons.trending_up
//                                 : Icons.trending_down,
//                             color: transaction.type == 'income'
//                                 ? Colors.green
//                                 : Colors.red,
//                           ),
//                         ),
//                         title: Text(
//                           transaction.category,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Text(
//                           transaction.description ?? 'No description',
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                         trailing: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               '${transaction.type == 'income' ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 color: transaction.type == 'income'
//                                     ? Colors.green
//                                     : Colors.red,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               DateFormat('dd/MM/yyyy').format(transaction.date),
//                               style: TextStyle(color: Colors.white70, fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterButton(String title) {
//     bool isSelected = _filterType == title;
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isSelected ? Colors.blue : Color(0xFF2A3547),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       ),
//       onPressed: () {
//         setState(() {
//           _filterType = title;
//           _updateFilteredTransactions();
//         });
//       },
//       child: Text(
//         title,
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class TransactionItem {
  final double amount;
  final String type;
  final String category;
  final String? description;
  final DateTime date;

  TransactionItem({
    required this.amount,
    required this.type,
    required this.category,
    this.description,
    required this.date,
  });

  // Convert a TransactionItem into a Map
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'date': date.toIso8601String(), // Convert DateTime to a string
    };
  }

  // Create a TransactionItem from a Map
  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      amount: map['amount'],
      type: map['type'],
      category: map['category'],
      description: map['description'],
      date: DateTime.parse(map['date']), // Convert string back to DateTime
    );
  }

}

class TransactionsList extends StatefulWidget {
  final List<TransactionItem> transactions;
  final bool isDarkMode;
  final Function(int) onDeleteTransaction;

  const TransactionsList({
    Key? key,
    required this.transactions,
    required this.isDarkMode,
    required this.onDeleteTransaction,
  }) : super(key: key);

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  String _filterType = 'All';
  List<TransactionItem> _filteredTransactions = [];

  // Spotify colors
  static const Color spotifyBackground = Color(0xFF121212);
  static const Color spotifyCardBackground = Color(0xFF181818);
  static const Color spotifyHighlight = Color(0xFF1DB954); // Spotify green
  static const Color spotifySecondary = Color(0xFFB3B3B3);
  static const Color spotifyItemBackground = Color(0xFF282828);

  @override
  void initState() {
    super.initState();
    _updateFilteredTransactions();
  }

  @override
  void didUpdateWidget(TransactionsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateFilteredTransactions();
  }

  void _updateFilteredTransactions() {
    setState(() {
      if (_filterType == 'All') {
        _filteredTransactions = List.from(widget.transactions);
      } else {
        _filteredTransactions = widget.transactions
            .where((t) => t.type == (_filterType == 'Income' ? 'income' : 'expense'))
            .toList();
      }
      _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  Future<void> _downloadPdf() async {
    final pdf = pw.Document();
    
    // Define Spotify theme colors for PDF
    final PdfColor pdfSpotifyBackground = PdfColor.fromHex('121212');
    final PdfColor pdfSpotifyCardBackground = PdfColor.fromHex('181818');
    final PdfColor pdfSpotifyHighlight = PdfColor.fromHex('1DB954');
    final PdfColor pdfSpotifySecondary = PdfColor.fromHex('B3B3B3');
    final PdfColor pdfSpotifyItemBackground = PdfColor.fromHex('282828');
    final PdfColor pdfSpotifyExpense = PdfColor.fromHex('F05454'); // Red for expenses
    final PdfColor pdfWhite = PdfColor.fromHex('FFFFFF');
    final PdfColor pdfBlack = PdfColor.fromHex('000000');
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            color: pdfSpotifyBackground,
            child: pw.Padding(
              padding: pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header with Spotify Style
                  pw.Container(
                    padding: pw.EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: pw.BoxDecoration(
                      color: pdfSpotifyCardBackground,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Transactions Report',
                          style: pw.TextStyle(
                            color: pdfWhite,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          DateFormat('dd MMM yyyy').format(DateTime.now()),
                          style: pw.TextStyle(
                            color: pdfSpotifySecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  pw.SizedBox(height: 20),
                  
                  // Filter type display
                  pw.Container(
                    padding: pw.EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: pw.BoxDecoration(
                      color: pdfSpotifyHighlight,
                      borderRadius: pw.BorderRadius.circular(16),
                    ),
                    child: pw.Text(
                      'Filter: $_filterType',
                      style: pw.TextStyle(
                        color: pdfBlack,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  pw.SizedBox(height: 20),
                  
                  // Summary section - TEXT ONLY, NO ICONS
                  pw.Container(
                    padding: pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: pdfSpotifyCardBackground,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Summary',
                          style: pw.TextStyle(
                            color: pdfWhite,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            // Total Items - TEXT ONLY
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      'Total Items',
                                      style: pw.TextStyle(
                                        color: pdfSpotifySecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    pw.SizedBox(height: 4),
                                    pw.Text(
                                      _filteredTransactions.length.toString(),
                                      style: pw.TextStyle(
                                        color: pdfWhite,
                                        fontSize: 16,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Total Income - TEXT ONLY
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      'Total Income',
                                      style: pw.TextStyle(
                                        color: pdfSpotifySecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    pw.SizedBox(height: 4),
                                    pw.Text(
                                      '+${_calculateTotalIncome().toStringAsFixed(2)}',
                                      style: pw.TextStyle(
                                        color: pdfSpotifyHighlight,
                                        fontSize: 16,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Total Expenses - TEXT ONLY
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.all(8),
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      'Total Expenses',
                                      style: pw.TextStyle(
                                        color: pdfSpotifySecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    pw.SizedBox(height: 4),
                                    pw.Text(
                                      '-${_calculateTotalExpenses().toStringAsFixed(2)}',
                                      style: pw.TextStyle(
                                        color: pdfSpotifyExpense,
                                        fontSize: 16,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  pw.SizedBox(height: 20),
                  
                  // Transactions List - TEXT ONLY, NO ICONS
                  pw.Expanded(
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: pdfSpotifyCardBackground,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Header
                          pw.Container(
                            padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: pw.BoxDecoration(
                              color: pdfSpotifyItemBackground,
                              borderRadius: pw.BorderRadius.only(
                                topLeft: pw.Radius.circular(8),
                                topRight: pw.Radius.circular(8),
                              ),
                            ),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Text(
                                    'Category',
                                    style: pw.TextStyle(
                                      color: pdfSpotifySecondary,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Text(
                                    'Description',
                                    style: pw.TextStyle(
                                      color: pdfSpotifySecondary,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Text(
                                    'Date',
                                    style: pw.TextStyle(
                                      color: pdfSpotifySecondary,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Text(
                                    'Amount',
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(
                                      color: pdfSpotifySecondary,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // List items - TEXT ONLY, NO ICONS OR BACKGROUNDS
                          ..._filteredTransactions.map((transaction) {
                            final isIncome = transaction.type == 'income';
                            return pw.Container(
                              margin: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: pw.BoxDecoration(
                                color: pdfSpotifyItemBackground,
                                borderRadius: pw.BorderRadius.circular(6),
                              ),
                              child: pw.Row(
                                children: [
                                  pw.Expanded(
                                    flex: 3,
                                    child: pw.Text(
                                      transaction.category,
                                      style: pw.TextStyle(
                                        color: pdfWhite,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 3,
                                    child: pw.Text(
                                      transaction.description ?? 'No description',
                                      style: pw.TextStyle(
                                        color: pdfSpotifySecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Text(
                                      DateFormat('dd/MM/yy').format(transaction.date),
                                      style: pw.TextStyle(
                                        color: pdfSpotifySecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 2,
                                    child: pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.end,
                                      children: [
                                        pw.Text(
                                          '${isIncome ? '+' : '-'} ${transaction.amount.toStringAsFixed(2)}',
                                          textAlign: pw.TextAlign.right,
                                          style: pw.TextStyle(
                                            color: isIncome ? pdfSpotifyHighlight : pdfSpotifyExpense,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  
                  pw.SizedBox(height: 20),
                  
                  // Footer - TEXT ONLY
                  pw.Container(
                    alignment: pw.Alignment.center,
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Generated with Penny Pincher App',
                      style: pw.TextStyle(
                        color: pdfSpotifySecondary,
                        fontSize: 10,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    
    // Use the printing package to show the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Spotify_Transactions_${DateFormat('yyyyMMdd').format(DateTime.now())}',
    );
  }

  // Helper methods to calculate totals for PDF summary
  double _calculateTotalIncome() {
    return _filteredTransactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, item) => sum + item.amount);
  }

  double _calculateTotalExpenses() {
    return _filteredTransactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF212121), spotifyBackground],
          stops: [0.0, 0.3],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: spotifyHighlight,
                  child: Icon(Icons.list_alt, color: Colors.black),
                ),
                SizedBox(width: 10),
                Text(
                  "Transactions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.download, color: spotifySecondary),
                  onPressed: _downloadPdf,
                  tooltip: 'Download PDF',
                  splashRadius: 24,
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildFilterChip('All')),
                SizedBox(width: 8),
                Expanded(child: _buildFilterChip('Income')),
                SizedBox(width: 8),
                Expanded(child: _buildFilterChip('Expenses')),
              ],
            ),
            SizedBox(height: 20),
            if (_filteredTransactions.isEmpty)
              Container(
                height: 120,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.playlist_remove, 
                      color: spotifySecondary, 
                      size: 48,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "No transactions found",
                      style: TextStyle(
                        color: spotifySecondary, 
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: ListView.builder(
  shrinkWrap: true,
  itemCount: _filteredTransactions.length,
  padding: EdgeInsets.only(top: 4),
  itemBuilder: (context, index) {
    final transaction = _filteredTransactions[index];
    final isIncome = transaction.type == 'income';
    
    return Dismissible(
      key: Key(transaction.date.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        // Find the index of the transaction in the original list
        int originalIndex = widget.transactions.indexOf(transaction);
        // Call the delete function with the original index
        widget.onDeleteTransaction(originalIndex);
        
        // Show a snackbar or any other feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Transaction deleted"),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: spotifyItemBackground,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: 
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isIncome
                  ? spotifyHighlight.withOpacity(0.2)
                  : Colors.redAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isIncome ? Icons.trending_up : Icons.trending_down,
              color: isIncome ? spotifyHighlight : Colors.redAccent,
              size: 22,
            ),
          ),
          title: Text(
            transaction.category,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                transaction.description ?? 'No description',
                style: TextStyle(
                  color: spotifySecondary,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                DateFormat('dd MMM yyyy').format(transaction.date),
                style: TextStyle(
                  color: spotifySecondary.withOpacity(0.7), 
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: Text(
            '${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isIncome ? spotifyHighlight : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  },
),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String title) {
    bool isSelected = _filterType == title;
    return ChoiceChip(
      label: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : spotifySecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
      selected: isSelected,
      selectedColor: spotifyHighlight,
      backgroundColor: spotifyItemBackground,
      padding: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _filterType = title;
            _updateFilteredTransactions();
          });
        }
      },
    );
  }
}