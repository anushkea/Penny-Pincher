import React from 'react';
import { DollarSign, Calendar, TrendingUp as TrendingUpIcon, Heart, Star, Bookmark } from 'lucide-react';

interface SavingsCardProps {
  title: string;
  targetAmount: number;
  deadline: string;
}

export default function SavingsCard({ title, targetAmount, deadline }: SavingsCardProps) {
  return (
    <div className="bg-gray-800 p-4 rounded-lg shadow-lg border border-purple-500">
      {/* Single-line header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <span className="text-lg font-semibold">{title}</span>
          <span className="text-sm text-gray-400">Target: ₹{targetAmount}</span>
          <span className="text-sm text-gray-400">Deadline: {deadline}</span>
        </div>
        <div className="flex items-center gap-2">
          <DollarSign className="h-5 w-5 text-purple-400" />
          <Calendar className="h-5 w-5 text-purple-400" />
          <TrendingUpIcon className="h-5 w-5 text-purple-400" />
          <Heart className="h-5 w-5 text-purple-400" />
          <Star className="h-5 w-5 text-purple-400" />
          <Bookmark className="h-5 w-5 text-purple-400" />
        </div>
      </div>
    </div>
  );
}
