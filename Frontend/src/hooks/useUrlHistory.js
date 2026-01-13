import { useState } from 'react';

export default function UrlHistory() {
    const [history, setHistory] = useState(() => {
        const saved = localStorage.getItem('urlHistory');
        return saved ? JSON.parse(saved) : [];
    });

    const addToHistory = (item) => {
        const newHistory = [item, ...history].slice(0, 10); // Keep last 10
        setHistory(newHistory);
        localStorage.setItem('urlHistory', JSON.stringify(newHistory));
    };

    const removeFromHistory = (index) => {
        const newHistory = history.filter((_, i) => i !== index);
        setHistory(newHistory);
        localStorage.setItem('urlHistory', JSON.stringify(newHistory));
    };

    const clearHistory = () => {
        setHistory([]);
        localStorage.removeItem('urlHistory');
    };

    return {
        history,
        addToHistory,
        removeFromHistory,
        clearHistory
    };
}
