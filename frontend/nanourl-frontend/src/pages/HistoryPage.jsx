import { useState, useEffect, useCallback } from 'react';
import { useAuth } from '../context/AuthContext';
import './HistoryPage.css';

const HistoryPage = () => {
  const { token } = useAuth();
  const [urls, setUrls] = useState([]);
  const [loading, setLoading] = useState(true);
  const [copiedId, setCopiedId] = useState(null);
  const [sortBy, setSortBy] = useState('recent');

  const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

  const fetchHistory = useCallback(async () => {
    try {
      const res = await fetch(`${API_URL}/api/urls/history`, {
        headers: { 'Authorization': `Bearer ${token}` }
      });
      if (res.ok) {
        const data = await res.json();
        setUrls(data);
      }
    } catch (err) {
      console.error('Failed to fetch history:', err);
    } finally {
      setLoading(false);
    }
  }, [token]);

  useEffect(() => {
    if (token) {
      fetchHistory();
    }
  }, [token, fetchHistory]);

  const copyToClipboard = (text, id) => {
    navigator.clipboard.writeText(text);
    setCopiedId(id);
    setTimeout(() => setCopiedId(null), 2000);
  };

  const deleteUrl = async (id) => {
    if (window.confirm('Are you sure you want to delete this URL?')) {
      try {
        const res = await fetch(`${API_URL}/api/urls/${id}`, {
          method: 'DELETE',
          headers: { 'Authorization': `Bearer ${token}` }
        });
        if (res.ok) {
          setUrls(urls.filter(url => url.id !== id));
        }
      } catch (err) {
        console.error('Failed to delete:', err);
      }
    }
  };

  const getSortedUrls = () => {
    let sorted = [...urls];
    
    switch (sortBy) {
      case 'clicks':
        sorted.sort((a, b) => (b.clickCount || 0) - (a.clickCount || 0));
        break;
      case 'oldest':
        sorted.sort((a, b) => new Date(a.createdAt) - new Date(b.createdAt));
        break;
      case 'recent':
      default:
        sorted.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
    }

    return sorted;
  };

  const getStats = () => {
    if (urls.length === 0) return null;
    
    const totalClicks = urls.reduce((sum, url) => sum + (url.clickCount || 0), 0);
    const mostClicked = urls.reduce((max, url) => 
      (url.clickCount || 0) > (max.clickCount || 0) ? url : max, urls[0]);
    
    return { totalClicks, mostClicked, count: urls.length };
  };

  const stats = getStats();

  if (loading) {
    return (
      <div className="history-page">
        <div className="loading-spinner">
          <div className="spinner"></div>
          <p>Loading your URLs...</p>
        </div>
      </div>
    );
  }

  if (urls.length === 0) {
    return (
      <div className="history-page">
        <div className="history-header">
          <h1>📊 My URLs</h1>
          <p>Track and manage all your shortened URLs</p>
        </div>
        <div className="empty-state">
          <svg className="empty-icon" viewBox="0 0 64 64" fill="none">
            <circle cx="32" cy="32" r="30" stroke="#e5e7eb" strokeWidth="2"/>
            <path d="M20 32L28 40L44 24" stroke="#9ca3af" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" opacity="0.5"/>
          </svg>
          <h2>No URLs yet</h2>
          <p>Start shortening URLs to see them here!</p>
        </div>
      </div>
    );
  }

  const sortedUrls = getSortedUrls();

  return (
    <div className="history-page">
      <div className="history-header">
        <div>
          <div className="history-header-icon">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M9 2a1 1 0 000 2h6a1 1 0 000-2H9z"/>
              <path d="M7 4v12a3 3 0 003 3h4a3 3 0 003-3V4"/>
              <path d="M10 9l4 4m0-4l-4 4"/>
            </svg>
          </div>
          <div>
            <h1>My URLs</h1>
            <p>Track and manage all your shortened URLs</p>
          </div>
        </div>
        <button className="btn-refresh" onClick={fetchHistory}>🔄 Refresh</button>
      </div>

      {stats && (
        <div className="stats-section">
          <div className="stat-card">
            <div className="stat-card-icon">📎</div>
            <div className="stat-value">{stats.count}</div>
            <div className="stat-label">Total URLs</div>
          </div>
          <div className="stat-card">
            <div className="stat-card-icon">👆</div>
            <div className="stat-value">{stats.totalClicks.toLocaleString()}</div>
            <div className="stat-label">Total Clicks</div>
          </div>
          <div className="stat-card">
            <div className="stat-card-icon">📈</div>
            <div className="stat-value">{(stats.totalClicks / stats.count).toFixed(1)}</div>
            <div className="stat-label">Avg Clicks/URL</div>
          </div>
        </div>
      )}

      <div className="filters-section">
        <div className="filter-group">
          <label>Sort by:</label>
          <select value={sortBy} onChange={(e) => setSortBy(e.target.value)} className="filter-select">
            <option value="recent">Most Recent</option>
            <option value="oldest">Oldest First</option>
            <option value="clicks">Most Clicked</option>
          </select>
        </div>
      </div>

      <div className="urls-container">
        {sortedUrls.map((url) => (
          <div key={url.id} className="url-card">
            <div className="url-card-header">
              <div className="url-code">
                <span className="code">{url.shortCode}</span>
              </div>
              <div className="url-date">
                {new Date(url.createdAt).toLocaleDateString()} {new Date(url.createdAt).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}
              </div>
            </div>

            <div className="url-details">
              <div className="url-info">
                <label>Short URL:</label>
                <div className="url-value">
                  <a href={url.shortUrl} target="_blank" rel="noopener noreferrer" className="short-link">
                    {url.shortUrl}
                  </a>
                </div>
              </div>

              <div className="url-info">
                <label>Original URL:</label>
                <div className="url-value original">
                  <a href={url.longUrl} target="_blank" rel="noopener noreferrer" title={url.longUrl}>
                    {url.longUrl.length > 60 ? url.longUrl.substring(0, 60) + '...' : url.longUrl}
                  </a>
                </div>
              </div>
            </div>

            <div className="url-stats">
              <div className="stat">
                <span className="stat-icon">👆</span>
                <span className="stat-text">{url.clickCount || 0} clicks</span>
              </div>
            </div>

            <div className="url-actions">
              <button 
                className={`btn-copy ${copiedId === url.id ? 'copied' : ''}`}
                onClick={() => copyToClipboard(url.shortUrl, url.id)}
              >
                {copiedId === url.id ? '✓ Copied!' : '📋 Copy'}
              </button>
              <button 
                className="btn-delete"
                onClick={() => deleteUrl(url.id)}
              >
                🗑️ Delete
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default HistoryPage;
