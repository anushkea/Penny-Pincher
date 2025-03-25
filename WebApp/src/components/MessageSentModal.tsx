import React from 'react';
import { X } from 'lucide-react';

export default function MessageSentModal({ onClose }: { onClose: () => void }) {
  return (
    <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-80 z-[999] transition-opacity duration-300 animate-fadeIn">
      <div className="relative bg-gray-800 p-4 rounded-lg shadow-2xl max-w-sm w-full border-2 border-purple-500">
        <button 
          onClick={onClose} 
          className="absolute top-2 right-2 text-gray-300 hover:text-white"
        >
          <X className="h-5 w-5" />
        </button>
        <div className="mt-6 text-center">
          <h3 className="text-xl font-semibold text-white mb-2">Message Sent!</h3>
          <p className="text-gray-300 mb-4">
            Congratulations! Your message has embarked on a grand adventure through the digital cosmos and has successfully landed in the inbox of its intended recipient. May it be greeted with joy, laughter, and perhaps a confetti cannon or two. 🎉
          </p>
          <button 
            onClick={onClose} 
            className="px-4 py-2 bg-purple-600 text-white rounded hover:bg-purple-700 transition-colors"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
}
