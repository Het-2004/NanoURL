import { useState } from 'react';
import useUrlHistory from '../hooks/useUrlHistory';

export default function History() {
    const { history, removeFromHistory, clearHistory } = useUrlHistory();
    const [showHistory, setShowHistory] = useState(false);

    if (!showHistory) {
        return (
            <button 
                onClick={() => setShowHistory(true)} 
                className="btn-history"
                title={`Recent URLs (${history.length})`}
            >
                <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                    <path d="M10 0C4.48 0 0 4.48 0 10s4.48 10 10 10 10-4.48 10-10S15.52 0 10 0zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm.5-13H9v6l5.25 3.15.75-1.23-5.5-3.27z"/>
                </svg>
                History ({history.length})
            </button>
        );
    }

    return (
        <div className="history-panel">
            <div className="history-header">
                <h3>Recent URLs</h3>
                <button 
                    onClick={() => setShowHistory(false)} 
                    className="btn-close"
                >
                    X
                </button>
            </div>
            
            {history.length === 0 ? (
                <p className="empty-message">No recent URLs yet</p>
            ) : (
                <>
                    <div className="history-list">
                        {history.map((item, index) => (
                            <div key={index} className="history-item">
                                <div className="history-content">
                                    <p className="history-short">
                                        <strong>Short:</strong> {item.shortUrl}
                                    </p>
                                    <p className="history-long" title={item.longUrl}>
                                        <strong>Original:</strong> {item.longUrl}
                                    </p>
                                    <p className="history-time">
                                        {new Date(item.timestamp).toLocaleString()}
                                    </p>
                                </div>
                                <button 
                                    onClick={() => removeFromHistory(index)} 
                                    className="btn-delete"
                                    title="Remove from history"
                                >
                                    Delete
                                </button>
                            </div>
                        ))}
                    </div>
                    <button 
                        onClick={clearHistory} 
                        className="btn-secondary"
                        style={{width: '100%', marginTop: '1rem'}}
                    >
                        Clear All History
                    </button>
                </>
            )}
        </div>
    );
}
