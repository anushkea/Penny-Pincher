import React, { useState } from 'react';
import { Calendar, Plus } from 'lucide-react';
import { Transaction } from '../types';

interface Props {
  onAddTransaction: (transaction: Omit<Transaction, 'id'>) => void;
}

export default function TransactionForm({ onAddTransaction }: Props) {
  const [type, setType] = useState<'income' | 'expense'>('income');
  const [amount, setAmount] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState('');
  const [date, setDate] = useState(new Date().toISOString().split('T')[0]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate amount before submitting
    const parsedAmount = parseFloat(amount);
    if (isNaN(parsedAmount) || parsedAmount <= 0) {
      alert('Please enter a valid amount');
      return;
    }
    
    onAddTransaction({
      type,
      amount: parsedAmount,
      description,
      category,
      date,
    });
    
    // Reset form after submission
    setAmount('');
    setDescription('');
    setCategory('');
  };

  return (
    <div className="bg-gray-800 p-6 rounded-lg">
      <div className="flex space-x-2 mb-4">
        <button
          type="button"
          className={`flex-1 py-2 rounded-md transition-colors ${
            type === 'income'
              ? 'bg-green-600 text-white'
              : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
          }`}
          onClick={() => setType('income')}
        >
          Income
        </button>
        <button
          type="button"
          className={`flex-1 py-2 rounded-md transition-colors ${
            type === 'expense'
              ? 'bg-red-600 text-white'
              : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
          }`}
          onClick={() => setType('expense')}
        >
          Expense
        </button>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-gray-400 mb-1">Amount</label>
          <input
            type="number"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            className="w-full bg-gray-700 text-white rounded p-2"
            placeholder="Enter amount"
            step="0.01"
            min="0"
            required
          />
        </div>

        <div>
          <label className="block text-gray-400 mb-1">Description</label>
          <input
            type="text"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            className="w-full bg-gray-700 text-white rounded p-2"
            placeholder="Enter description"
            required
          />
        </div>

        <div>
          <label className="block text-gray-400 mb-1">Category</label>
          <input
            type="text"
            value={category}
            onChange={(e) => setCategory(e.target.value)}
            className="w-full bg-gray-700 text-white rounded p-2"
            placeholder="Enter category"
            required
          />
        </div>

        <div>
          <label className="block text-gray-400 mb-1">Date</label>
          <div className="relative">
            <input
              type="date"
              value={date}
              onChange={(e) => setDate(e.target.value)}
              className="w-full bg-gray-700 text-white rounded p-2 pr-10"
              required
            />
            <Calendar className="absolute right-3 top-2.5 h-5 w-5 text-gray-400" />
          </div>
        </div>

        <button
          type="submit"
          className="w-full bg-purple-600 text-white py-2 rounded hover:bg-purple-700 transition-colors flex items-center justify-center space-x-2"
        >
          <Plus className="h-5 w-5" />
          <span>Add Transaction</span>
        </button>
      </form>
    </div>
  );
}