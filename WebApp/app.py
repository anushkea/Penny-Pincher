from flask import Flask, request, jsonify
import json
from datetime import datetime
import os

app = Flask(__name__)

# Ensure JSON files exist
def ensure_json_files():
    files = ['transactions.json', 'splitpayments.json', 'savings.json', 'loans.json']
    for file in files:
        if not os.path.exists(file):
            with open(file, 'w') as f:
                json.dump([], f)

ensure_json_files()

# Helper functions
def read_json(file):
    with open(file, 'r') as f:
        return json.load(f)

def write_json(file, data):
    with open(file, 'w') as f:
        json.dump(data, f, indent=2)

# Routes for transactions
@app.route('/api/transactions', methods=['GET'])
def get_transactions():
    return jsonify(read_json('transactions.json'))

@app.route('/api/transactions', methods=['POST'])
def add_transaction():
    transaction = request.json
    transactions = read_json('transactions.json')
    transaction['id'] = str(len(transactions) + 1)
    transaction['date'] = datetime.now().isoformat()
    transactions.append(transaction)
    write_json('transactions.json', transactions)
    return jsonify(transaction)

# Routes for split payments
@app.route('/api/splitpayments', methods=['GET'])
def get_splitpayments():
    return jsonify(read_json('splitpayments.json'))

@app.route('/api/splitpayments', methods=['POST'])
def add_splitpayment():
    payment = request.json
    payments = read_json('splitpayments.json')
    payment['id'] = str(len(payments) + 1)
    payments.append(payment)
    write_json('splitpayments.json', payments)
    return jsonify(payment)

@app.route('/api/splitpayments/<id>', methods=['PUT'])
def update_splitpayment(id):
    payment = request.json
    payments = read_json('splitpayments.json')
    for i, p in enumerate(payments):
        if p['id'] == id:
            payments[i] = payment
            write_json('splitpayments.json', payments)
            return jsonify(payment)
    return jsonify({'error': 'Payment not found'}), 404

@app.route('/api/splitpayments/<id>', methods=['DELETE'])
def delete_splitpayment(id):
    payments = read_json('splitpayments.json')
    payments = [p for p in payments if p['id'] != id]
    write_json('splitpayments.json', payments)
    return jsonify({'status': 'success'})

# Routes for savings
@app.route('/api/savings', methods=['GET'])
def get_savings():
    return jsonify(read_json('savings.json'))

@app.route('/api/savings', methods=['POST'])
def add_saving():
    saving = request.json
    savings = read_json('savings.json')
    saving['id'] = str(len(savings) + 1)
    savings.append(saving)
    write_json('savings.json', savings)
    return jsonify(saving)

@app.route('/api/savings/<id>', methods=['PUT'])
def update_saving(id):
    saving = request.json
    savings = read_json('savings.json')
    for i, s in enumerate(savings):
        if s['id'] == id:
            savings[i] = saving
            write_json('savings.json', savings)
            return jsonify(saving)
    return jsonify({'error': 'Saving not found'}), 404

@app.route('/api/savings/<id>', methods=['DELETE'])
def delete_saving(id):
    savings = read_json('savings.json')
    savings = [s for s in savings if s['id'] != id]
    write_json('savings.json', savings)
    return jsonify({'status': 'success'})

# Routes for loans
@app.route('/api/loans', methods=['GET'])
def get_loans():
    return jsonify(read_json('loans.json'))

@app.route('/api/loans', methods=['POST'])
def add_loan():
    loan = request.json
    loans = read_json('loans.json')
    loan['id'] = str(len(loans) + 1)
    loans.append(loan)
    write_json('loans.json', loans)
    return jsonify(loan)

@app.route('/api/loans/<id>', methods=['DELETE'])
def delete_loan(id):
    loans = read_json('loans.json')
    loans = [l for l in loans if l['id'] != id]
    write_json('loans.json', loans)
    return jsonify({'status': 'success'})

# Route for help messages
@app.route('/api/help', methods=['POST'])
def send_help_message():
    message = request.json
    # Here you would implement email sending logic
    # For now, we'll just return success
    return jsonify({"status": "success"})

if __name__ == '__main__':
    app.run(debug=True)