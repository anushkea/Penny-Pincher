import React from 'react';
import { Calculator } from 'lucide-react';
import { Loan } from '../types';

interface LoanDetailsCardProps {
	loan: Loan;
	onClose: () => void;
}

export default function LoanDetailsCard({ loan, onClose }: LoanDetailsCardProps) {
	return (
		<div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
			<div className="bg-gray-800 p-6 rounded-lg shadow-lg relative max-w-md w-full border border-purple-500">
				<button
					onClick={onClose}
					className="absolute top-2 right-2 text-white bg-gray-700 p-1 rounded-full hover:bg-gray-600"
				>
					×
				</button>

				<div className="flex items-center space-x-3 mb-4">
					<Calculator className="h-8 w-8 text-purple-400" />
					<h2 className="text-2xl font-bold">{loan.title}</h2>
				</div>

				<div className="space-y-2">
					<div className="flex justify-between text-sm">
						<span className="text-gray-400">Principal:</span>
						<span className="font-bold">₹{loan.principal.toFixed(2)}</span>
					</div>
					<div className="flex justify-between text-sm">
						<span className="text-gray-400">Interest Rate:</span>
						<span className="font-bold">{loan.interestRate}% p.a.</span>
					</div>
					<div className="flex justify-between text-sm">
						<span className="text-gray-400">Tenure:</span>
						<span className="font-bold">{loan.tenure} years</span>
					</div>
					<div className="flex justify-between text-sm">
						<span className="text-gray-400">Monthly EMI:</span>
						<span className="font-bold">₹{loan.emi.toFixed(2)}</span>
					</div>
					<div className="flex justify-between text-sm">
						<span className="text-gray-400">Total Interest:</span>
						<span className="font-bold">₹{loan.totalInterest.toFixed(2)}</span>
					</div>
					<div className="flex justify-between text-sm">
						<span className="text-gray-400">Total Amount:</span>
						<span className="font-bold">₹{loan.totalAmount.toFixed(2)}</span>
					</div>
					<div className="flex justify-between text-sm">
						<span className="text-gray-400">Start Date:</span>
						<span className="font-bold">{new Date(loan.startDate).toLocaleDateString()}</span>
					</div>
				</div>
			</div>
		</div>
	);
}
