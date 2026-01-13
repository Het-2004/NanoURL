import { useState } from "react";
import { API_BASE_URL } from "../config/api";

export default function Result({ shortUrl, longUrl }) {
    const [copied, setCopied] = useState(false);
    const [qrCode, setQrCode] = useState(null);
    const [showQrModal, setShowQrModal] = useState(false);
    const [qrLoading, setQrLoading] = useState(false);

    function copy() {
        navigator.clipboard.writeText(shortUrl);
        setCopied(true);
        setTimeout(() => setCopied(false), 2000);
    }

    async function generateQrCode() {
        setQrLoading(true);
        try {
            const response = await fetch(`${API_BASE_URL}/api/qr/generate/dataurl`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ text: shortUrl }),
            });

            if (response.ok) {
                const data = await response.json();
                setQrCode(data.qrCode);
                setShowQrModal(true);
            } else {
                alert('Failed to generate QR code');
            }
        } catch (error) {
            console.error('Error generating QR code:', error);
            alert('Error generating QR code');
        } finally {
            setQrLoading(false);
        }
    }

    return (
        <div className="result-container">
            <div className="result-header">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M9 16.2L4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4L9 16.2z" fill="#10B981"/>
                </svg>
                <h3>Your Shortened URL is Ready!</h3>
            </div>
            
            <div className="url-display">
                <div className="url-section">
                    <label>Original URL:</label>
                    <div className="url-text original-url">{longUrl}</div>
                </div>
                
                <div className="url-divider">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                        <path d="M12 4l-8 8 8 8" stroke="#9CA3AF" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                    </svg>
                </div>
                
                <div className="url-section">
                    <label>Short URL:</label>
                    <div className="short-url-container">
                        <a href={shortUrl} target="_blank" rel="noopener noreferrer" className="url-text short-url">
                            {shortUrl}
                        </a>
                        <button onClick={copy} className="btn-copy">
                            {copied ? (
                                <>
                                    <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                                        <path d="M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 01-1.06 0L2.22 9.28a.75.75 0 011.06-1.06L6 10.94l6.72-6.72a.75.75 0 011.06 0z"/>
                                    </svg>
                                    Copied!
                                </>
                            ) : (
                                <>
                                    <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                                        <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 010 1.5h-1.5a.25.25 0 00-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 00.25-.25v-1.5a.75.75 0 011.5 0v1.5A1.75 1.75 0 019.25 16h-7.5A1.75 1.75 0 010 14.25v-7.5z"/>
                                        <path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0114.25 11h-7.5A1.75 1.75 0 015 9.25v-7.5zm1.75-.25a.25.25 0 00-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 00.25-.25v-7.5a.25.25 0 00-.25-.25h-7.5z"/>
                                    </svg>
                                    Copy
                                </>
                            )}
                        </button>
                    </div>
                </div>
            </div>
            
            <div className="result-actions">
                <a href={shortUrl} target="_blank" rel="noopener noreferrer" className="btn-secondary">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                        <path d="M8 0a8 8 0 100 16A8 8 0 008 0zM5.5 7.5A1.5 1.5 0 117 9a1.5 1.5 0 01-1.5-1.5zm5 0A1.5 1.5 0 1112 9a1.5 1.5 0 01-1.5-1.5z"/>
                    </svg>
                    Test Link
                </a>
                <button className="btn-secondary" onClick={generateQrCode} disabled={qrLoading}>
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                        <path d="M0 2a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H2a2 2 0 01-2-2V2zm0 8a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H2a2 2 0 01-2-2v-2zm8-8a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V2zm4 8a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 01-1 1h-2a1 1 0 01-1-1v-2z"/>
                    </svg>
                    {qrLoading ? "Generating..." : "QR Code"}
                </button>
            </div>

            {showQrModal && qrCode && (
                <div className="modal-overlay" onClick={() => setShowQrModal(false)}>
                    <div className="modal-content" onClick={e => e.stopPropagation()}>
                        <div className="modal-header">
                            <h2>QR Code</h2>
                            <button className="modal-close" onClick={() => setShowQrModal(false)}>
                                ✕
                            </button>
                        </div>
                        <div className="modal-body">
                            <img src={qrCode} alt="QR Code" className="qr-code-image" />
                            <p className="qr-info">Scan this QR code to access the shortened URL</p>
                        </div>
                        <div className="modal-footer">
                            <a 
                                href={qrCode} 
                                download="qrcode.png" 
                                className="btn-primary"
                            >
                                Download QR Code
                            </a>
                            <button 
                                className="btn-secondary" 
                                onClick={() => setShowQrModal(false)}
                            >
                                Close
                            </button>
                        </div>
                    </div>
                </div>
            )}
            
            <div className="result-tip">
                💡 <span>Track this URL's analytics in your <a href="/history">History</a> page</span>
            </div>
        </div>
    );
}
