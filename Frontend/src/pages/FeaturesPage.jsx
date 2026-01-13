import './FeaturesPage.css';

const FeaturesPage = () => {
  const features = [
    {
      icon: '⚡',
      title: 'Lightning Fast',
      description: 'Create short URLs instantly with our optimized infrastructure. No waiting, no delays.'
    },
    {
      icon: '🔒',
      title: 'Secure & Private',
      description: 'Your data is encrypted and protected. We never share your information with third parties.'
    },
    {
      icon: '📊',
      title: 'Click Analytics',
      description: 'Track how many times your links are clicked. Monitor your link performance in real-time.'
    },
    {
      icon: '🌐',
      title: 'Custom Short URLs',
      description: 'Create memorable, branded short links that reflect your identity.'
    },
    {
      icon: '📱',
      title: 'Mobile Friendly',
      description: 'Works perfectly on all devices. Shorten URLs on the go from your phone or tablet.'
    },
    {
      icon: '🔗',
      title: 'Link History',
      description: 'Access all your shortened URLs anytime. Your complete history saved to your account.'
    },
    {
      icon: '🚀',
      title: 'No Expiration',
      description: 'Your short links never expire. Share them confidently knowing they will always work.'
    },
    {
      icon: '🔑',
      title: 'API Access',
      description: 'Integrate URL shortening into your apps with our easy-to-use REST API.'
    }
  ];

  return (
    <div className="features-page">
      <div className="features-hero">
        <h1>Powerful Features</h1>
        <p>Everything you need to manage and share your links effectively</p>
      </div>

      <div className="features-grid">
        {features.map((feature, index) => (
          <div key={index} className="feature-card">
            <div className="feature-icon">{feature.icon}</div>
            <h3>{feature.title}</h3>
            <p>{feature.description}</p>
          </div>
        ))}
      </div>

      <div className="features-cta">
        <h2>Ready to get started?</h2>
        <p>Join thousands of users who trust NanoURL for their link management needs.</p>
        <a href="/auth" className="cta-button">Create Free Account</a>
      </div>
    </div>
  );
};

export default FeaturesPage;
