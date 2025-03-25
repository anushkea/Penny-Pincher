import React, { useState } from 'react';
import MessageSentModal from './MessageSentModal';

interface HelpPopupProps {
  onClose: () => void;
}

export default function HelpPopup({ onClose }: HelpPopupProps) {
  const [formData, setFormData] = useState({ name: '', email: '', message: '' });
  const [isModalOpen, setIsModalOpen] = useState(false);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSendMessage = () => {
    if (!formData.name || !formData.email || !formData.message) {
      alert("Please fill in all fields!");
      return;
    }
    // Reset fields and open confirmation modal
    setFormData({ name: '', email: '', message: '' });
    setIsModalOpen(true);
  };

  return (
    <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-60 z-50">
      {/* Help Popup Container */}
      <div className="relative bg-gray-800 p-8 rounded-lg shadow-xl max-w-md w-full border-2 border-purple-500">
        {/* Close Button */}
        <button onClick={onClose} className="absolute top-4 right-4 text-gray-300 hover:text-white">
          ×
        </button>
        <div className="text-center mb-6">
          <h2 className="text-2xl font-bold text-white">Need Help?</h2>
          <p className="text-gray-300">Enter your name, email and message.</p>
        </div>
        {/* Form Fields */}
        <div className="space-y-4">
          <input 
            type="text" 
            name="name" 
            placeholder="Your Name" 
            value={formData.name}
            onChange={handleInputChange}
            className="w-full p-2 bg-gray-700 text-white rounded border border-gray-600"
          />
          <input 
            type="email" 
            name="email" 
            placeholder="Your Email" 
            value={formData.email}
            onChange={handleInputChange}
            className="w-full p-2 bg-gray-700 text-white rounded border border-gray-600"
          />
          <textarea 
            name="message" 
            placeholder="Your Message" 
            rows={4}
            value={formData.message}
            onChange={handleInputChange}
            className="w-full p-2 bg-gray-700 text-white rounded border border-gray-600"
          ></textarea>
        </div>
        {/* Send Message Button */}
        <div className="flex justify-center mt-4">
          <button 
            onClick={handleSendMessage}
            className="px-4 py-2 bg-purple-600 text-white rounded hover:bg-purple-700 transition-colors"
          >
            Send Message
          </button>
        </div>
      </div>
      {isModalOpen && <MessageSentModal onClose={() => setIsModalOpen(false)} />}
    </div>
  );
}
