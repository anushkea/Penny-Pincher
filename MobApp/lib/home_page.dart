
// import 'dart:io';

// import 'package:finaces_tracker/about_page.dart';
// import 'package:finaces_tracker/category_summary_page.dart';
// import 'package:finaces_tracker/currency_converter_page.dart';
// import 'package:finaces_tracker/split_payment.dart';
// import 'package:finaces_tracker/transaction_list_page.dart';
// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'auth_service.dart';
// import 'login_page.dart';
// import 'saving_goals.dart';
// import 'transaction_form_page.dart';
// import 'dark_light_mode.dart'; // Import the new theme provider
// import 'package:pdf/widgets.dart' as pw; // Importing widgets from the pdf package
// import 'about_page.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   double totalBalance = 0.0;
//   double totalIncome = 0.0;
//   double totalExpenses = 0.0;
//   List<TransactionItem> transactions = [];
//   Map<String, double> categoryExpenses = {};
//   Map<String, double> categoryIncome = {};

//   void _updateTransaction(double amount, String type, String category,
//       String description, DateTime date) {
//     final newTransaction = TransactionItem(
//       amount: amount,
//       type: type,
//       category: category,
//       description: description,
//       date: date,
//     );

//     setState(() {
//       transactions.add(newTransaction);

//       if (type == 'income') {
//         totalIncome += amount;
//         totalBalance += amount;
//         categoryIncome[category] = (categoryIncome[category] ?? 0) + amount;
//       } else {
//         totalExpenses += amount;
//         totalBalance -= amount;
//         categoryExpenses[category] = (categoryExpenses[category] ?? 0) + amount;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthService>(context);
//     final themeProvider = Provider.of<ThemeProvider>(context); // Use the theme provider
//     bool isDarkMode = themeProvider.isDarkMode;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Penny Pincher"),
//         backgroundColor: isDarkMode ? Color(0xFF1E2736) : Colors.blue,
//         actions: [
//           IconButton(
//             icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
//             onPressed: themeProvider.toggleDarkMode, // Toggle theme
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: Container(
//           color: isDarkMode ? Color(0xFF1E2736) : Colors.white,
//           child: ListView(
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: isDarkMode ? Color(0xFF2A3547) : Colors.blue,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(Icons.account_circle, size: 80, color: Colors.white),
//                     SizedBox(height: 10),
//                     Text(
//                       auth.user?.email ?? "Guest",
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                   ],
//                 ),
//               ),
//               _buildDrawerItem(Icons.home, "Home", context, isDarkMode),
//               _buildDrawerItem(
//                   Icons.list, "Category Summary", context, isDarkMode,
//                   isAbout: false, iscategorySummary: true),
//               _buildDrawerItem(Icons.compare_arrows, "Split Transaction",
//                   context, isDarkMode,
//                   isAbout: false, isSplitPayments: true),
//               _buildDrawerItem(
//                   Icons.attach_money, "Currency Converter", context, isDarkMode,
//                   isAbout: false, isCurrencyConverter: true),
//               _buildDrawerItem(
//                   Icons.savings, "Saving Goals", context, isDarkMode,
//                   isAbout: false, isSavinggoals: true),
//               _buildDrawerItem(Icons.info, "About", context, isDarkMode,
//                   isAbout: true),
//               ListTile(
//                 leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
//                 title: Text("Logout",
//                     style: TextStyle(
//                         color: isDarkMode ? Colors.white : Colors.redAccent)),
//                 onTap: () async {
//                   await auth.signOut();
//                   Navigator.pushReplacement(
//                       context, MaterialPageRoute(builder: (_) => LoginPage()));
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isDarkMode
//                 ? [Color(0xFF1E2736), Color(0xFF2A3547)]
//                 : [Colors.white, Colors.blue[50]!],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildSummaryCard(
//                   "Total Balance",
//                   "₹${totalBalance.toStringAsFixed(2)}",
//                   Icons.account_balance,
//                   Colors.blue,
//                   isDarkMode),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: _buildSmallSummaryCard(
//                         "Total Income",
//                         "₹${totalIncome.toStringAsFixed(2)}",
//                         Icons.trending_up,
//                         Colors.green,
//                         isDarkMode),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: _buildSmallSummaryCard(
//                         "Total Expenses",
//                         "₹${totalExpenses.toStringAsFixed(2)}",
//                         Icons.trending_down,
//                         Colors.red,
//                         isDarkMode),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               TransactionForm(
//                   onSubmit: (amount, type, category, description, date) {
//                 _updateTransaction(amount, type, category, description, date);
//               }),
//               SizedBox(height: 20),
//               TransactionsList(
//                 transactions: transactions,
//                 isDarkMode: isDarkMode,
//                 onDownloadPdf: () => _generateTransactionPdf(context),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//       IconData icon, String title, BuildContext context, bool isDarkMode,
//       {bool isAbout = false,
//       bool isCurrencyConverter = false,
//       bool isSplitPayments = false,
//       bool iscategorySummary = false,
//       bool isSavinggoals = false}) {
//     return ListTile(
//       leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.blue),
//       title: Text(title,
//           style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
//       onTap: () {
//         if (isCurrencyConverter) {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (_) => CurrencyConverterScreen()));
//         } else if (isSplitPayments) {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (_) => SplitPaymentsPage()));
//                 } else if (isAbout) {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (_) => AboutPage()));
//         } else if (isSavinggoals) {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (_) => SavingsGoals()));
//         } else if (iscategorySummary) {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => CategorySummary(
//                         categoryExpenses: categoryExpenses,
//                         categoryIncome: categoryIncome,
//                         isDarkMode: isDarkMode,
//                         onDownloadPdf: () => _generateTransactionPdf(context),
//                       )));
//         } else {
//           Navigator.pop(context);
//         }
//       },
//     );
//   }

