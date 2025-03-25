// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class TransactionForm extends StatefulWidget {
//   final Function(double, String, String, String, DateTime) onSubmit;

//   TransactionForm({required this.onSubmit});

//   @override
//   _TransactionFormState createState() => _TransactionFormState();
// }

// class _TransactionFormState extends State<TransactionForm> {
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   String _selectedType = 'expense';
//   String _selectedCategory = 'Select a category';
//   DateTime _selectedDate = DateTime.now();

//   final Map<String, List<String>> _categoriesByType = {
//     'expense': [
//       'Food',
//       'Transport',
//       'Entertainment',
//       'Rent',
//       'Utilities',
//       'Shopping',
//       'Healthcare',
//       'Education',
//       'Other'
//     ],
//     'income': [
//       'Salary',
//       'Freelancer',
//       'Investments',
//       'Business',
//       'Rental',
//       'Other Income'
//     ]
//   };

//   void _handleSubmit() {
//     if (_amountController.text.isEmpty || _selectedCategory == 'Select a category') {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill all required fields')),
//       );
//       return;
//     }

//     double amount = double.tryParse(_amountController.text) ?? 0;
//     if (amount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid amount')),
//       );
//       return;
//     }

//     widget.onSubmit(
//       amount,
//       _selectedType,
//       _selectedCategory,
//       _descriptionController.text,
//       _selectedDate
//     );

//     // Reset form
//     _amountController.clear();
//     _descriptionController.clear();
//     setState(() {
//       _selectedCategory = 'Select a category';
//       _selectedDate = DateTime.now();
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Transaction added successfully')),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.dark().copyWith(
//             colorScheme: ColorScheme.dark(
//               primary: Colors.blue,
//               onPrimary: Colors.white,
//               surface: Color(0xFF1E2736),
//               onSurface: Colors.white,
//             ),
//             dialogBackgroundColor: Color(0xFF1E2736),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Color(0xFF1E2736),
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             "Add Transaction",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 16),

