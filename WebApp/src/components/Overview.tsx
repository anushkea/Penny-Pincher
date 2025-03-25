import React from 'react';
// Fix imports by using named imports from lucide-react
import { DollarSign, TrendingUp as TrendingUpIcon, TrendingDown as TrendingDownIcon } from 'lucide-react';
import { Transaction } from '../types';

interface Props {
  transactions: Transaction[];
}

export default function Overview({ transactions }: Props) {
  const calculateTotals = () => {
    return transactions.reduce(
      (acc, transaction) => {
        if (transaction.type === 'income') {
          acc.income += transaction.amount;
        } else {
          acc.expenses += transaction.amount;
        }
        acc.balance = acc.income - acc.expenses;
        return acc;
      },
      { income: 0, expenses: 0, balance: 0 }
    );
  };

  const { balance, income, expenses } = calculateTotals();

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
      <div className="bg-gray-800 p-6 rounded-lg">
        <div className="flex items-center justify-between">
          <h3 className="text-gray-400">Total Balance</h3>
          <DollarSign className="h-6 w-6 text-blue-500" />
        </div>
        <p className="text-2xl font-bold text-white mt-2">₹{balance.toFixed(2)}</p>
        <p className="text-sm text-gray-400 mt-1">You're doing great!</p>
      </div>

      <div className="bg-gray-800 p-6 rounded-lg">
        <div className="flex items-center justify-between">
          <h3 className="text-gray-400">Total Income</h3>
          <TrendingUpIcon className="h-6 w-6 text-green-500" />
        </div>
        <p className="text-2xl font-bold text-white mt-2">₹{income.toFixed(2)}</p>
        <p className="text-sm text-gray-400 mt-1">Total earnings this period</p>
      </div>

      <div className="bg-gray-800 p-6 rounded-lg">
        <div className="flex items-center justify-between">
          <h3 className="text-gray-400">Total Expenses</h3>
          <TrendingDownIcon className="h-6 w-6 text-red-500" />
        </div>
        <p className="text-2xl font-bold text-white mt-2">₹{expenses.toFixed(2)}</p>
        <p className="text-sm text-gray-400 mt-1">Total expenses this period</p>
      </div>
    </div>
  );
}