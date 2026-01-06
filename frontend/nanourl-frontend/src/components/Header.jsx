import { Link, useNavigate } from 'react-router-dom';
import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import FeaturesModal from './FeaturesModal';

export default function Header() {
    const { user, logout } = useAuth();
    const navigate = useNavigate();
    const [showFeaturesModal, setShowFeaturesModal] = useState(false);
    const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

    const handleLogout = () => {
        logout();
        navigate('/');
        setMobileMenuOpen(false);
    };

    // Close mobile menu on route change or resize
    useEffect(() => {
        const handleResize = () => {
            if (window.innerWidth > 768) {
                setMobileMenuOpen(false);
            }
        };
        window.addEventListener('resize', handleResize);
        return () => window.removeEventListener('resize', handleResize);
    }, []);

    const closeMobileMenu = () => setMobileMenuOpen(false);

    return (
        <>
            <header className="header">
                <div className="header-content">
                    <Link to="/" className="logo" onClick={closeMobileMenu}>
                        <svg width="48" height="48" viewBox="0 0 48 48" fill="none" className="logo-svg">
                            <defs>
                                <linearGradient id="logoGrad" x1="0" y1="0" x2="48" y2="48">
                                    <stop offset="0%" stopColor="#2563EB"/>
                                    <stop offset="100%" stopColor="#1D4ED8"/>
                                </linearGradient>
                            </defs>
                            <rect width="48" height="48" rx="8" fill="url(#logoGrad)"/>
                            <g stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" fill="none">
                                <path d="M14 26c0-3.314 2.686-6 6-6h10m0 0l-3-3m3 3l-3 3"/>
                                <path d="M20 32h14c3.314 0 6-2.686 6-6v-4"/>
                            </g>
                        </svg>
                        <h1>NanoURL</h1>
                    </Link>

                    {/* Mobile Menu Button */}
                    <button 
                        className={`mobile-menu-btn ${mobileMenuOpen ? 'active' : ''}`}
                        onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
                        aria-label="Toggle menu"
                    >
                        <span></span>
                        <span></span>
                        <span></span>
                    </button>

                    <nav className={`nav ${mobileMenuOpen ? 'mobile-open' : ''}`}>
                        <button 
                            className="btn-features"
                            onClick={() => {
                                setShowFeaturesModal(true);
                                closeMobileMenu();
                            }}
                            title="View features and help"
                        >
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <circle cx="12" cy="12" r="10"/>
                                <path d="M12 16v-4M12 8h.01"/>
                            </svg>
                            <span>Features & Help</span>
                        </button>
                        {user && <Link to="/history" onClick={closeMobileMenu}>My URLs</Link>}
                        {user ? (
                            <div className="user-menu">
                                <span className="user-name">👋 {user.name}</span>
                                <button onClick={handleLogout} className="btn-secondary">Logout</button>
                            </div>
                        ) : (
                            <Link to="/auth" className="btn-secondary" onClick={closeMobileMenu}>Sign In</Link>
                        )}
                    </nav>

                    {/* Mobile overlay */}
                    {mobileMenuOpen && (
                        <div className="mobile-overlay" onClick={closeMobileMenu}></div>
                    )}
                </div>
            </header>

            <FeaturesModal 
                isOpen={showFeaturesModal} 
                onClose={() => setShowFeaturesModal(false)} 
            />
        </>
    );
}