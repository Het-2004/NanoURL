import { Routes, Route, Navigate } from 'react-router-dom';
import Header from "./components/Header";
import UrlShortener from "./components/UrlShortener";
import AuthPage from './pages/AuthPage';
import FeaturesPage from './pages/FeaturesPage';
import HistoryPage from './pages/HistoryPage';
import PrivacyPolicy from './pages/PrivacyPolicy';
import TermsOfService from './pages/TermsOfService';
import Contact from './pages/Contact';
import { useAuth } from './context/AuthContext';
import './App.css';

// Protected Route Component
function ProtectedRoute({ children }) {
    const { user } = useAuth();
    
    if (!user) {
        return <Navigate to="/auth" replace />;
    }
    
    return children;
}

function App() {
    const { loading, user } = useAuth();

    if (loading) {
        return <div className="loading-screen">Loading...</div>;
    }

    return (
        <div className="app">
            {user && <Header />}
            <Routes>
                <Route path="/auth" element={
                    user ? <Navigate to="/" replace /> : <AuthPage />
                } />
                <Route path="/" element={
                    <ProtectedRoute>
                        <main className="main-content">
                            <UrlShortener />
                        </main>
                    </ProtectedRoute>
                } />
                <Route path="/features" element={
                    <ProtectedRoute>
                        <FeaturesPage />
                    </ProtectedRoute>
                } />
                <Route path="/history" element={
                    <ProtectedRoute>
                        <HistoryPage />
                    </ProtectedRoute>
                } />
                <Route path="/privacy" element={
                    <ProtectedRoute>
                        <PrivacyPolicy />
                    </ProtectedRoute>
                } />
                <Route path="/terms" element={
                    <ProtectedRoute>
                        <TermsOfService />
                    </ProtectedRoute>
                } />
                <Route path="/contact" element={
                    <ProtectedRoute>
                        <Contact />
                    </ProtectedRoute>
                } />
                <Route path="*" element={<Navigate to={user ? "/" : "/auth"} replace />} />
            </Routes>
            {user && (
                <footer className="footer">
                    <p>&copy; 2026 NanoURL. All rights reserved.</p>
                    <div className="footer-links">
                        <a href="/privacy">Privacy Policy</a>
                        <a href="/terms">Terms of Service</a>
                        <a href="/contact">Contact</a>
                    </div>
                </footer>
            )}
        </div>
    );
}

export default App;
