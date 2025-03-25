import React, { useState } from 'react';
import Header from './components/Header';
import Overview from './components/Overview';
import LoanCalculator from './components/LoanCalculator';
import CurrencyConverter from './components/CurrencyConverter';
import TransactionForm from './components/TransactionForm';
import TransactionHistory from './components/TransactionHistory';
import SavingsSection from './components/SavingsSection';
import SavingsGoals from './components/SavingsGoals';
import SplitPayments from './components/SplitPayments';
import { Transaction, Loan, SplitPayment, SavingsGoal } from './types';

function App() {
  // State with proper types
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loans, setLoans] = useState<Loan[]>([]);
  const [splitPayments, setSplitPayments] = useState<SplitPayment[]>([]);
  const [savingsGoals, setSavingsGoals] = useState<SavingsGoal[]>([]);

  // Functions for LoanCalculator
  const onAddLoan = (loan: Omit<Loan, 'id'>) => {
    setLoans([...loans, { ...loan, id: Date.now().toString() }]);
  };
  
  const onDeleteLoan = (id: string) => {
    setLoans(loans.filter((l) => l.id !== id));
  };

  // Function for TransactionForm
  const onAddTransaction = (transaction: Omit<Transaction, 'id'>) => {
    setTransactions([...transactions, { ...transaction, id: Date.now().toString() }]);
  };

  // Functions for SavingsGoals
  const onAddSaving = (saving: Omit<SavingsGoal, 'id'>) => {
    setSavingsGoals([...savingsGoals, { ...saving, id: Date.now().toString() }]);
  }; 
  
  const onUpdateSaving = (saving: SavingsGoal) => {
    setSavingsGoals(savingsGoals.map(s => s.id === saving.id ? saving : s));
  }; 
  
  const onDeleteSaving = (id: string) => {
    setSavingsGoals(savingsGoals.filter(s => s.id !== id));
  };

  // Functions for SplitPayments
  const onAddSplitPayment = (payment: Omit<SplitPayment, 'id'>) => {
    setSplitPayments([...splitPayments, { ...payment, id: Date.now().toString() }]);
  };
  
  const onUpdateSplitPayment = (payment: SplitPayment) => {
    setSplitPayments(splitPayments.map((p) => (p.id === payment.id ? payment : p)));
  };
  
  const onDeleteSplitPayment = (id: string) => {
    setSplitPayments(splitPayments.filter((p) => p.id !== id));
  };

  return (
    <>
      <Header />
      <div className="container mx-auto p-4 space-y-8">
        <Overview transactions={transactions} />
        <LoanCalculator loans={loans} onAddLoan={onAddLoan} onDeleteLoan={onDeleteLoan} />
        <CurrencyConverter />
        <TransactionForm onAddTransaction={onAddTransaction} />
        <TransactionHistory transactions={transactions} />
        <SavingsSection />
        <SavingsGoals 
          savings={savingsGoals} 
          onAddSaving={onAddSaving} 
          onUpdateSaving={onUpdateSaving} 
          onDeleteSaving={onDeleteSaving} 
        />
        <SplitPayments 
          splitPayments={splitPayments} 
          onAddSplitPayment={onAddSplitPayment} 
          onUpdateSplitPayment={onUpdateSplitPayment} 
          onDeleteSplitPayment={onDeleteSplitPayment} 
        />
      </div>
    </>
  );
}

export default App;