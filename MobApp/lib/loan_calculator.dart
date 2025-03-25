import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanCalculatorPage extends StatefulWidget {
  @override
  _LoanCalculatorPageState createState() => _LoanCalculatorPageState();
}

class Loan {
  String title;
  double principal;
  double rate;
  int term;
  double monthlyEMI;

  Loan({
    required this.title,
    required this.principal,
    required this.rate,
    required this.term,
    this.monthlyEMI = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'principal': principal,
      'rate': rate,
      'term': term,
      'monthlyEMI': monthlyEMI,
    };
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      title: json['title'],
      principal: json['principal'],
      rate: json['rate'],
      term: json['term'],
      monthlyEMI: json['monthlyEMI'],
    );
  }
}

class _LoanCalculatorPageState extends State<LoanCalculatorPage> {
  final _titleController = TextEditingController();
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _termController = TextEditingController();
  List<Loan> loans = [];
  bool _isViewingLoans = false;

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  _loadLoans() async {
    final prefs = await SharedPreferences.getInstance();
    final loansJsonStrings = prefs.getStringList('loans') ?? [];
    
    setState(() {
      loans = loansJsonStrings.map((loanStr) {
        final parts = loanStr.split('|');
        return Loan(
          title: parts[0],
          principal: double.parse(parts[1]),
          rate: double.parse(parts[2]),
          term: int.parse(parts[3]),
          monthlyEMI: double.parse(parts[4]),
        );
      }).toList();
    });
  }

  _saveLoans() async {
    final prefs = await SharedPreferences.getInstance();
    final loansJsonStrings = loans
        .map((loan) =>
            '${loan.title}|${loan.principal}|${loan.rate}|${loan.term}|${loan.monthlyEMI}')
        .toList();
    await prefs.setStringList('loans', loansJsonStrings);
  }

  double _calculateEMI(double principal, double rate, int term) {
    double monthlyRate = rate / 12 / 100;
    int months = term * 12;
    double emi =
        principal * monthlyRate * pow((1 + monthlyRate), months) / (pow((1 + monthlyRate), months) - 1);
    return emi;
  }

  void _saveLoan() {
    if (_titleController.text.isEmpty ||
        _principalController.text.isEmpty ||
        _rateController.text.isEmpty ||
        _termController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    double principal = double.parse(_principalController.text);
    double rate = double.parse(_rateController.text);
    int term = int.parse(_termController.text);
    double emi = _calculateEMI(principal, rate, term);

    Loan newLoan = Loan(
      title: _titleController.text,
      principal: principal,
      rate: rate,
      term: term,
      monthlyEMI: emi,
    );

    setState(() {
      loans.add(newLoan);
      _isViewingLoans = true;
    });

    _saveLoans();

    // Clear the form
    _titleController.clear();
    _principalController.clear();
    _rateController.clear();
    _termController.clear();
  }

  void _deleteLoan(int index) {
    setState(() {
      loans.removeAt(index);
    });
    _saveLoans();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loan deleted'),
        backgroundColor: Color(0xFF1DB954),
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    final spotifyGreen = Color(0xFF1DB954);
    final spotifyDarkGrey = Color(0xFF121212);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: spotifyDarkGrey,
          title: Text(
            'Delete Loan',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${loans[index].title}"?',
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[400]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: spotifyGreen),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteLoan(index);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Spotify theme colors
    final spotifyBlack = Color(0xFF191414);
    final spotifyDarkGrey = Color(0xFF121212);
    final spotifyGreen = Color(0xFF1DB954);
    final spotifyLightGreen = Color(0xFF1ED760);
    final spotifyCardGrey = Color(0xFF212121);
    final spotifyDividerGrey = Color(0xFF333333);

    return Scaffold(
      backgroundColor: spotifyBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calculate,
                    color: spotifyGreen,
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Loan Calculator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Fixed: Using Expanded to prevent overflow in Row
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.list),
                        label: Text('View Loans'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isViewingLoans
                              ? spotifyGreen
                              : Color(0xFF2E2E2E),
                          foregroundColor: _isViewingLoans
                              ? Colors.black
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            _isViewingLoans = true;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.calculate),
                        label: Text('Calculate Loan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isViewingLoans
                              ? Color(0xFF2E2E2E)
                              : spotifyGreen,
                          foregroundColor: _isViewingLoans
                              ? Colors.white
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            _isViewingLoans = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child: _isViewingLoans
                    ? _buildLoansList(spotifyCardGrey, spotifyDividerGrey, spotifyGreen)
                    : _buildCalculatorForm(spotifyCardGrey, spotifyGreen),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorForm(Color spotifyCardGrey, Color spotifyGreen) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loan Title',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Enter loan title',
              filled: true,
              fillColor: spotifyCardGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: spotifyGreen, width: 1),
              ),
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Principal',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _principalController,
            decoration: InputDecoration(
              hintText: 'Principal Amount',
              filled: true,
              fillColor: spotifyCardGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: spotifyGreen, width: 1),
              ),
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Annual Rate (%)',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _rateController,
            decoration: InputDecoration(
              hintText: 'Interest Rate',
              filled: true,
              fillColor: spotifyCardGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: spotifyGreen, width: 1),
              ),
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Term (Years)',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _termController,
            decoration: InputDecoration(
              hintText: 'Tenure',
              filled: true,
              fillColor: spotifyCardGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: spotifyGreen, width: 1),
              ),
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveLoan,
              style: ElevatedButton.styleFrom(
                backgroundColor: spotifyGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Save Loan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoansList(Color spotifyCardGrey, Color spotifyDividerGrey, Color spotifyGreen) {
    if (loans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calculate_outlined,
              color: Colors.grey[500],
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No loans saved yet',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Calculate a loan to get started',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: loans.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(loans[index].title + index.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _deleteLoan(index);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: spotifyCardGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: spotifyDividerGrey,
                width: 1,
              ),
            ),
            child: ExpansionTile(
              leading: Icon(
                Icons.calculate,
                color: spotifyGreen,
              ),
              title: Text(
                loans[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                '₹${loans[index].monthlyEMI.toStringAsFixed(2)} / month',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              collapsedBackgroundColor: spotifyCardGrey,
              backgroundColor: Color(0xFF282828),
              iconColor: spotifyGreen,
              collapsedIconColor: Colors.grey[400],
              childrenPadding: EdgeInsets.all(16),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red[300],
                    ),
                    onPressed: () {
                      _showDeleteConfirmation(index);
                    },
                  ),
                  Icon(Icons.expand_more, color: Colors.grey[400]),
                ],
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Principal',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '₹${loans[index].principal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interest Rate',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${loans[index].rate.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Term',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${loans[index].term} years',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly EMI:',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹${loans[index].monthlyEMI.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: spotifyGreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Total Payment: ₹${(loans[index].monthlyEMI * loans[index].term * 12).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    Text(
                      'Total Interest: ₹${(loans[index].monthlyEMI * loans[index].term * 12 - loans[index].principal).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showDeleteConfirmation(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 8),
                        Text(
                          'Delete Loan',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double pow(double x, int y) {
    double result = 1.0;
    for (int i = 0; i < y; i++) {
      result *= x;
    }
    return result;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _principalController.dispose();
    _rateController.dispose();
    _termController.dispose();
    super.dispose();
  }
}