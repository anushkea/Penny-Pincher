import { useState, useEffect } from 'react';
import { RefreshCw } from 'lucide-react';

interface ExchangeRates {
  [key: string]: number;
}

export default function CurrencyConverter() {
  const [amount, setAmount] = useState<string>('1');
  const [fromCurrency, setFromCurrency] = useState<string>('USD');
  const [toCurrency, setToCurrency] = useState<string>('EUR');
  const [rates, setRates] = useState<ExchangeRates>({});
  const [loading, setLoading] = useState<boolean>(true);

  const currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY', 'INR'];

  useEffect(() => {
    fetchExchangeRates();
  }, []);

  const fetchExchangeRates = async () => {
    try {
      const response = await fetch(`https://api.exchangerate-api.com/v4/latest/USD`);
      const data = await response.json();
      setRates(data.rates);
      setLoading(false);
    } catch (error) {
      console.error('Failed to fetch exchange rates:', error);
      setLoading(false);
    }
  };

  const convertCurrency = () => {
    if (!rates[fromCurrency] || !rates[toCurrency]) return 0;
    const amountNum = parseFloat(amount);
    if (isNaN(amountNum)) return 0;
    
    const baseAmount = amountNum / rates[fromCurrency];
    return (baseAmount * rates[toCurrency]).toFixed(2);
  };

  if (loading) {
    return (
      <div className="bg-gray-800 p-6 rounded-lg">
        <h2 className="text-xl font-bold mb-4">Currency Converter</h2>
        <p>Loading exchange rates...</p>
      </div>
    );
  }

  return (
    <div className="bg-gray-800 p-6 rounded-lg">
      <h2 className="text-xl font-bold mb-4">Currency Converter</h2>
      <div className="space-y-4">
        <div>
          <label className="block text-gray-400 mb-1">Amount</label>
          <input
            type="number"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            className="w-full bg-gray-700 text-white rounded p-2"
            placeholder="Enter amount"
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-gray-400 mb-1">From</label>
            <select
              value={fromCurrency}
              onChange={(e) => setFromCurrency(e.target.value)}
              className="w-full bg-gray-700 text-white rounded p-2"
            >
              {currencies.map((currency) => (
                <option key={currency} value={currency}>
                  {currency}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-gray-400 mb-1">To</label>
            <select
              value={toCurrency}
              onChange={(e) => setToCurrency(e.target.value)}
              className="w-full bg-gray-700 text-white rounded p-2"
            >
              {currencies.map((currency) => (
                <option key={currency} value={currency}>
                  {currency}
                </option>
              ))}
            </select>
          </div>
        </div>

        <button
          onClick={fetchExchangeRates}
          className="flex items-center space-x-2 text-gray-400 hover:text-white transition-colors"
        >
          <RefreshCw className="h-4 w-4" />
          <span>Refresh Rates</span>
        </button>

        <div className="mt-4 p-4 bg-gray-700 rounded-lg">
          <p className="text-lg">
            {amount} {fromCurrency} = <span className="font-bold">{convertCurrency()} {toCurrency}</span>
          </p>
          <p className="text-sm text-gray-400 mt-1">
            1 {fromCurrency} = {(rates[toCurrency] / rates[fromCurrency]).toFixed(4)} {toCurrency}
          </p>
        </div>
      </div>
    </div>
  );
}