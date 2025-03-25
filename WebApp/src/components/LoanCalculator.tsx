import { useState } from 'react';
import { Calculator, Plus, List } from 'lucide-react';
import { Loan } from '../types';

interface Props {
  loans: Loan[];
  onAddLoan: (loan: Omit<Loan, 'id'>) => void;
  onDeleteLoan: (id: string) => void;
}

export default function LoanCalculator({ loans, onAddLoan, onDeleteLoan }: Props) {
  const [isCalculating, setIsCalculating] = useState(true);
  const [principal, setPrincipal] = useState('');
  const [interestRate, setInterestRate] = useState('');
  const [tenure, setTenure] = useState('');
  const [title, setTitle] = useState('');

  const calculateLoan = () => {
    const p = parseFloat(principal);
    const r = parseFloat(interestRate) / 12 / 100;
    const n = parseFloat(tenure) * 12;

    const emi = (p * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);
    const totalAmount = emi * n;
    const totalInterest = totalAmount - p;

    return {
      emi,
      totalAmount,
      totalInterest,
    };
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const { emi, totalAmount, totalInterest } = calculateLoan();

    onAddLoan({
      title,
      principal: parseFloat(principal),
      interestRate: parseFloat(interestRate),
      tenure: parseFloat(tenure),
      emi,
      totalInterest,
      totalAmount,
      startDate: new Date().toISOString(),
    });

    setPrincipal('');
    setInterestRate('');
    setTenure('');
    setTitle('');
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-xl font-bold flex items-center">
          <Calculator className="h-6 w-6 mr-2" />
          Loan Calculator
        </h2>
        <div className="flex space-x-4">
          <button
            onClick={() => setIsCalculating(true)}
            className={`flex items-center space-x-2 px-4 py-2 rounded transition-colors ${
              isCalculating
                ? 'bg-purple-600 text-white'
                : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
            }`}
          >
            <Plus className="h-5 w-5" />
            <span>Calculate</span>
          </button>
          <button
            onClick={() => setIsCalculating(false)}
            className={`flex items-center space-x-2 px-4 py-2 rounded transition-colors ${
              !isCalculating
                ? 'bg-purple-600 text-white'
                : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
            }`}
          >
            <List className="h-5 w-5" />
            <span>View Loans</span>
          </button>
        </div>
      </div>

      {isCalculating ? (
        <div className="bg-gray-800 p-6 rounded-lg">
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-gray-400 mb-1">Loan Title</label>
              <input
                type="text"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                className="w-full bg-gray-700 text-white rounded p-2"
                placeholder="Enter loan title"
                required
              />
            </div>

            <div>
              <label className="block text-gray-400 mb-1">Principal Amount</label>
              <input
                type="number"
                value={principal}
                onChange={(e) => setPrincipal(e.target.value)}
                className="w-full bg-gray-700 text-white rounded p-2"
                placeholder="Enter principal amount"
                required
              />
            </div>

            <div>
              <label className="block text-gray-400 mb-1">
                Interest Rate (% per annum)
              </label>
              <input
                type="number"
                value={interestRate}
                onChange={(e) => setInterestRate(e.target.value)}
                className="w-full bg-gray-700 text-white rounded p-2"
                placeholder="Enter interest rate"
                required
              />
            </div>

            <div>
              <label className="block text-gray-400 mb-1">
                Loan Tenure (in years)
              </label>
              <input
                type="number"
                value={tenure}
                onChange={(e) => setTenure(e.target.value)}
                className="w-full bg-gray-700 text-white rounded p-2"
                placeholder="Enter loan tenure"
                required
              />
            </div>

            {principal && interestRate && tenure && (
              <div className="mt-6 p-4 bg-gray-700 rounded-lg space-y-2">
                <div className="flex justify-between">
                  <span className="text-gray-400">Monthly EMI:</span>
                  <span className="font-bold">
                    ₹{calculateLoan().emi.toFixed(2)}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-400">Total Interest:</span>
                  <span className="font-bold">
                    ₹{calculateLoan().totalInterest.toFixed(2)}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-400">Total Amount:</span>
                  <span className="font-bold">
                    ₹{calculateLoan().totalAmount.toFixed(2)}
                  </span>
                </div>
              </div>
            )}

            <button
              type="submit"
              className="w-full bg-purple-600 text-white py-2 rounded hover:bg-purple-700 transition-colors"
            >
              Save Loan
            </button>
          </form>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {loans.map((loan) => (
            <div key={loan.id} className="bg-gray-800 p-6 rounded-lg">
              <div className="flex justify-between items-start mb-4">
                <h3 className="text-lg font-semibold">{loan.title}</h3>
                <button
                  onClick={() => onDeleteLoan(loan.id)}
                  className="text-red-500 hover:text-red-400"
                >
                  <span className="sr-only">Delete</span>
                  ×
                </button>
              </div>

              <div className="space-y-2">
                <div className="flex justify-between">
                  <span className="text-gray-400">Principal:</span>
                  <span>₹{loan.principal.toFixed(2)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-400">Interest Rate:</span>
                  <span>{loan.interestRate}% p.a.</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-400">Tenure:</span>
                  <span>{loan.tenure} years</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-400">Monthly EMI:</span>
                  <span className="font-bold">₹{loan.emi.toFixed(2)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-400">Total Interest:</span>
                  <span>₹{loan.totalInterest.toFixed(2)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-400">Total Amount:</span>
                  <span>₹{loan.totalAmount.toFixed(2)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-400">Start Date:</span>
                  <span>
                    {new Date(loan.startDate).toLocaleDateString()}
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}