import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SplitPaymentsPage extends StatefulWidget {
  const SplitPaymentsPage({Key? key}) : super(key: key);

  @override
  State<SplitPaymentsPage> createState() => _SplitPaymentsPageState();
}

class _SplitPaymentsPageState extends State<SplitPaymentsPage> {
  final TextEditingController _paymentTitleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _participantNameController =
      TextEditingController();
  final TextEditingController _participantAmountController =
      TextEditingController();

  // List to hold all payments
  List<PaymentCard> _payments = [];
  int _currentCardIndex = 0;

  // Spotify theme colors
  final Color spotifyBlack = const Color(0xFF121212);
  final Color spotifyDarkGrey = const Color(0xFF181818);
  final Color spotifyGrey = const Color(0xFF282828);
  final Color spotifyLightGrey = const Color(0xFF535353);
  final Color spotifyGreen = const Color(0xFF1DB954);
  final Color spotifyLightGreen = const Color(0xFF1ED760);
  final Color spotifyWhite = const Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final paymentsJson = prefs.getStringList('payments') ?? [];

    setState(() {
      _payments = paymentsJson
          .map((json) => PaymentCard.fromJson(jsonDecode(json)))
          .toList();

      // Sort payments to show pinned ones first
      _payments.sort((a, b) => b.isPinned ? 1 : (a.isPinned ? -1 : 0));
    });
  }

  Future<void> _savePayments() async {
    final prefs = await SharedPreferences.getInstance();
    final paymentsJson =
        _payments.map((payment) => jsonEncode(payment.toJson())).toList();

    await prefs.setStringList('payments', paymentsJson);
  }

  void _addNewPayment() {
    if (_paymentTitleController.text.isEmpty ||
        _amountController.text.isEmpty) {
      return;
    }

    final String title = _paymentTitleController.text;
    final double amount = double.tryParse(_amountController.text) ?? 0.0;

    setState(() {
      _payments.add(PaymentCard(
        title: title,
        totalAmount: amount,
        participants: [],
      ));

      _paymentTitleController.clear();
      _amountController.clear();
    });

    _savePayments();
  }

  void _addParticipant(int cardIndex) {
    if (_participantNameController.text.isEmpty ||
        _participantAmountController.text.isEmpty) {
      return;
    }

    final String name = _participantNameController.text;
    final double amount =
        double.tryParse(_participantAmountController.text) ?? 0.0;

    setState(() {
      _payments[cardIndex].participants.add(
            Participant(name: name, amount: amount),
          );

      _participantNameController.clear();
      _participantAmountController.clear();
    });

    _savePayments();
  }

  void _deletePayment(int index) {
    setState(() {
      _payments.removeAt(index);
      if (_currentCardIndex >= _payments.length && _payments.isNotEmpty) {
        _currentCardIndex = _payments.length - 1;
      }
    });

    _savePayments();
  }

  void _deleteParticipant(int cardIndex, int participantIndex) {
    setState(() {
      _payments[cardIndex].participants.removeAt(participantIndex);
    });

    _savePayments();
  }

  void _duplicatePayment(int index) {
    final payment = _payments[index];
    setState(() {
      _payments.add(PaymentCard(
        title: "${payment.title} (Copy)",
        totalAmount: payment.totalAmount,
        participants: payment.participants
            .map((p) => Participant(name: p.name, amount: p.amount))
            .toList(),
      ));
    });

    _savePayments();
  }

  void _togglePinPayment(int index) {
    setState(() {
      _payments[index].isPinned = !_payments[index].isPinned;

      // Sort payments to show pinned ones first
      _payments.sort((a, b) => b.isPinned ? 1 : (a.isPinned ? -1 : 0));

      // Find the new index of the payment
      for (int i = 0; i < _payments.length; i++) {
        if (_payments[i].title == _payments[index].title) {
          _currentCardIndex = i;
          break;
        }
      }
    });

    _savePayments();
  }

  void _splitEvenly(int cardIndex) {
    showDialog(
      context: context,
      builder: (context) => _buildSplitEvenlyDialog(cardIndex),
    );
  }

  Widget _buildSplitEvenlyDialog(int cardIndex) {
    int selectedMembers = 2;
    List<TextEditingController> nameControllers =
        List.generate(9, (_) => TextEditingController());

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: spotifyDarkGrey,
          title: Text(
            'Split Evenly',
            style: TextStyle(color: spotifyWhite, fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Number of members:',
                    style: TextStyle(color: spotifyWhite.withOpacity(0.8), fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        final number = index + 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedMembers = number;
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: selectedMembers == number
                                  ? spotifyGreen
                                  : spotifyLightGrey,
                              radius: 16,
                              child: Text(
                                '$number',
                                style: TextStyle(
                                  color: selectedMembers == number
                                      ? spotifyWhite
                                      : spotifyWhite.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter names:',
                    style: TextStyle(color: spotifyWhite.withOpacity(0.8), fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: spotifyGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: selectedMembers,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: nameControllers[index],
                            style: TextStyle(
                                color: spotifyWhite, fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Member ${index + 1}',
                              hintStyle: TextStyle(
                                  color: spotifyWhite.withOpacity(0.5), fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: spotifyLightGrey),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: spotifyWhite.withOpacity(0.7), fontSize: 12),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Calculate split amount
                final splitAmount =
                    _payments[cardIndex].totalAmount / selectedMembers;

                // Clear existing participants
                _payments[cardIndex].participants.clear();

                // Add new participants
                for (int i = 0; i < selectedMembers; i++) {
                  if (nameControllers[i].text.isNotEmpty) {
                    _payments[cardIndex].participants.add(
                          Participant(
                            name: nameControllers[i].text,
                            amount: splitAmount,
                          ),
                        );
                  } else {
                    _payments[cardIndex].participants.add(
                          Participant(
                            name: 'Member ${i + 1}',
                            amount: splitAmount,
                          ),
                        );
                  }
                }

                _savePayments();
                Navigator.pop(context);
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: spotifyGreen,
                foregroundColor: spotifyWhite,
              ),
              child: const Text('Save', style: TextStyle(fontSize: 12)),
            ),
          ],
        );
      },
    );
  }

  void _nextCard() {
    if (_payments.isNotEmpty && _currentCardIndex < _payments.length - 1) {
      setState(() {
        _currentCardIndex++;
      });
    }
  }

  void _previousCard() {
    if (_payments.isNotEmpty && _currentCardIndex > 0) {
      setState(() {
        _currentCardIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: spotifyBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Logo
              _buildHeader(),
              const SizedBox(height: 16),

              // New Payment Section
              _buildNewPaymentSection(),
              const SizedBox(height: 24),

              // Payment Cards
              Expanded(
                child: _payments.isEmpty
                    ? _buildEmptyState()
                    : _buildPaymentCardsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: spotifyGreen.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            Icons.payments_outlined,
            color: spotifyGreen,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Split Payments',
          style: TextStyle(
            color: spotifyWhite,
            fontSize: 20, // Increased font size for header
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNewPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: spotifyDarkGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Payment',
            style: TextStyle(
              color: spotifyWhite,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    controller: _paymentTitleController,
                    style: TextStyle(color: spotifyWhite, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Payment Title',
                      hintStyle:
                          TextStyle(color: spotifyWhite.withOpacity(0.5), fontSize: 12),
                      filled: true,
                      fillColor: spotifyGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    controller: _amountController,
                    style: TextStyle(color: spotifyWhite, fontSize: 12),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      hintStyle:
                          TextStyle(color: spotifyWhite.withOpacity(0.5), fontSize: 12),
                      filled: true,
                      fillColor: spotifyGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                height: 36,
                child: ElevatedButton(
                  onPressed: _addNewPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: spotifyGreen,
                    foregroundColor: spotifyWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Add', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payments_outlined,
            size: 48,
            color: spotifyLightGrey,
          ),
          const SizedBox(height: 16),
          Text(
            'No payments added yet',
            style: TextStyle(
              color: spotifyWhite.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCardsSection() {
    return ListView.builder(
      itemCount: _payments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildPaymentCard(_payments[index], index),
        );
      },
    );
  }

  Widget _buildPaymentCard(PaymentCard card, int cardIndex) {
    // Calculate the percentage paid
    double totalPaid = card.participants
        .fold(0, (sum, participant) => sum + participant.amount);
    double percentagePaid = card.totalAmount > 0
        ? (totalPaid / card.totalAmount * 100).clamp(0, 100)
        : 0;

    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      // Remove fixed height and let content determine it
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: spotifyDarkGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: card.isPinned ? spotifyGreen : spotifyLightGrey,
          width: card.isPinned ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Column takes minimum space needed
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Title
          Text(
            card.title,
            style: TextStyle(
              color: spotifyWhite,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Card Actions
          Row(
            children: [
              InkWell(
                onTap: () => _splitEvenly(cardIndex),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: spotifyGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calculate,
                        color: spotifyGreen,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Split',
                        style: TextStyle(
                          color: spotifyGreen,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _togglePinPayment(cardIndex),
                icon: Icon(
                  card.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: card.isPinned ? spotifyGreen : spotifyLightGrey,
                  size: 16,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                tooltip: 'Pin',
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _duplicatePayment(cardIndex),
                icon: Icon(Icons.copy_outlined,
                    color: spotifyLightGrey, size: 16),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                tooltip: 'Duplicate',
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _deletePayment(cardIndex),
                icon: Icon(Icons.delete_outline,
                    color: spotifyLightGrey, size: 16),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total Amount and Progress Indicator
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      color: spotifyWhite.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '₹${card.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: spotifyWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: percentagePaid / 100,
                      backgroundColor: spotifyGrey,
                      valueColor: AlwaysStoppedAnimation<Color>(spotifyGreen),
                      strokeWidth: 5,
                    ),
                  ),
                  Text(
                    '${percentagePaid.toInt()}%',
                    style: TextStyle(
                      color: spotifyWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Divider
          Divider(color: spotifyLightGrey, height: 1),
          const SizedBox(height: 8),

          // Participants List - Wrap in Flexible to take remaining space
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: ListView.builder(
                shrinkWrap: true, // ListView takes only needed space
                itemCount: card.participants.length + 1,
                itemBuilder: (context, index) {
                  if (index == card.participants.length) {
                    return _buildAddParticipantRow(cardIndex);
                  } else {
                    return _buildParticipantRow(card, cardIndex, index);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantRow(
      PaymentCard card, int cardIndex, int participantIndex) {
    final participant = card.participants[participantIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: spotifyGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: spotifyWhite,
              size: 10,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              participant.name,
              style: TextStyle(
                color: spotifyWhite,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 40,
            child: Text(
              '${participant.amount.toStringAsFixed(0)}',
              style: TextStyle(
                color: spotifyWhite.withOpacity(0.7),
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            width: 20,
            child: IconButton(
              onPressed: () => _deleteParticipant(cardIndex, participantIndex),
              icon: Icon(Icons.delete_outline,
                  color: spotifyLightGrey, size: 12),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddParticipantRow(int cardIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: spotifyGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: spotifyLightGrey,
              size: 10,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _participantNameController,
              style: TextStyle(color: spotifyWhite, fontSize: 11),
              decoration: InputDecoration(
                hintText: 'Add participant',
                hintStyle: TextStyle(color: spotifyWhite.withOpacity(0.5), fontSize: 11),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: TextField(
              controller: _participantAmountController,
              style: TextStyle(color: spotifyWhite, fontSize: 11),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'Amt',
                hintStyle: TextStyle(color: spotifyWhite.withOpacity(0.5), fontSize: 11),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          SizedBox(
            width: 20,
            child: IconButton(
              onPressed: () => _addParticipant(cardIndex),
              icon: Icon(Icons.add_circle_outline,
                  color: spotifyLightGrey, size: 12),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _paymentTitleController.dispose();
    _amountController.dispose();
    _participantNameController.dispose();
    _participantAmountController.dispose();
    super.dispose();
  }
}

// Models
class PaymentCard {
  final String title;
  final double totalAmount;
  final List<Participant> participants;
  bool isPinned;

  PaymentCard({
    required this.title,
    required this.totalAmount,
    required this.participants,
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'totalAmount': totalAmount,
      'participants': participants.map((p) => p.toJson()).toList(),
      'isPinned': isPinned,
    };
  }

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      title: json['title'],
      totalAmount: json['totalAmount'],
      participants: (json['participants'] as List)
          .map((p) => Participant.fromJson(p))
          .toList(),
      isPinned: json['isPinned'] ?? false,
    );
  }
}

class Participant {
  final String name;
  final double amount;

  Participant({
    required this.name,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      name: json['name'],
      amount: json['amount'],
    );
  }
}