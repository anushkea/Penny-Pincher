import React, { useState } from 'react';
// Update imports with explicit naming
import { Users, Pin as PinIcon, Trash2, UserPlus, DivideSquare } from 'lucide-react';
import { SplitPayment } from '../types';

// Define a proper interface for participants
interface Participant {
  name: string;
  amount: number;
  paid: boolean;
}

interface Props {
  splitPayments: SplitPayment[];
  onAddSplitPayment: (payment: Omit<SplitPayment, 'id'>) => void;
  onUpdateSplitPayment: (payment: SplitPayment) => void;
  onDeleteSplitPayment: (id: string) => void;
}

export default function SplitPayments({
  splitPayments,
  onAddSplitPayment,
  onUpdateSplitPayment,
  onDeleteSplitPayment,
}: Props) {
  const [title, setTitle] = useState('');
  const [amount, setAmount] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onAddSplitPayment({
      title,
      amount: parseFloat(amount),
      participants: [],
      isPinned: false,
    });
    setTitle('');
    setAmount('');
  };

  const addParticipant = (paymentId: string) => {
    const payment = splitPayments.find((p) => p.id === paymentId);
    if (!payment) return;

    const name = prompt('Enter participant name:');
    if (!name) return;

    const splitAmount = payment.amount / (payment.participants.length + 1);
    const updatedParticipants = payment.participants.map((p) => ({
      ...p,
      amount: splitAmount,
    }));

    onUpdateSplitPayment({
      ...payment,
      participants: [
        ...updatedParticipants,
        { name, amount: splitAmount, paid: false },
      ],
    });
  };

  const togglePin = (paymentId: string) => {
    const payment = splitPayments.find((p) => p.id === paymentId);
    if (!payment) return;
    onUpdateSplitPayment({ ...payment, isPinned: !payment.isPinned });
  };

  const splitEqually = (paymentId: string) => {
    const payment = splitPayments.find((p) => p.id === paymentId);
    if (!payment || payment.participants.length === 0) return;

    const splitAmount = payment.amount / payment.participants.length;
    const updatedParticipants = payment.participants.map((p) => ({
      ...p,
      amount: splitAmount,
    }));

    onUpdateSplitPayment({ ...payment, participants: updatedParticipants });
  };

  const togglePaid = (paymentId: string, participantIndex: number) => {
    const payment = splitPayments.find((p) => p.id === paymentId);
    if (!payment) return;

    const updatedParticipants = payment.participants.map((p, i) =>
      i === participantIndex ? { ...p, paid: !p.paid } : p
    );

    onUpdateSplitPayment({ ...payment, participants: updatedParticipants });
  };

  // Fix the sorting method to handle potentially undefined isPinned property
  const sortedPayments = [...splitPayments].sort((a, b) => {
    // Use double negation to convert boolean/undefined to a number
    return Number(!!b.isPinned) - Number(!!a.isPinned);
  });

  return (
    <div className="space-y-6">
      <div className="bg-gray-800 p-6 rounded-lg">
        <h2 className="text-xl font-bold mb-4 flex items-center">
          <Users className="h-6 w-6 mr-2" />
          Split Payments
        </h2>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-gray-400 mb-1">Payment Title</label>
            <input
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="w-full bg-gray-700 text-white rounded p-2"
              placeholder="Enter payment title"
              required
            />
          </div>

          <div>
            <label className="block text-gray-400 mb-1">Amount</label>
            <input
              type="number"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              className="w-full bg-gray-700 text-white rounded p-2"
              placeholder="Enter amount"
              required
            />
          </div>

          <button
            type="submit"
            className="w-full bg-purple-600 text-white py-2 rounded hover:bg-purple-700 transition-colors"
          >
            Create Split Payment
          </button>
        </form>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {sortedPayments.map((payment) => (
            <div
              key={payment.id}
              className={`bg-gray-800 p-6 rounded-lg ${
                payment.isPinned ? 'border-2 border-purple-500' : ''
              }`}
            >
              <div className="flex justify-between items-start mb-4">
                <div>
                  <h3 className="text-lg font-semibold">{payment.title}</h3>
                  <p className="text-gray-400">Total: ₹{payment.amount.toFixed(2)}</p>
                </div>
                <div className="flex space-x-2">
                  <button
                    onClick={() => togglePin(payment.id)}
                    className={`p-2 rounded hover:bg-gray-700 ${
                      payment.isPinned ? 'text-purple-500' : 'text-gray-400'
                    }`}
                  >
                    <PinIcon className="h-5 w-5" />
                  </button>
                  <button
                    onClick={() => addParticipant(payment.id)}
                    className="p-2 rounded hover:bg-gray-700 text-gray-400"
                  >
                    <UserPlus className="h-5 w-5" />
                  </button>
                  <button
                    onClick={() => splitEqually(payment.id)}
                    className="p-2 rounded hover:bg-gray-700 text-gray-400"
                  >
                    <DivideSquare className="h-5 w-5" />
                  </button>
                  <button
                    onClick={() => onDeleteSplitPayment(payment.id)}
                    className="p-2 rounded hover:bg-gray-700 text-red-500"
                  >
                    <Trash2 className="h-5 w-5" />
                  </button>
                </div>
              </div>

              <div className="space-y-2">
                {payment.participants.map((participant, index) => (
                  <div
                    key={index}
                    className="flex items-center justify-between p-2 bg-gray-700 rounded"
                  >
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={participant.paid}
                        onChange={() => togglePaid(payment.id, index)}
                        className="mr-2"
                      />
                      <span
                        className={participant.paid ? 'line-through text-gray-400' : ''}
                      >
                        {participant.name}
                      </span>
                    </div>
                    <span className="font-mono">
                      ₹{participant.amount.toFixed(2)}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          ))}
      </div>
    </div>
  );
}