//   Widget _buildSummaryCard(String title, String amount, IconData icon,
//       Color color, bool isDarkMode) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 8,
//       color: isDarkMode ? Color(0xFF2A3547) : Colors.white,
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                       fontSize: 16,
//                       color: isDarkMode ? Colors.white70 : Colors.black54),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   amount,
//                   style: TextStyle(
//                       fontSize: 22, fontWeight: FontWeight.bold, color: color),
//                 ),
//               ],
//             ),
//             CircleAvatar(
//               backgroundColor: color.withOpacity(0.2),
//               radius: 25,
//               child: Icon(icon, color: color, size: 30),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSmallSummaryCard(String title, String amount, IconData icon,
//       Color color, bool isDarkMode) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 6,
//       color: isDarkMode ? Color(0xFF2A3547) : Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(15),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: color, size: 28),
//             SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: isDarkMode ? Colors.white70 : Colors.black54),
//             ),
//             SizedBox(height: 5),
//             Text(
//               amount,
//               style: TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.bold, color: color),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _generateTransactionPdf(BuildContext context) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text('Transactions Report',
//                 style:
//                     pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 20),
//             pw.Table(
//               border: pw.TableBorder.all(),
//               children: [
//                 pw.TableRow(
//                   children: [
//                     pw.Padding(
//                       padding: pw.EdgeInsets.all(5),
//                       child: pw.Text('Date',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     ),
//                     pw.Padding(
//                       padding: pw.EdgeInsets.all(5),
//                       child: pw.Text('Category',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     ),
//                     pw.Padding(
//                       padding: pw.EdgeInsets.all(5),
//                       child: pw.Text('Description',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     ),
//                     pw.Padding(
//                       padding: pw.EdgeInsets.all(5),
//                       child: pw.Text('Amount',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     ),
//                     pw.Padding(
//                       padding: pw.EdgeInsets.all(5),
//                       child: pw.Text('Type',
//                           style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                     ),
//                   ],
//                 ),
//                 ...transactions.map((transaction) {
//                   return pw.TableRow(
//                     children: [
//                       pw.Padding(
//                         padding: pw.EdgeInsets.all(5),
//                         child: pw.Text(
//                             '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'),
//                       ),
//                       pw.Padding(
//                         padding: pw.EdgeInsets.all(5),
//                         child: pw.Text(transaction.category),
//                       ),
//                       pw.Padding(
//                         padding: pw.EdgeInsets.all(5),
//                         child: pw.Text(transaction.description ?? ''),
//                       ),
//                       pw.Padding(
//                         padding: pw.EdgeInsets.all(5),
//                         child: pw.Text(
//                             '₹${transaction.amount.toStringAsFixed(2)}'),
//                       ),
//                       pw.Padding(
//                         padding: pw.EdgeInsets.all(5),
//                         child: pw.Text(transaction.type),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ],
//             ),
//             pw.SizedBox(height: 20),
//             pw.Text('Summary',
//                 style:
//                     pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 10),
//             pw.Text('Total Income: ₹${totalIncome.toStringAsFixed(2)}'),
//             pw.Text('Total Expenses: ₹${totalExpenses.toStringAsFixed(2)}'),
//             pw.Text('Total Balance: ₹${totalBalance.toStringAsFixed(2)}'),
//           ],
//         ),
//       ),
//     );

