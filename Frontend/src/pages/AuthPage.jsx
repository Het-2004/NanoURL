import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import './AuthPage.css';

const AuthPage = () => {
  const [isSignup, setIsSignup] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [contactNumber, setContactNumber] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    const endpoint = isSignup ? '/api/auth/signup' : '/api/auth/signin';
    const body = isSignup 
      ? { email, password, name, contactNumber }
      : { email, password };

    try {
      const res = await fetch(`${API_URL}${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body)
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.error || 'Authentication failed');
      }

      login({ email: data.user.email, name: data.user.name, id: data.user.id }, data.token);
      navigate('/');
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="auth-page">
      <div className="auth-container">
        <div className="auth-header">
          <div className="auth-logo">
            <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
              <rect width="40" height="40" rx="8" fill="url(#grad)"/>
              <path d="M12 20h8m0 0l-3-3m3 3l-3 3m7-8v10a2 2 0 01-2 2h-4" stroke="#fff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              <defs><linearGradient id="grad" x1="0" y1="0" x2="40" y2="40"><stop stopColor="#3B82F6"/><stop offset="1" stopColor="#8B5CF6"/></linearGradient></defs>
            </svg>
            <span>NanoURL</span>
          </div>
          <h1>{isSignup ? 'Create Your Account' : 'Welcome Back!'}</h1>
          <p>{isSignup ? 'Join thousands of users shortening URLs efficiently' : 'Sign in to continue shortening and tracking URLs'}</p>
        </div>

        <form onSubmit={handleSubmit} className="auth-form">
          {isSignup && (
            <div className="form-group">
              <label>Full Name</label>
              <input type="text" value={name} onChange={(e) => setName(e.target.value)} placeholder="John Doe" required />
            </div>
          )}
          <div className="form-group">
            <label>Email Address</label>
            <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@example.com" required />
          </div>
          {isSignup && (
            <div className="form-group">
              <label>Contact Number</label>
              <input 
                type="tel" 
                value={contactNumber} 
                onChange={(e) => setContactNumber(e.target.value)} 
                placeholder="+1 (555) 123-4567" 
                pattern="[+]?[0-9\s()-]+"
                required 
              />
            </div>
          )}
          <div className="form-group">
            <label>Password</label>
            <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="••••••••" required minLength={6} />
          </div>
          {error && <div className="error-msg">{error}</div>}
          <button type="submit" className="submit-btn" disabled={loading}>
            {loading ? 'Please wait...' : (isSignup ? 'Create Account' : 'Sign In')}
          </button>
        </form>

        <p className="switch-mode">
          {isSignup ? 'Already have an account?' : "Don't have an account?"}
          <button onClick={() => { setIsSignup(!isSignup); setError(''); }}>
            {isSignup ? 'Sign In' : 'Sign Up'}
          </button>
        </p>
      </div>
    </div>
  );
};

export default AuthPage;
