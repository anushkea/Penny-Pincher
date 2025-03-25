import { Download } from 'lucide-react';
import { Transaction } from '../types';

interface Props {
  transactions: Transaction[];
}

export default function TransactionHistory({ transactions }: Props) {
  const downloadPDF = () => {
    // Implementation for PDF download
    console.log('Downloading PDF...');
  };

  return (
    <div className="bg-gray-800 p-6 rounded-lg">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-bold text-white">Transaction History</h2>
        <button
          onClick={downloadPDF}
          className="flex items-center space-x-1 text-gray-400 hover:text-white transition-colors"
        >
          <Download className="h-5 w-5" />
          <span>Download PDF</span>
        </button>
      </div>

      <div className="space-y-4">
        {transactions.map((transaction) => (
          <div
            key={transaction.id}
            className="flex items-center justify-between p-4 bg-gray-700 rounded-lg"
          >
            <div>
              <p className="font-medium text-white">{transaction.description}</p>
              <p className="text-sm text-gray-400">{transaction.category}</p>
              <p className="text-xs text-gray-400">{transaction.date}</p>
            </div>
            <div
              className={`text-lg font-bold ${
                transaction.type === 'income' ? 'text-green-500' : 'text-red-500'
              }`}
            >
              {transaction.type === 'income' ? '+' : '-'}₹{transaction.amount.toFixed(2)}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}