//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/transactions_report.pdf');
//     await file.writeAsBytes(await pdf.save());

//     await OpenFile.open(file.path);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Transactions report downloaded successfully')),
//     );
//   }
// }

import 'dart:io';
import 'package:finaces_tracker/about_page.dart';
import 'package:finaces_tracker/category_summary_page.dart';
import 'package:finaces_tracker/currency_converter_page.dart';
import 'package:finaces_tracker/split_payment.dart';
import 'package:finaces_tracker/transaction_list_page.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'login_page.dart';
import 'saving_goals.dart';
import 'add_transaction_form.dart';
import 'dark_light_mode.dart';
import 'package:pdf/widgets.dart' as pw;
import 'about_page.dart';
import 'loan_calculator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalBalance = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  List<TransactionItem> transactions = [];
  Map<String, double> categoryExpenses = {};
  Map<String, double> categoryIncome = {};

  // Spotify-inspired dark mode colors
  final Color spotifyBlack = const Color(0xFF121212);
  final Color spotifyDarkGrey = const Color(0xFF212121);
  final Color spotifyGrey = const Color(0xFF535353);
  final Color spotifyLightGrey = const Color(0xFFB3B3B3);
  final Color spotifyGreen = const Color(0xFF1DB954);
  final Color spotifyWhite = const Color(0xFFFFFFFF);

  // Purple theme colors
  final Color primaryPurple = const Color(0xFF8E24AA); // Purple 500
  final Color darkPurple = const Color(0xFF5E35B1);    // Deep Purple 500
  final Color lightPurple = const Color(0xFFAB47BC);   // Purple 400
  final Color veryLightPurple = const Color(0xFFE1BEE7); // Purple 100
  final Color blackPurple = const Color(0xFF1E1A2C);   // Dark purplish black
  final Color darkGrey = const Color(0xFF212121);
  final Color lightGrey = const Color(0xFFE0E0E0);
  final Color bloodRed = const Color(0xFF8B0000);      // Blood red
  final Color brightGreen = const Color(0xFF4CAF50);   // Bright green
  final Color almostWhite = const Color(0xFFF8F8F8);

  // New sage/stone theme colors
  final Color primarySage = const Color(0xFF989C94);      // Base sage color
  final Color darkSage = const Color(0xFF7A7D76);         // Darker shade
  final Color lightSage = const Color(0xFFAEB2A8);        // Lighter shade
  final Color verySoftSage = const Color(0xFFD6D8D1);     // Very light shade
  final Color blackishSage = const Color(0xFF1A1C19);     // Dark background with sage tint
  final Color deepBlack = const Color(0xFF121212);        // Deep black for contrast
  final Color expenseRed = const Color(0xFF8B0000);       // Blood red for expenses
  final Color incomeGreen = const Color(0xFF4CAF50);      // Bright green for income
  final Color almostWhiteContrast = const Color(0xFFF8F8F8);      // Almost white for contrast

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

