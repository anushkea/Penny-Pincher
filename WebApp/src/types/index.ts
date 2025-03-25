export interface Transaction {
  id: string;
  type: 'income' | 'expense';
  amount: number;
  description: string;
  category: string;
  date: string;
}

export interface SplitPayment {
  id: string;
  title: string;
  amount: number;
  participants: {
    name: string;
    amount: number;
    paid: boolean;
  }[];
  isPinned: boolean;
}

export interface SavingsGoal {
  id: string;
  title: string;
  targetAmount: number;
  currentAmount: number;
  deadline: string;
  icon: string;
}

export interface Loan {
  id: string;
  title: string;
  principal: number;
  interestRate: number;
  tenure: number;
  emi: number;
  totalInterest: number;
  totalAmount: number;
  startDate: string;
}

export interface HelpMessage {
  name: string;
  email: string;
  message: string;
}