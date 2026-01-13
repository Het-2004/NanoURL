import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import Result from "./Result";

export default function UrlShortener() {
    const [longUrl, setLongUrl] = useState("");
    const [shortUrl, setShortUrl] = useState("");
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);
    const { token } = useAuth();

    const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

    async function handleShorten(e) {
        e.preventDefault();
        if (!longUrl.trim()) {
            setError("Please enter a valid URL");
            return;
        }

        try {
            setLoading(true);
            setError("");
            setShortUrl("");
            
            const headers = { 'Content-Type': 'application/json' };
            if (token) {
                headers['Authorization'] = `Bearer ${token}`;
            }

            const res = await fetch(`${API_URL}/api/shorten`, {
                method: 'POST',
                headers,
                body: JSON.stringify({ url: longUrl })
            });

            if (!res.ok) {
                throw new Error('Failed to shorten URL');
            }

            const data = await res.json();
            setShortUrl(data.shortUrl);
        } catch (err) {
            setError(err.message || "Failed to shorten URL. Please try again.");
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="url-shortener">
            <div className="hero-section">
                <div className="hero-badge">✨ Fast & Reliable</div>
                <h2 className="hero-title">Shorten Your Links, Amplify Your Reach</h2>
                <p className="hero-subtitle">
                    Create short, memorable links in seconds. Perfect for marketing campaigns,
                    social media, and sharing. Track analytics and boost your digital presence.
                </p>
            </div>

            <form className="shorten-form" onSubmit={handleShorten}>
                <div className="input-group">
                    <svg className="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="none">
                        <path d="M10 1C5.03 1 1 5.03 1 10s4.03 9 9 9 9-4.03 9-9-4.03-9-9-9zm0 16c-3.87 0-7-3.13-7-7s3.13-7 7-7 7 3.13 7 7-3.13 7-7 7z" fill="currentColor"/>
                        <path d="M10.5 5.5h-1v5l4.4 2.6.6-1-4-2.4V5.5z" fill="currentColor"/>
                    </svg>
                    <input
                        type="url"
                        placeholder="Enter your long URL here (e.g., https://example.com/very-long-url)"
                        value={longUrl}
                        onChange={(e) => setLongUrl(e.target.value)}
                        className="url-input"
                        disabled={loading}
                    />
                </div>
                <button 
                    type="submit" 
                    className="btn-primary"
                    disabled={loading}
                >
                    {loading ? (
                        <>
                            <span className="spinner"></span>
                            Shortening...
                        </>
                    ) : (
                        <>
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                                <path d="M3 10h14M10 3l7 7-7 7" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                            </svg>
                            Shorten URL
                        </>
                    )}
                </button>
            </form>

            {error && (
                <div className="alert alert-error">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M10 0C4.48 0 0 4.48 0 10s4.48 10 10 10 10-4.48 10-10S15.52 0 10 0zm1 15H9v-2h2v2zm0-4H9V5h2v6z"/>
                    </svg>
                    {error}
                </div>
            )}
            
            {shortUrl && <Result shortUrl={shortUrl} longUrl={longUrl} />}

            <div className="features-grid">
                <div className="feature-card">
                    <div className="feature-icon">⚡</div>
                    <h3>Lightning Fast</h3>
                    <p>Generate short links in milliseconds</p>
                </div>
                <div className="feature-card">
                    <div className="feature-icon">🔒</div>
                    <h3>Secure & Reliable</h3>
                    <p>Your links are safe and always accessible</p>
                </div>
                <div className="feature-card">
                    <div className="feature-icon">📊</div>
                    <h3>Track Analytics</h3>
                    <p>Monitor clicks and engagement metrics</p>
                </div>
                <div className="feature-card">
                    <div className="feature-icon">🎯</div>
                    <h3>Custom Links</h3>
                    <p>Create branded, memorable URLs</p>
                </div>
            </div>
        </div>
    );
}