Future<void> _loadTransactions() async {
  final prefs = await SharedPreferences.getInstance();
  final transactionsJson = prefs.getString('transactions');
  if (transactionsJson != null) {
    final List<dynamic> transactionsList = json.decode(transactionsJson);
    setState(() {
      transactions = transactionsList.map((item) => TransactionItem.fromMap(item)).toList();
      _updateTotals();
    });
  }
}

Future<void> _saveTransactions() async {
  final prefs = await SharedPreferences.getInstance();
  final transactionsJson = json.encode(transactions.map((item) => item.toMap()).toList());
  await prefs.setString('transactions', transactionsJson);
}

  void _updateTotals() {
    totalIncome = transactions.where((t) => t.type == 'income').fold(0, (sum, item) => sum + item.amount);
    totalExpenses = transactions.where((t) => t.type == 'expense').fold(0, (sum, item) => sum + item.amount);
    totalBalance = totalIncome - totalExpenses;
  }

  void _updateTransaction(double amount, String type, String category,
      String description, DateTime date) {
    final newTransaction = TransactionItem(
      amount: amount,
      type: type,
      category: category,
      description: description,
      date: date,
    );

    setState(() {
      transactions.add(newTransaction);

      if (type == 'income') {
        totalIncome += amount;
        totalBalance += amount;
        categoryIncome[category] = (categoryIncome[category] ?? 0) + amount;
      } else {
        totalExpenses += amount;
        totalBalance -= amount;
        categoryExpenses[category] = (categoryExpenses[category] ?? 0) + amount;
      }
      _saveTransactions();
    });
  }

  void _deleteTransaction(int index) {
    final transaction = transactions[index];
    setState(() {
      if (transaction.type == 'income') {
        totalIncome -= transaction.amount;
        totalBalance -= transaction.amount;
        categoryIncome[transaction.category] = (categoryIncome[transaction.category] ?? 0) - transaction.amount;
      } else {
        totalExpenses -= transaction.amount;
        totalBalance += transaction.amount;
        categoryExpenses[transaction.category] = (categoryExpenses[transaction.category] ?? 0) - transaction.amount;
      }
      transactions.removeAt(index);
      _saveTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? blackishSage : almostWhite,
      appBar: AppBar(
        title: const Text(
          "Penny Pincher",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: isDarkMode ? deepBlack : primarySage,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: themeProvider.toggleDarkMode,
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generateTransactionPdf(context),
            color: Colors.white,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: isDarkMode ? blackishSage : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode 
                        ? [darkSage, deepBlack]
                        : [primarySage, darkSage],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(Icons.account_circle, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      auth.user?.email ?? "Guest",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.home, "Home", context, isDarkMode),
              _buildDrawerItem(Icons.compare_arrows, "Split Transaction",
                  context, isDarkMode,
                  isAbout: false, isSplitPayments: true),
              _buildDrawerItem(
                  Icons.attach_money, "Currency Converter", context, isDarkMode,
                  isAbout: false, isCurrencyConverter: true),
              _buildDrawerItem(
                  Icons.savings, "Saving Goals", context, isDarkMode,
                  isAbout: false, isSavinggoals: true),
              _buildDrawerItem(
                  Icons.calculate, "Loan Calculator", context, isDarkMode,
                  isAbout: false, isLoancalculator: true),
              _buildDrawerItem(Icons.info, "About", context, isDarkMode,
                  isAbout: true),
              Divider(
                color: isDarkMode ? spotifyGrey : Colors.grey[300],
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app,
                    color: isDarkMode ? spotifyWhite : Colors.redAccent),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: isDarkMode ? spotifyWhite : Colors.redAccent,
                    fontWeight: isDarkMode ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                onTap: () async {
                  await auth.signOut();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => LoginPage()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [blackishSage, const Color(0xFF212621)]
                : [almostWhite, const Color(0xFFECEEE9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSummaryCard(
                "Total Balance",
                "₹${totalBalance.toStringAsFixed(2)}",
                Icons.account_balance_wallet,
                isDarkMode ? lightSage : primarySage,
                isDarkMode,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildSmallSummaryCard(
                      "Income",
                      "₹${totalIncome.toStringAsFixed(2)}",
                      Icons.trending_up,
                      brightGreen,
                      isDarkMode,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSmallSummaryCard(
                      "Expenses",
                      "₹${totalExpenses.toStringAsFixed(2)}",
                      Icons.trending_down,
                      bloodRed,
                      isDarkMode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF232523) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isDarkMode ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ] : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: isDarkMode ? Border.all(color: darkSage.withOpacity(0.3), width: 1) : null,
                ),
                padding: const EdgeInsets.all(20),
                child: TransactionForm(
                  onSubmit: (amount, type, category, description, date) {
                    _updateTransaction(
                        amount, type, category, description, date);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isDarkMode ? lightSage : primarySage,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF424242),
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TransactionsList(
                transactions: transactions,
                isDarkMode: isDarkMode,
                onDeleteTransaction: _deleteTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, BuildContext context, bool isDarkMode,
      {bool isAbout = false,
      bool isCurrencyConverter = false,
      bool isSplitPayments = false,
      bool isSavinggoals = false,
      bool isLoancalculator = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode
            ? (title == "Home" ? lightSage : Colors.white70)
            : (title == "Home" ? primarySage : darkSage.withOpacity(0.8)),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode
              ? (title == "Home" ? lightSage : Colors.white70)
              : (title == "Home" ? primarySage : const Color(0xFF424242)),
          fontSize: 16,
          fontWeight: title == "Home" ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'Roboto',
        ),
      ),
      onTap: () {
        if (isCurrencyConverter) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CurrencyConverterScreen()));
        } else if (isSplitPayments) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SplitPaymentsPage()));
        } else if (isAbout) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AboutPage()));
        } else if (isSavinggoals) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SavingsGoals()));
        } else if (isLoancalculator) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoanCalculatorPage()));
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon,
      Color color, bool isDarkMode) {
    // Determine the color for the total balance based on its value
    Color balanceColor;
    if (totalBalance < 0) {
      balanceColor = bloodRed;
    } else if (totalBalance == 0) {
      balanceColor = isDarkMode ? Colors.white : Colors.black87;
    } else {
      balanceColor = color;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: isDarkMode ? 12 : 8,
      shadowColor: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.black26,
      color: isDarkMode ? const Color(0xFF232523) : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF232523), Color(0xFF1A1C19)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: isDarkMode ? Border.all(color: darkSage.withOpacity(0.2), width: 1) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: balanceColor,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDarkMode ? color.withOpacity(0.15) : color.withOpacity(0.1),
                border: Border.all(
                  color: isDarkMode ? color.withOpacity(0.3) : color.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode 
                        ? Colors.black.withOpacity(0.3) 
                        : color.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallSummaryCard(String title, String amount, IconData icon,
      Color color, bool isDarkMode) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: isDarkMode ? 12 : 6,
      shadowColor: isDarkMode ? Colors.black.withOpacity(0.3) : color.withOpacity(0.2),
      color: isDarkMode ? const Color(0xFF232523) : Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isDarkMode
              ? const LinearGradient(
                  colors: [Color(0xFF232523), Color(0xFF1A1C19)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: isDarkMode ? Border.all(color: color.withOpacity(0.2), width: 1) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDarkMode ? color.withOpacity(0.1) : color.withOpacity(0.08),
                border: Border.all(
                  color: isDarkMode ? color.withOpacity(0.3) : color.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black.withOpacity(0.3) : color.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateTransactionPdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Transactions Report',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Date',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Category',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Description',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Amount',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Type',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                ...transactions.map((transaction) {
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                            '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(transaction.category),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(transaction.description ?? ''),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                            '₹${transaction.amount.toStringAsFixed(2)}'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(transaction.type),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Summary',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Total Income: ₹${totalIncome.toStringAsFixed(2)}'),
            pw.Text('Total Expenses: ₹${totalExpenses.toStringAsFixed(2)}'),
            pw.Text('Total Balance: ₹${totalBalance.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/transactions_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(file.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transactions report downloaded successfully'),
        backgroundColor: primarySage,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}