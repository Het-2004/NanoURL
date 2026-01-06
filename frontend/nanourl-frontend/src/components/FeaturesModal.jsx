import { useState } from 'react';
import './FeaturesModal.css';

export default function FeaturesModal({ isOpen, onClose }) {
  const [activeTab, setActiveTab] = useState('getting-started');

  const features = {
    'getting-started': {
      title: 'Getting Started',
      icon: '🚀',
      content: [
        {
          title: 'Create Your Account',
          description: 'Sign up with your email, name, and contact number. Your first sign-up creates an account, then you can sign in anytime.',
          steps: [
            'Click on "Sign In" button in the top right',
            'Choose to create a new account or sign in',
            'Fill in your name, email, contact number, and password',
            'Start shortening URLs immediately'
          ]
        }
      ]
    },
    'shortening': {
      title: 'URL Shortening',
      icon: '🔗',
      content: [
        {
          title: 'Shorten a URL',
          description: 'Convert long, complex URLs into short, shareable links.',
          steps: [
            'Paste your long URL in the input field',
            'Click "Shorten URL" button',
            'Your short URL will be displayed instantly',
            'Click to copy or share directly'
          ]
        }
      ]
    },
    'history': {
      title: 'View History',
      icon: '📊',
      content: [
        {
          title: 'Access Your URL History',
          description: 'Track all your shortened URLs with detailed statistics.',
          steps: [
            'Sign in to your account',
            'Click "My URLs" in the navigation menu',
            'View all your shortened URLs in one place',
            'See click counts, creation date, and original URLs'
          ]
        }
      ]
    },
    'features': {
      title: 'Key Features',
      icon: '⭐',
      content: [
        {
          title: 'Simple Authentication',
          description: 'Sign up and sign in using email and password with your contact details.'
        },
        {
          title: 'Instant URL Shortening',
          description: 'Get your shortened URL immediately after entering a long URL.'
        },
        {
          title: 'Complete URL History',
          description: 'Access all your shortened URLs and track their usage statistics.'
        },
        {
          title: 'Click Analytics',
          description: 'See how many times each shortened URL has been clicked.'
        },
        {
          title: 'Easy Sharing',
          description: 'Copy short URLs with one click and share them anywhere.'
        },
        {
          title: 'Secure & Private',
          description: 'Your data is securely stored in our database and always accessible.'
        }
      ]
    },
    'tips': {
      title: 'Pro Tips',
      icon: '💡',
      content: [
        {
          title: 'Best Practices',
          description: 'Get the most out of NanoURL with these helpful tips.',
          steps: [
            'Keep URLs organized: Shorten them when you need to share',
            'Monitor popular links: Check click counts to see what\'s trending',
            'Use descriptive sources: Remember where your long URLs came from',
            'Share responsibly: Always know where your shortened URLs point to',
            'Save important URLs: Your history is always available in "My URLs"'
          ]
        }
      ]
    }
  };

  if (!isOpen) return null;

  const currentTab = features[activeTab];

  return (
    <div className="features-modal-overlay" onClick={onClose}>
      <div className="features-modal" onClick={(e) => e.stopPropagation()}>
        <div className="features-modal-header">
          <h2>📚 NanoURL Features & Help</h2>
          <button className="features-close-btn" onClick={onClose}>✕</button>
        </div>

        <div className="features-container">
          <div className="features-tabs">
            {Object.entries(features).map(([key, value]) => (
              <button
                key={key}
                className={`feature-tab ${activeTab === key ? 'active' : ''}`}
                onClick={() => setActiveTab(key)}
              >
                <span className="tab-icon">{value.icon}</span>
                <span className="tab-label">{value.title}</span>
              </button>
            ))}
          </div>

          <div className="features-content">
            <h3>{currentTab.icon} {currentTab.title}</h3>
            
            {currentTab.content.map((section, idx) => (
              <div key={idx} className="feature-section">
                <h4>{section.title}</h4>
                <p className="description">{section.description}</p>
                
                {section.steps && (
                  <div className="steps-list">
                    <p className="steps-label">Steps:</p>
                    <ol>
                      {section.steps.map((step, stepIdx) => (
                        <li key={stepIdx}>{step}</li>
                      ))}
                    </ol>
                  </div>
                )}
              </div>
            ))}

            {activeTab === 'features' && (
              <div className="features-grid">
                {currentTab.content.map((feature, idx) => (
                  <div key={idx} className="feature-card">
                    <h5>{feature.title}</h5>
                    <p>{feature.description}</p>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        <div className="features-modal-footer">
          <button className="features-close-footer-btn" onClick={onClose}>
            Close
          </button>
        </div>
      </div>
    </div>
  );
}
