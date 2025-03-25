// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:intl/intl.dart';

// class SavingsGoals extends StatefulWidget {
//   const SavingsGoals({Key? key}) : super(key: key);

//   @override
//   _SavingsGoalsState createState() => _SavingsGoalsState();
// }

// class _SavingsGoalsState extends State<SavingsGoals> {
//   List<Goal> goals = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadGoals();
//   }

//   Future<void> _loadGoals() async {
//     final prefs = await SharedPreferences.getInstance();
//     final goalsJson = prefs.getStringList('goals') ?? [];

//     setState(() {
//       goals = goalsJson.map((json) => Goal.fromJson(jsonDecode(json))).toList();
//       isLoading = false;
//     });
//   }

//   Future<void> _saveGoals() async {
//     final prefs = await SharedPreferences.getInstance();
//     final goalsJson = goals.map((goal) => jsonEncode(goal.toJson())).toList();
//     await prefs.setStringList('goals', goalsJson);
//   }

//   void _addGoal(Goal goal) {
//     setState(() {
//       goals.add(goal);
//       _saveGoals();
//     });
//   }

//   void _updateGoal(Goal goal, int index) {
//     setState(() {
//       goals[index] = goal;
//       _saveGoals();
//     });
//   }

//   void _deleteGoal(int index) {
//     setState(() {
//       goals.removeAt(index);
//       _saveGoals();
//     });
//   }

//   void _addMoneyToGoal(int index, double amount) {
//     setState(() {
//       goals[index].currentSavings += amount;
//       _saveGoals();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E222C),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: isLoading
//                     ? const Center(
//                         child:
//                             CircularProgressIndicator(color: Color(0xFFA855F7)))
//                     : _buildGoalsList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddGoalDialog(context),
//         backgroundColor: const Color(0xFFA855F7),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: const Color(0xFFA855F7),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: const Icon(
//             Icons.savings_outlined,
//             color: Colors.white,
//             size: 24,
//           ),
//         ),
//         const SizedBox(width: 10),
//         const Text(
//           'Savings Goals',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGoalsList() {
//     if (goals.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.savings_outlined,
//               color: Color(0xFFA855F7),
//               size: 64,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'No savings goals yet.',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Click "+" to create one!',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: goals.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 10),
//           child: _buildGoalCard(goals[index], index),
//         );
//       },
//     );
//   }

//   Widget _buildGoalCard(Goal goal, int index) {
//     final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
//     final progress = goal.currentSavings / goal.targetAmount * 100;