//           // Type Selection
//           Text("Type", style: TextStyle(color: Colors.white, fontSize: 14)),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedType = 'income';
//                       _selectedCategory = 'Select a category';
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                     decoration: BoxDecoration(
//                       color: _selectedType == 'income'
//                           ? Colors.green
//                           : Colors.green.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Income',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedType = 'expense';
//                       _selectedCategory = 'Select a category';
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                     decoration: BoxDecoration(
//                       color: _selectedType == 'expense'
//                           ? Colors.red
//                           : Colors.red.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Expense',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),

//           // Amount Field
//           Text("Amount", style: TextStyle(color: Colors.white, fontSize: 14)),
//           SizedBox(height: 8),
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0xFF2A3547),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: TextField(
//               controller: _amountController,
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//             ),
//           ),
//           SizedBox(height: 16),

//           // Description Field
//           Text("Description", style: TextStyle(color: Colors.white, fontSize: 14)),
//           SizedBox(height: 8),
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0xFF2A3547),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: TextField(
//               controller: _descriptionController,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//             ),
//           ),
//           SizedBox(height: 16),

//           // Category Field
//           Text("Category", style: TextStyle(color: Colors.white, fontSize: 14)),
//           SizedBox(height: 8),
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0xFF2A3547),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: DropdownButtonFormField<String>(
//               value: _selectedCategory,
//               dropdownColor: Color(0xFF2A3547),
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//               ),
//               items: [
//                 DropdownMenuItem(
//                   value: 'Select a category',
//                   child: Text('Select a category', style: TextStyle(color: Colors.white70)),
//                 ),
//                 ..._categoriesByType[_selectedType]!.map((String category) {
//                   return DropdownMenuItem(
//                     value: category,
//                     child: Text(category, style: TextStyle(color: Colors.white)),
//                   );
//                 }).toList(),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategory = value!;
//                 });
//               },
//               icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
//             ),
//           ),
//           SizedBox(height: 16),

//           // Date Field
//           Text("Date", style: TextStyle(color: Colors.white, fontSize: 14)),
//           SizedBox(height: 8),
//           GestureDetector(
//             onTap: () => _selectDate(context),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color(0xFF2A3547),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     DateFormat('dd-MM-yyyy').format(_selectedDate),
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   Icon(Icons.calendar_today, color: Colors.white),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 16),

//           // Submit Button
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 12),
//             ),
//             onPressed: _handleSubmit,
//             child: Text(
//               _selectedType == 'income' ? "Add Income" : "Add Expense",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final Function(double, String, String, String, DateTime) onSubmit;

  TransactionForm({required this.onSubmit});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedType = 'expense';
  String _selectedCategory = 'Select a category';
  DateTime _selectedDate = DateTime.now();

  // Spotify-inspired dark mode colors
  final Color spotifyBlack = Color(0xFF121212);
  final Color spotifyDarkGrey = Color(0xFF212121);
  final Color spotifyGrey = Color(0xFF535353);
  final Color spotifyLightGrey = Color(0xFFB3B3B3);
  final Color spotifyGreen = Color(0xFF1DB954);
  final Color spotifyWhite = Color(0xFFFFFFFF);

  final Map<String, List<String>> _categoriesByType = {
    'expense': [
      'Food',
      'Transport',
      'Entertainment',
      'Rent',
      'Utilities',
      'Shopping',
      'Healthcare',
      'Education',
      'Other'
    ],
    'income': [
      'Salary',
      'Freelancer',
      'Investments',
      'Business',
      'Rental',
      'Other Income'
    ]
  };

  void _handleSubmit() {
    if (_amountController.text.isEmpty || _selectedCategory == 'Select a category') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: spotifyDarkGrey,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: spotifyDarkGrey,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.onSubmit(
      amount,
      _selectedType,
      _selectedCategory,
      _descriptionController.text,
      _selectedDate
    );

    // Reset form
    _amountController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = 'Select a category';
      _selectedDate = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction added successfully'),
        backgroundColor: spotifyGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: spotifyGreen,
              onPrimary: spotifyWhite,
              surface: spotifyDarkGrey,
              onSurface: spotifyWhite,
            ),
            dialogBackgroundColor: spotifyBlack,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: spotifyBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_circle,
                color: spotifyGreen,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                "Add Transaction",
                style: TextStyle(
                  color: spotifyWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Type Selection
          Text(
            "Type",
            style: TextStyle(
              color: spotifyLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = 'income';
                      _selectedCategory = 'Select a category';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _selectedType == 'income'
                          ? spotifyGreen
                          : spotifyDarkGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Income',
                      style: TextStyle(
                        color: _selectedType == 'income'
                            ? spotifyBlack
                            : spotifyLightGrey,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = 'expense';
                      _selectedCategory = 'Select a category';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _selectedType == 'expense'
                          ? Color(0xFFE53935) 
                          : spotifyDarkGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Expense',
                      style: TextStyle(
                        color: _selectedType == 'expense'
                            ? spotifyBlack
                            : spotifyLightGrey,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Amount Field
          Text(
            "Amount",
            style: TextStyle(
              color: spotifyLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: spotifyDarkGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                color: spotifyWhite,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  color: spotifyLightGrey,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: "0.00",
                hintStyle: TextStyle(
                  color: spotifyGrey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Category Field
          Text(
            "Category",
            style: TextStyle(
              color: spotifyLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: spotifyDarkGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              dropdownColor: Color(0xFF333333),
              style: TextStyle(
                color: spotifyWhite,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.category,
                  color: spotifyLightGrey,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              ),
              items: [
                DropdownMenuItem(
                  value: 'Select a category',
                  child: Text(
                    'Select a category',
                    style: TextStyle(
                      color: spotifyGrey,
                      fontSize: 16,
                    ),
                  ),
                ),
                ..._categoriesByType[_selectedType]!.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(
                        color: spotifyWhite,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: spotifyLightGrey,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Date Field
          Text(
            "Date",
            style: TextStyle(
              color: spotifyLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              decoration: BoxDecoration(
                color: spotifyDarkGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: spotifyLightGrey,
                    size: 20,
                  ),
                  SizedBox(width: 16),
                  Text(
                    DateFormat('dd-MM-yyyy').format(_selectedDate),
                    style: TextStyle(
                      color: spotifyWhite,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_drop_down,
                    color: spotifyLightGrey,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          
          // Description Field (Moved from above to below the date section)
          Text(
            "Description",
            style: TextStyle(
              color: spotifyLightGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: spotifyDarkGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _descriptionController,
              style: TextStyle(
                color: spotifyWhite,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.description,
                  color: spotifyLightGrey,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: "What's this transaction for?",
                hintStyle: TextStyle(
                  color: spotifyGrey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Submit Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: spotifyGreen,
              foregroundColor: spotifyBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              padding: EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            onPressed: _handleSubmit,
            child: Text(
              _selectedType == 'income' ? "ADD INCOME" : "ADD EXPENSE",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}