
import React, { useState } from 'react';
import { Target, Plus, Trash2 } from 'lucide-react';
import { SavingsGoal } from '../types';

interface Props {
  savings: SavingsGoal[];
  onAddSaving: (saving: Omit<SavingsGoal, 'id'>) => void;
  onUpdateSaving: (saving: SavingsGoal) => void;
  onDeleteSaving: (id: string) => void;
}

export default function SavingsGoals({
  savings,
  onAddSaving,
  onUpdateSaving,
  onDeleteSaving,
}: Props) {
  const [isAdding, setIsAdding] = useState(false);
  const [title, setTitle] = useState('');
  const [targetAmount, setTargetAmount] = useState('');
  const [deadline, setDeadline] = useState('');
  const [icon, setIcon] = useState('💰');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate input
    const parsedAmount = parseFloat(targetAmount);
    if (isNaN(parsedAmount) || parsedAmount <= 0) {
      alert('Please enter a valid target amount');
      return;
    }
    
    onAddSaving({
      title,
      targetAmount: parsedAmount,
      currentAmount: 0,
      deadline,
      icon,
    });
    
    // Reset form and close
    setIsAdding(false);
    setTitle('');
    setTargetAmount('');
    setDeadline('');
    setIcon('💰');
  };

  const addMoney = (id: string) => {
    const saving = savings.find((s) => s.id === id);
    if (!saving) return;

    const amountStr = prompt('Enter amount to add:');
    if (!amountStr) return;
    
    const amount = parseFloat(amountStr);
    if (isNaN(amount) || amount <= 0) {
      alert('Please enter a valid amount');
      return;
    }

    const newAmount = saving.currentAmount + amount;
    if (newAmount > saving.targetAmount) {
      alert('Amount exceeds target!');
      return;
    }

    onUpdateSaving({
      ...saving,
      currentAmount: newAmount,
    });
  };

  // Calculate days left safely
  const calculateDaysLeft = (deadline: string): number => {
    try {
      const deadlineDate = new Date(deadline).getTime();
      const today = new Date().getTime();
      return Math.max(0, Math.ceil((deadlineDate - today) / (1000 * 60 * 60 * 24)));
    } catch (error) {
      return 0;
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-xl font-bold flex items-center">
          <Target className="h-6 w-6 mr-2" />
          Savings Goals
        </h2>
        <button
          type="button"
          onClick={() => setIsAdding(!isAdding)}
          className="bg-purple-600 text-white px-4 py-2 rounded hover:bg-purple-700 transition-colors flex items-center space-x-2"
        >
          <Plus className="h-5 w-5" />
          <span>Add Goal</span>
        </button>
      </div>

      {isAdding && (
        <div className="bg-gray-800 p-6 rounded-lg">
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-gray-400 mb-1">Title</label>
              <input
                type="text"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                className="w-full bg-gray-700 text-white rounded p-2"
                placeholder="Enter goal title"
                required
              />
            </div>

            <div>
              <label className="block text-gray-400 mb-1">Target Amount</label>
              <input
                type="number"
                value={targetAmount}
                onChange={(e) => setTargetAmount(e.target.value)}
                className="w-full bg-gray-700 text-white rounded p-2"
                placeholder="Enter target amount"
                step="0.01"
                min="0"
                required
              />
            </div>

            <div>
              <label className="block text-gray-400 mb-1">Deadline</label>
              <input
                type="date"
                value={deadline}
                onChange={(e) => setDeadline(e.target.value)}
                className="w-full bg-gray-700 text-white rounded p-2"
                required
              />
            </div>

            <div>
              <label className="block text-gray-400 mb-1">Icon</label>
              <select
                value={icon}
                onChange={(e) => setIcon(e.target.value)}
                className="w-full bg-gray-700 text-white rounded p-2"
              >
                <option value="💰">💰 Money</option>
                <option value="🏠">🏠 House</option>
                <option value="🚗">🚗 Car</option>
                <option value="✈️">✈️ Travel</option>
                <option value="📚">📚 Education</option>
                <option value="💻">💻 Tech</option>
              </select>
            </div>

            <div className="flex space-x-4">
              <button
                type="submit"
                className="flex-1 bg-purple-600 text-white py-2 rounded hover:bg-purple-700 transition-colors"
              >
                Create Goal
              </button>
              <button
                type="button"
                onClick={() => setIsAdding(false)}
                className="flex-1 bg-gray-700 text-white py-2 rounded hover:bg-gray-600 transition-colors"
              >
                Cancel
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {savings.map((saving) => {
          const progress = (saving.currentAmount / saving.targetAmount) * 100;
          const daysLeft = calculateDaysLeft(saving.deadline);

          return (
            <div key={saving.id} className="bg-gray-800 p-6 rounded-lg">
              <div className="flex justify-between items-start mb-4">
                <div className="flex items-center space-x-2">
                  <span className="text-2xl">{saving.icon}</span>
                  <h3 className="text-lg font-semibold">{saving.title}</h3>
                </div>
                <div className="flex space-x-2">
                  <button
                    type="button"
                    onClick={() => onDeleteSaving(saving.id)}
                    className="text-red-500 hover:text-red-400"
                  >
                    <Trash2 className="h-5 w-5" />
                  </button>
                </div>
              </div>

              <div className="space-y-4">
                <div>
                  <div className="flex justify-between text-sm text-gray-400 mb-1">
                    <span>Progress</span>
                    <span>{progress.toFixed(1)}%</span>
                  </div>
                  <div className="h-2 bg-gray-700 rounded-full">
                    <div
                      className="h-full bg-purple-600 rounded-full"
                      style={{ width: `${Math.min(100, progress)}%` }}
                    />
                  </div>
                </div>

                <div className="flex justify-between text-sm">
                  <span className="text-gray-400">Current</span>
                  <span>₹{saving.currentAmount.toFixed(2)}</span>
                </div>

                <div className="flex justify-between text-sm">
                  <span className="text-gray-400">Target</span>
                  <span>₹{saving.targetAmount.toFixed(2)}</span>
                </div>

                <div className="flex justify-between text-sm">
                  <span className="text-gray-400">Days Left</span>
                  <span>{daysLeft} days</span>
                </div>

                <button
                  type="button"
                  onClick={() => addMoney(saving.id)}
                  className="w-full bg-purple-600 text-white py-2 rounded hover:bg-purple-700 transition-colors"
                >
                  Add Money
                </button>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}