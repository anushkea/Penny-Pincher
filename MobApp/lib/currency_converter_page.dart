// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/services.dart';


// class CurrencyConverterScreen extends StatefulWidget {
//   const CurrencyConverterScreen({Key? key}) : super(key: key);

//   @override
//   State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
// }

// class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
//   // API Constants
//   static const String API_KEY = '2d82e3c4e4d64c7aa0c8c70a0b89795d';
//   static const String API_URL = 'https://open.er-api.com/v6/latest/';
  
//   // Exchange rates data
//   Map<String, dynamic> exchangeRates = {};
//   bool isLoading = true;
//   String errorMessage = '';
  
//   // Currency selection
//   String fromCurrency = 'USD';
//   String toCurrency = 'EUR';
  
//   // Amount controllers
//   final TextEditingController fromController = TextEditingController(text: '100');
//   final TextEditingController toController = TextEditingController(text: '');
  
//   // Currency names and symbols
//   final Map<String, String> currencyNames = {
//     'USD': 'US Dollar',
//     'EUR': 'Euro',
//     'GBP': 'British Pound',
//     'JPY': 'Japanese Yen',
//     'AUD': 'Australian Dollar',
//     'CAD': 'Canadian Dollar',
//     'CHF': 'Swiss Franc',
//     'CNY': 'Chinese Yuan',
//     'INR': 'Indian Rupee',
//   };

//   @override
//   void initState() {
//     super.initState();
//     fetchExchangeRates();
//     fromController.addListener(convertFromTo);
//   }
  
//   @override
//   void dispose() {
//     fromController.dispose();
//     toController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchExchangeRates() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });
    
//     try {
//       final response = await http.get(
//         Uri.parse('$API_URL$fromCurrency?apikey=$API_KEY'),
//       );
      
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
        
//         if (data['result'] == 'success') {
//           setState(() {
//             exchangeRates = data['rates'];
//             isLoading = false;
//             // Calculate initial conversion
//             convertFromTo();
//           });
//         } else {
//           setState(() {
//             errorMessage = 'API Error';
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load exchange rates';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Network error: ${e.toString()}';
//         isLoading = false;
//       });
//     }
//   }
  
//   void convertFromTo() {
//     if (exchangeRates.isEmpty || fromController.text.isEmpty) {
//       toController.text = '';
//       return;
//     }
    
//     try {
//       double amount = double.parse(fromController.text);
      
//       // Direct conversion as we now have rates based on fromCurrency
//       double conversionRate = exchangeRates[toCurrency] ?? 1.0;
//       double result = amount * conversionRate;
      
//       // Format result to 2 decimal places
//       toController.text = result.toStringAsFixed(2);
//     } catch (e) {
//       toController.text = '';
//     }
//   }
  
//   void swapCurrencies() {
//     setState(() {
//       String tempCurrency = fromCurrency;
//       fromCurrency = toCurrency;
//       toCurrency = tempCurrency;
      
//       // Fetch new rates when base currency changes
//       fetchExchangeRates().then((_) {
//         // Handle text swap after rates are updated
//         String tempValue = fromController.text;
//         fromController.text = toController.text;
//         toController.text = tempValue;
//       });
//     });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(  // Added ScrollView to fix overflow
//             child: Column(
//               children: [
//                 // App header with title and refresh button
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: 48,
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF2D3748),
//                             borderRadius: BorderRadius.circular(24),
//                           ),
//                           child: const Icon(
//                             Icons.account_balance_wallet,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         const Text(
//                           'Currency Converter',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.refresh,
//                         color: Colors.white,
//                       ),
//                       onPressed: fetchExchangeRates,
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 40),
                
//                 // From currency field
//                 Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2D3748),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextField(
//                         controller: fromController,
//                         style: const TextStyle(
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//                         ],
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.zero,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: fromCurrency,
//                           dropdownColor: const Color(0xFF2D3748),
//                           style: const TextStyle(
//                             color: Colors.white,
//                           ),
//                           icon: const Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Colors.white,
//                           ),
//                           onChanged: (String? newValue) {
//                             if (newValue != null && newValue != fromCurrency) {
//                               setState(() {
//                                 fromCurrency = newValue;
//                                 // Need to fetch new rates when base currency changes
//                                 fetchExchangeRates();
//                               });
//                             }
//                           },
//                           items: currencyNames.entries
//                               .map<DropdownMenuItem<String>>((entry) {
//                             return DropdownMenuItem<String>(
//                               value: entry.key,
//                               child: Text('${entry.key} - ${entry.value}'),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(height: 16),
                
//                 // Swap button
//                 IconButton(
//                   icon: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF2D3748),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Icon(
//                       Icons.swap_vert,
//                       color: Colors.white,
//                     ),
//                   ),
//                   onPressed: swapCurrencies,
//                 ),
                
//                 const SizedBox(height: 16),
                
