import { Link, useNavigate } from 'react-router-dom';
import { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import FeaturesModal from './FeaturesModal';

export default function Header() {
    const { user, logout } = useAuth();
    const navigate = useNavigate();
    const [showFeaturesModal, setShowFeaturesModal] = useState(false);

    const handleLogout = () => {
        logout();
        navigate('/');
    };

    return (
        <>
            <header className="header">
                <div className="header-content">
                    <Link to="/" className="logo">
                        <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
                            <rect width="32" height="32" rx="8" fill="#3B82F6"/>
                            <path d="M10 16L14 12L18 16L22 12" stroke="white" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"/>
                            <path d="M10 20L14 16L18 20L22 16" stroke="white" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"/>
                        </svg>
                        <h1>NanoURL</h1>
                    </Link>
                    <nav className="nav">
                        <button 
                            className="btn-features"
                            onClick={() => setShowFeaturesModal(true)}
                            title="View features and help"
                        >
                            ℹ️ Features & Help
                        </button>
                        {user && <Link to="/history">My URLs</Link>}
                        {user ? (
                            <div className="user-menu">
                                <span className="user-name">👋 {user.name}</span>
                                <button onClick={handleLogout} className="btn-secondary">Logout</button>
                            </div>
                        ) : (
                            <Link to="/auth" className="btn-secondary">Sign In</Link>
                        )}
                    </nav>
                </div>
            </header>

            <FeaturesModal 
                isOpen={showFeaturesModal} 
                onClose={() => setShowFeaturesModal(false)} 
            />
        </>
    );
}