//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A303C),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFA855F7),
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       child: const Icon(Icons.savings,
//                           color: Colors.white, size: 18),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             goal.title,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             '~$daysLeft days left',
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF10B981),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.attach_money,
//                           color: Colors.white, size: 16),
//                       onPressed: () => _showAddMoneyDialog(context, index),
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade700,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.delete,
//                           color: Colors.white, size: 16),
//                       onPressed: () => _deleteGoal(index),
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Progress',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 5),
//           LinearProgressIndicator(
//             value: progress / 100,
//             backgroundColor: Colors.grey.shade800,
//             valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA855F7)),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '₹${goal.currentSavings.toStringAsFixed(0)}',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     '${progress.toStringAsFixed(1)}%',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(width: 5),
//                   Text(
//                     '₹${goal.targetAmount.toStringAsFixed(0)}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAddGoalDialog(BuildContext context) {
//     final titleController = TextEditingController();
//     final targetAmountController = TextEditingController();
//     final currentSavingsController = TextEditingController(text: '0');
//     final dateController = TextEditingController(
//       text: DateFormat('dd-MM-yyyy')
//           .format(DateTime.now().add(const Duration(days: 30))),
//     );
//     bool setReminder = true;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               backgroundColor: const Color(0xFF1E222C),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 36,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFA855F7),
//                               borderRadius: BorderRadius.circular(18),
//                             ),
//                             child: const Icon(Icons.savings,
//                                 color: Colors.white, size: 18),
//                           ),
//                           const SizedBox(width: 10),
//                           const Text(
//                             'Add New Goal',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Goal Title',
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       TextField(
//                         controller: titleController,
//                         style: const TextStyle(color: Colors.white),
//                         decoration: InputDecoration(
//                           fillColor: const Color(0xFF2A303C),
//                           filled: true,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Target Amount',
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 TextField(
//                                   controller: targetAmountController,
//                                   style: const TextStyle(color: Colors.white),
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     fillColor: const Color(0xFF2A303C),
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Current Savings',
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 TextField(
//                                   controller: currentSavingsController,
//                                   style: const TextStyle(color: Colors.white),
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     fillColor: const Color(0xFF2A303C),
//                                     filled: true,
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 15),
//                       const Text(
//                         'Target Date',
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       TextField(
//                         controller: dateController,
//                         style: const TextStyle(color: Colors.white),
//                         readOnly: true,
//                         onTap: () async {
//                           final date = await showDatePicker(
//                             context: context,
//                             initialDate:
//                                 DateTime.now().add(const Duration(days: 30)),
//                             firstDate: DateTime.now(),
//                             lastDate:
//                                 DateTime.now().add(const Duration(days: 3650)),
//                             builder: (context, child) {
//                               return Theme(
//                                 data: ThemeData.dark().copyWith(
//                                   colorScheme: ColorScheme.dark(
//                                     primary: const Color(0xFFA855F7),
//                                     onPrimary: Colors.white,
//                                     surface: const Color(0xFF2A303C),
//                                     onSurface: Colors.white,
//                                   ),
//                                 ),
//                                 child: child!,
//                               );
//                             },
//                           );
//                           if (date != null) {
//                             setState(() {
//                               dateController.text =
//                                   DateFormat('dd-MM-yyyy').format(date);
//                             });
//                           }
//                         },
//                         decoration: InputDecoration(
//                           fillColor: const Color(0xFF2A303C),
//                           filled: true,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                             borderSide: BorderSide.none,),
//                             suffixIcon: const Icon(Icons.calendar_today,
//                               color: Colors.white),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: setReminder,
//                             onChanged: (value) {
//                               setState(() {
//                                 setReminder = value ?? true;
//                               });
//                             },
//                             activeColor: const Color(0xFFA855F7),
//                           ),
//                           const Text(
//                             'Set Reminder',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text(
//                               'Cancel',
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (titleController.text.isNotEmpty &&
//                                   targetAmountController.text.isNotEmpty) {
//                                 final goal = Goal(
//                                   title: titleController.text,
//                                   targetAmount:
//                                       double.parse(targetAmountController.text),
//                                   currentSavings: double.parse(
//                                       currentSavingsController.text),
//                                   targetDate: DateFormat('dd-MM-yyyy')
//                                       .parse(dateController.text),
//                                   hasReminder: setReminder,
//                                 );
//                                 Navigator.pop(context);
//                                 _addGoal(goal);
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFFA855F7),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 10),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text(
//                               'Save Goal',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showAddMoneyDialog(BuildContext context, int index) {
//     final amountController = TextEditingController();
//     bool deductFromMainBalance = true;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               backgroundColor: const Color(0xFF1E222C),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Add Money to Goal',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Amount',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     TextField(
//                       controller: amountController,
//                       style: const TextStyle(color: Colors.white),
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         fillColor: const Color(0xFF2A303C),
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: deductFromMainBalance,
//                           onChanged: (value) {
//                             setState(() {
//                               deductFromMainBalance = value ?? true;
//                             });
//                           },
//                           activeColor: const Color(0xFFA855F7),
//                         ),
//                         const Text(
//                           'Deduct from main balance',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text(
//                             'Cancel',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             if (amountController.text.isNotEmpty) {
//                               final amount =
//                                   double.parse(amountController.text);
//                               Navigator.pop(context);
//                               _addMoneyToGoal(index, amount);
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFA855F7),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: const Text(
//                             'Add Money',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class Goal {
//   String title;
//   double targetAmount;
//   double currentSavings;
//   DateTime targetDate;
//   bool hasReminder;

//   Goal({
//     required this.title,
//     required this.targetAmount,
//     required this.currentSavings,
//     required this.targetDate,
//     required this.hasReminder,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'targetAmount': targetAmount,
//       'currentSavings': currentSavings,
//       'targetDate': targetDate.toIso8601String(),
//       'hasReminder': hasReminder,
//     };
//   }

//   factory Goal.fromJson(Map<String, dynamic> json) {
//     return Goal(
//       title: json['title'],
//       targetAmount: json['targetAmount'],
//       currentSavings: json['currentSavings'],
//       targetDate: DateTime.parse(json['targetDate']),
//       hasReminder: json['hasReminder'],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SavingsGoals extends StatefulWidget {
  const SavingsGoals({Key? key}) : super(key: key);

  @override
  _SavingsGoalsState createState() => _SavingsGoalsState();
}

class _SavingsGoalsState extends State<SavingsGoals> {
  List<Goal> goals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = prefs.getStringList('goals') ?? [];

    setState(() {
      goals = goalsJson.map((json) => Goal.fromJson(jsonDecode(json))).toList();
      isLoading = false;
    });
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = goals.map((goal) => jsonEncode(goal.toJson())).toList();
    await prefs.setStringList('goals', goalsJson);
  }

  void _addGoal(Goal goal) {
    setState(() {
      goals.add(goal);
      _saveGoals();
    });
  }

  void _updateGoal(Goal goal, int index) {
    setState(() {
      goals[index] = goal;
      _saveGoals();
    });
  }

  void _deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
      _saveGoals();
    });
  }

  void _addMoneyToGoal(int index, double amount) {
    setState(() {
      goals[index].currentSavings += amount;
      _saveGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    
    // Spotify color scheme
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
    final cardColor = isDarkMode ? const Color(0xFF181818) : const Color(0xFFFFFFFF);
    final primaryColor = const Color(0xFF1DB954); // Spotify green
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final tertiaryColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildHeader(textColor, primaryColor),
              const SizedBox(height: 24),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: primaryColor))
                    : _buildGoalsList(
                        cardColor, textColor, secondaryTextColor, primaryColor, tertiaryColor),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context, primaryColor, backgroundColor, cardColor, textColor, secondaryTextColor, tertiaryColor),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(Color textColor, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.savings_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Savings Goals',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList(Color cardColor, Color textColor, Color secondaryTextColor, Color primaryColor, Color tertiaryColor) {
    if (goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.savings_outlined,
              color: primaryColor,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'No savings goals yet',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create one',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildGoalCard(goals[index], index, cardColor, textColor, secondaryTextColor, primaryColor, tertiaryColor),
        );
      },
    );
  }

  Widget _buildGoalCard(Goal goal, int index, Color cardColor, Color textColor, Color secondaryTextColor, Color primaryColor, Color tertiaryColor) {
    final daysLeft = goal.targetDate.difference(DateTime.now()).inDays;
    final progress = goal.currentSavings / goal.targetAmount * 100;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.savings,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            daysLeft > 0 ? '$daysLeft days left' : 'Due today',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.attach_money,
                          color: Colors.white, size: 16),
                      onPressed: () => _showAddMoneyDialog(context, index, primaryColor, backgroundColor: cardColor, textColor: textColor, secondaryTextColor: secondaryTextColor, tertiaryColor: tertiaryColor),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.delete,
                          color: textColor, size: 16),
                      onPressed: () => _deleteGoal(index),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Progress',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: tertiaryColor,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${goal.currentSavings.toStringAsFixed(0)}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${progress.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${goal.targetAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, Color primaryColor, Color backgroundColor, Color cardColor, Color textColor, Color secondaryTextColor, Color tertiaryColor) {
    final titleController = TextEditingController();
    final targetAmountController = TextEditingController();
    final currentSavingsController = TextEditingController(text: '0');
    final dateController = TextEditingController(
      text: DateFormat('dd-MM-yyyy')
          .format(DateTime.now().add(const Duration(days: 30))),
    );
    bool setReminder = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.savings,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Create New Goal',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Goal Title',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          fillColor: cardColor,
                          filled: true,
                          hintText: 'e.g. New Car',
                          hintStyle: TextStyle(color: secondaryTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: tertiaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: tertiaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Target Amount',
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: targetAmountController,
                                  style: TextStyle(color: textColor),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    fillColor: cardColor,
                                    filled: true,
                                    prefixText: '₹ ',
                                    prefixStyle: TextStyle(color: textColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: tertiaryColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: tertiaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: primaryColor, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Savings',
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: currentSavingsController,
                                  style: TextStyle(color: textColor),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    fillColor: cardColor,
                                    filled: true,
                                    prefixText: '₹ ',
                                    prefixStyle: TextStyle(color: textColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: tertiaryColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: tertiaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: primaryColor, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Target Date',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: dateController,
                        style: TextStyle(color: textColor),
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 30)),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 3650)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: primaryColor,
                                    onPrimary: Colors.white,
                                    surface: cardColor,
                                    onSurface: textColor,
                                  ),
                                  dialogBackgroundColor: backgroundColor,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            setState(() {
                              dateController.text =
                                  DateFormat('dd-MM-yyyy').format(date);
                            });
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: cardColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: tertiaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: tertiaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            setReminder = !setReminder;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: setReminder,
                                onChanged: (value) {
                                  setState(() {
                                    setReminder = value ?? true;
                                  });
                                },
                                activeColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Set Reminder',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: VAL),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (titleController.text.isNotEmpty &&
                                  targetAmountController.text.isNotEmpty) {
                                final goal = Goal(
                                  title: titleController.text,
                                  targetAmount:
                                      double.parse(targetAmountController.text),
                                  currentSavings: double.parse(
                                      currentSavingsController.text),
                                  targetDate: DateFormat('dd-MM-yyyy')
                                      .parse(dateController.text),
                                  hasReminder: setReminder,
                                );
                                Navigator.pop(context);
                                _addGoal(goal);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'CREATE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddMoneyDialog(BuildContext context, int index, Color primaryColor, {
    required Color backgroundColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color tertiaryColor,
  }) {
    final amountController = TextEditingController();
    bool deductFromMainBalance = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Money to Goal',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Amount',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      style: TextStyle(color: textColor),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: backgroundColor,
                        filled: true,
                        prefixText: '₹ ',
                        prefixStyle: TextStyle(color: textColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: tertiaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: tertiaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          deductFromMainBalance = !deductFromMainBalance;
                        });
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: deductFromMainBalance,
                              onChanged: (value) {
                                setState(() {
                                  deductFromMainBalance = value ?? true;
                                });
                              },
                              activeColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Deduct from main balance',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (amountController.text.isNotEmpty) {
                              final amount =
                                  double.parse(amountController.text);
                              Navigator.pop(context);
                              _addMoneyToGoal(index, amount);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'ADD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class Goal {
  String title;
  double targetAmount;
  double currentSavings;
  DateTime targetDate;
  bool hasReminder;

  Goal({
    required this.title,
    required this.targetAmount,
    required this.currentSavings,
    required this.targetDate,
    required this.hasReminder,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'currentSavings': currentSavings,
      'targetDate': targetDate.toIso8601String(),
      'hasReminder': hasReminder,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      title: json['title'],
      targetAmount: json['targetAmount'],
      currentSavings: json['currentSavings'],
      targetDate: DateTime.parse(json['targetDate']),
      hasReminder: json['hasReminder'],
    );
  }
}

// Define a constant that was missing in the code
const double VAL = 8.0;