import React, { useState, useEffect } from 'react';
import SavingsCard from './SavingsCard';
import { Plus } from 'lucide-react';

interface Savings {
  id: string;
  title: string;
  targetAmount: number;
  deadline: string;
}

export default function SavingsSection() {
  const [savings, setSavings] = useState<Savings[]>([]);
  const [title, setTitle] = useState('');
  const [target, setTarget] = useState('');
  const [deadline, setDeadline] = useState('');
  const [icon, setIcon] = useState('💰');

  // Load existing savings from backend on mount
  useEffect(() => {
    (async () => {
      const res = await fetch('/api/savings');
      const data = await res.json();
      setSavings(data);
    })();
  }, []);

  // Update addSavings to perform a POST request to /api/savings
  const addSavings = async () => {
    const newSavingData = {
      title,
      targetAmount: parseFloat(target),
      deadline,
      icon,
      currentAmount: 0
    };
    const res = await fetch('/api/savings', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(newSavingData)
    });
    const saved = await res.json();
    setSavings([...savings, saved]);
    setTitle('');
    setTarget('');
    setDeadline('');
    setIcon('💰');
  };

  return (
    <div className="container mx-auto p-4">
      {/* Container remains on the page, always visible */}
      <div className="bg-gray-800 p-4 rounded-lg shadow-lg mb-4">
        {/* Inline Add Savings form in one unwrapped row */}
        <div className="flex items-center gap-2 whitespace-nowrap">
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Name"
            className="bg-gray-700 text-white rounded p-2 flex-1 min-w-0"
          />
          <input
            type="number"
            value={target}
            onChange={(e) => setTarget(e.target.value)}
            placeholder="Amt"
            className="bg-gray-700 text-white rounded p-2 w-32"
          />
          <input
            type="date"
            value={deadline}
            onChange={(e) => setDeadline(e.target.value)}
            className="bg-gray-700 text-white rounded p-2 w-40"
          />
          <select
            value={icon}
            onChange={(e) => setIcon(e.target.value)}
            className="bg-gray-700 text-white rounded p-2 w-20"
          >
            <option value="💰">💰</option>
            <option value="🏠">🏠</option>
            <option value="🚗">🚗</option>
            <option value="✈️">✈️</option>
            <option value="📚">📚</option>
          </select>
          <button
            onClick={addSavings}
            className="bg-purple-600 text-white px-4 py-2 rounded hover:bg-purple-700 flex items-center whitespace-nowrap"
          >
            <Plus className="h-5 w-5 mr-1" />
            Add Savings
          </button>
        </div>
      </div>

      {/* Savings cards list */}
      <div className="grid gap-4">
        {savings.map((saving) => (
          <SavingsCard
            key={saving.id}
            title={saving.title}
            targetAmount={saving.targetAmount}
            deadline={saving.deadline}
          />
        ))}
      </div>
    </div>
  );
}
