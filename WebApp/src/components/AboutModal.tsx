import React from 'react';
import { X, Github, Linkedin, Instagram, MapPin } from 'lucide-react';

interface AboutModalProps {
  onClose: () => void;
}

export default function AboutModal({ onClose }: AboutModalProps) {
  return (
    <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-60 z-50 transition-opacity duration-300 animate-fadeIn">
      {/* Increased container size with border */}
      <div className="fixed top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 bg-gray-900 p-10 rounded-lg shadow-2xl max-w-4xl w-full border border-gray-700 transition-transform duration-500 hover:scale-105">
        <button 
          onClick={onClose} 
          className="absolute top-4 right-4 text-gray-300 hover:text-white transition-colors"
        >
          <X className="h-6 w-6" />
        </button>
        <div className="mb-8 text-center">
          <h2 className="text-4xl font-bold mb-2 text-white">Penny Pincher</h2>
          <p className="text-gray-400 mb-4">Version 1.0.0</p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {/* Developer 1: Anushka Mukherjee */}
          <div className="flex flex-col items-center flex-1 border-b md:border-b-0 md:border-r border-gray-700 pb-4 md:pr-4">
            <img 
              src="src/components/anushkers.jpeg" 
              alt="Anushka Mukherjee" 
              className="h-28 w-28 rounded-full object-cover mb-4 border-2 border-purple-500"
            />
            <h3 className="text-2xl font-semibold text-white">Anushka Mukherjee</h3>
            <p className="text-gray-400 text-center text-sm mt-2">
              Full-Stack Web Developer, Cloud Computing Enthusiast
            </p>
            <div className="flex items-center space-x-1 text-gray-400 text-sm">
              <MapPin className="h-4 w-4" />
              <span>Vadodara, Gujarat, India</span>
            </div>
            <p className="mt-2 text-gray-300 text-sm text-center">
              Full-Stack Web Developer, <strong>JavaScript Overlord</strong>, and TypeScript Tamer—I write <strong>React</strong> so smoothly it almost looks effortless. JavaScript bends to my will. Dabble in Python when automating laziness. My apps are fast, scalable, and surprisingly bug-resistant.
            </p>
            <div className="mt-3 flex space-x-3">
              <a href="https://github.com/anushkea" target="_blank" rel="noopener noreferrer" className="text-purple-400 hover:underline transition-colors">
                <Github className="h-5 w-5" />
              </a>
              <a href="https://in.linkedin.com/in/anushkea" target="_blank" rel="noopener noreferrer" className="text-purple-400 hover:underline transition-colors">
                <Linkedin className="h-5 w-5" />
              </a>
              <a href="https://www.instagram.com/anushkeaa/?__pwa=1" target="_blank" rel="noopener noreferrer" className="text-purple-400 hover:underline transition-colors">
                <Instagram className="h-5 w-5" />
              </a>
            </div>
          </div>
          {/* Developer 2: Soham Soni */}
          <div className="flex flex-col items-center flex-1">
            <img 
              src="src/components/soni.jpeg" 
              alt="Soham Soni" 
              className="h-28 w-28 rounded-full object-cover mb-4 border-2 border-purple-500"
            />
            <h3 className="text-2xl font-semibold text-white">Soham Soni</h3>
            <p className="text-gray-400 text-center text-sm mt-2">
              Flutter Developer, AI/ML Practitioner, Cloud Computing Expert
            </p>
            <div className="flex items-center space-x-1 text-gray-400 text-sm">
              <MapPin className="h-4 w-4" />
              <span>Vadodara, Gujarat, India</span>
            </div>
            <p className="mt-2 text-gray-300 text-sm text-center">
              Flutter Developer, Cloud Computing Enthusiast, and Machine Learning Practitioner—lots of trial, error, and hoping things work. Plays with Google Cloud and Oracle Generative AI. Also builds Flutter apps that are probably secure, scalable and efficient.
            </p>
            <div className="mt-3 flex space-x-3">
              <a href="https://github.com/Soham2212004" target="_blank" rel="noopener noreferrer" className="text-purple-400 hover:underline transition-colors">
                <Github className="h-5 w-5" />
              </a>
              <a href="https://in.linkedin.com/in/soham-soni-2342b4239" target="_blank" rel="noopener noreferrer" className="text-purple-400 hover:underline transition-colors">
                <Linkedin className="h-5 w-5" />
              </a>
              <a href="https://www.instagram.com/_soham_soni_/" target="_blank" rel="noopener noreferrer" className="text-purple-400 hover:underline transition-colors">
                <Instagram className="h-5 w-5" />
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
