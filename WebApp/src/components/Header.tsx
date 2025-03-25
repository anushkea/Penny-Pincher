import { PiggyBank, HelpCircle } from 'lucide-react';
import { useState } from 'react';
import HelpModal from './HelpModal';

export default function Header() {
  const [isHelpOpen, setIsHelpOpen] = useState(false);

  return (
    <header className="bg-gray-900 text-white p-4">
      <div className="container mx-auto flex justify-between items-center">
        <div className="flex items-center space-x-2">
          <PiggyBank className="h-8 w-8 text-purple-500" />
          <h1 className="text-2xl font-bold">Penny Pincher</h1>
        </div>
        <button
          onClick={() => setIsHelpOpen(true)}
          className="flex items-center space-x-1 hover:text-purple-400 transition-colors"
        >
          <HelpCircle className="h-6 w-6" />
          <span>Help</span>
        </button>
      </div>
      <HelpModal isOpen={isHelpOpen} onClose={() => setIsHelpOpen(false)} />
    </header>
  );
}