//                 // To currency field
//                 Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2D3748),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextField(
//                         controller: toController,
//                         style: const TextStyle(
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         readOnly: true,
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.zero,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: toCurrency,
//                           dropdownColor: const Color(0xFF2D3748),
//                           style: const TextStyle(
//                             color: Colors.white,
//                           ),
//                           icon: const Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Colors.white,
//                           ),
//                           onChanged: (String? newValue) {
//                             if (newValue != null && newValue != toCurrency) {
//                               setState(() {
//                                 toCurrency = newValue;
//                                 convertFromTo();
//                               });
//                             }
//                           },
//                           items: currencyNames.entries
//                               .map<DropdownMenuItem<String>>((entry) {
//                             return DropdownMenuItem<String>(
//                               value: entry.key,
//                               child: Text('${entry.key} - ${entry.value}'),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(height: 24),
                
//                 // Conversion rate display
//                 if (!isLoading && errorMessage.isEmpty)
//                   Text(
//                     '1 $fromCurrency = ${(exchangeRates[toCurrency] ?? 0).toStringAsFixed(4)} $toCurrency',
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
                
//                 if (isLoading)
//                   const CircularProgressIndicator(
//                     color: Colors.white70,
//                   ),
                  
//                 if (errorMessage.isNotEmpty)
//                   Text(
//                     errorMessage,
//                     style: const TextStyle(
//                       color: Colors.red,
//                       fontSize: 16,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  // API Constants
  static const String API_KEY = '2d82e3c4e4d64c7aa0c8c70a0b89795d';
  static const String API_URL = 'https://open.er-api.com/v6/latest/';
  
  // Exchange rates data
  Map<String, dynamic> exchangeRates = {};
  bool isLoading = true;
  String errorMessage = '';
  
  // Currency selection
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  
  // Amount controllers
  final TextEditingController fromController = TextEditingController(text: '100');
  final TextEditingController toController = TextEditingController(text: '');
  
  // Theme mode
  bool isDarkMode = true;
  
  // Currency names and symbols
  final Map<String, String> currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'INR': 'Indian Rupee',
  };

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
    fromController.addListener(convertFromTo);
  }
  
  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  Future<void> fetchExchangeRates() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    
    try {
      final response = await http.get(
        Uri.parse('$API_URL$fromCurrency?apikey=$API_KEY'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['result'] == 'success') {
          setState(() {
            exchangeRates = data['rates'];
            isLoading = false;
            // Calculate initial conversion
            convertFromTo();
          });
        } else {
          setState(() {
            errorMessage = 'API Error';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load exchange rates';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: ${e.toString()}';
        isLoading = false;
      });
    }
  }
  
  void convertFromTo() {
    if (exchangeRates.isEmpty || fromController.text.isEmpty) {
      toController.text = '';
      return;
    }
    
    try {
      double amount = double.parse(fromController.text);
      
      // Direct conversion as we now have rates based on fromCurrency
      double conversionRate = exchangeRates[toCurrency] ?? 1.0;
      double result = amount * conversionRate;
      
      // Format result to 2 decimal places
      toController.text = result.toStringAsFixed(2);
    } catch (e) {
      toController.text = '';
    }
  }
  
  void swapCurrencies() {
    setState(() {
      String tempCurrency = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = tempCurrency;
      
      // Fetch new rates when base currency changes
      fetchExchangeRates().then((_) {
        // Handle text swap after rates are updated
        String tempValue = fromController.text;
        fromController.text = toController.text;
        toController.text = tempValue;
      });
    });
  }
  
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Spotify colors
    final Color backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDarkMode ? const Color(0xFF282828) : const Color(0xFFE9E9E9);
    final Color primaryColor = const Color(0xFF1DB954); // Spotify green
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: backgroundColor,
                elevation: 0,
                floating: true,
                pinned: false,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.currency_exchange,
                    color: isDarkMode ? Colors.black : Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  'Currency Converter',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                actions: [

                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: textColor,
                    ),
                    onPressed: fetchExchangeRates,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // From currency card
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: fromController,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              suffixText: fromCurrency,
                              suffixStyle: TextStyle(
                                fontSize: 24,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: fromCurrency,
                                dropdownColor: isDarkMode ? const Color(0xFF333333) : const Color(0xFFD9D9D9),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: textColor,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null && newValue != fromCurrency) {
                                    setState(() {
                                      fromCurrency = newValue;
                                      fetchExchangeRates();
                                    });
                                  }
                                },
                                items: currencyNames.entries
                                    .map<DropdownMenuItem<String>>((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text('${entry.key} - ${entry.value}'),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Swap button centered
                    Center(
                      child: GestureDetector(
                        onTap: swapCurrencies,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.swap_vert,
                            color: isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // To currency card
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: toController,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              suffixText: toCurrency,
                              suffixStyle: TextStyle(
                                fontSize: 24,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: toCurrency,
                                dropdownColor: isDarkMode ? const Color(0xFF333333) : const Color(0xFFD9D9D9),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: textColor,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null && newValue != toCurrency) {
                                    setState(() {
                                      toCurrency = newValue;
                                      convertFromTo();
                                    });
                                  }
                                },
                                items: currencyNames.entries
                                    .map<DropdownMenuItem<String>>((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text('${entry.key} - ${entry.value}'),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Conversion rate display
                    if (!isLoading && errorMessage.isEmpty)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.black26 : Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '1 $fromCurrency = ${(exchangeRates[toCurrency] ?? 0).toStringAsFixed(4)} $toCurrency',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 3,
                        ),
                      ),
                      
                    if (errorMessage.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      
                    // Credit text
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        'Data refreshed ' + (isLoading ? 'updating...' : 'just now'),
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}