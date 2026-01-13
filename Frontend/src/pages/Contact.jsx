import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './Contact.css';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

export default function Contact() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    subject: '',
    message: ''
  });
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.name || !formData.email || !formData.subject || !formData.message) {
      setError('All fields are required');
      return;
    }

    setLoading(true);
    setError('');

    try {
      const response = await fetch(`${API_URL}/api/contact`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      const data = await response.json();

      if (data.success) {
        setSubmitted(true);
        setFormData({ name: '', email: '', subject: '', message: '' });
        setTimeout(() => setSubmitted(false), 5000);
      } else {
        setError(data.message || 'Failed to send message');
      }
    } catch (err) {
      setError('Failed to send message. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="contact-page">
      <button className="back-btn" onClick={() => navigate(-1)}>← Back</button>
      
      <div className="contact-container">
        <div className="contact-header">
          <h1>Get in Touch</h1>
          <p>Have questions? We'd love to hear from you. Send us a message and we'll respond as soon as possible.</p>
        </div>

        <div className="contact-content">
          <div className="contact-info-section">
            <h2>Contact Information</h2>
            
            <div className="info-item">
              <div className="info-icon">📧</div>
              <div>
                <h3>Email</h3>
                <p><a href="mailto:hetps2122004@gmail.com">hetps2122004@gmail.com</a></p>
              </div>
            </div>

            <div className="info-item">
              <div className="info-icon">📞</div>
              <div>
                <h3>Phone</h3>
                <p><a href="tel:+919724226612">+91 9724226612</a></p>
              </div>
            </div>

            <div className="info-item">
              <div className="info-icon">📍</div>
              <div>
                <h3>Address</h3>
                <p>Tech Hub, Innovation District<br/>Ahmedabad, Gujarat 380021<br/>India</p>
              </div>
            </div>

            <div className="info-item">
              <div className="info-icon">⏰</div>
              <div>
                <h3>Business Hours</h3>
                <p>Monday - Friday: 9:00 AM - 6:00 PM<br/>Saturday: 10:00 AM - 4:00 PM<br/>Sunday: Closed</p>
              </div>
            </div>
          </div>

          <div className="contact-form-section">
            <h2>Send us a Message</h2>
            
            {submitted && (
              <div className="success-message">
                ✓ Thank you! Your message has been sent successfully. We'll get back to you soon.
              </div>
            )}

            {error && (
              <div className="error-message">
                ✗ {error}
              </div>
            )}

            <form className="contact-form" onSubmit={handleSubmit}>
              <div className="form-group">
                <label htmlFor="name">Full Name</label>
                <input
                  type="text"
                  id="name"
                  name="name"
                  value={formData.name}
                  onChange={handleChange}
                  placeholder="Your name"
                  required
                />
              </div>

              <div className="form-group">
                <label htmlFor="email">Email Address</label>
                <input
                  type="email"
                  id="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  placeholder="your@email.com"
                  required
                />
              </div>

              <div className="form-group">
                <label htmlFor="subject">Subject</label>
                <input
                  type="text"
                  id="subject"
                  name="subject"
                  value={formData.subject}
                  onChange={handleChange}
                  placeholder="What is this about?"
                  required
                />
              </div>

              <div className="form-group">
                <label htmlFor="message">Message</label>
                <textarea
                  id="message"
                  name="message"
                  value={formData.message}
                  onChange={handleChange}
                  placeholder="Tell us your thoughts, questions, or concerns..."
                  rows="6"
                  required
                />
              </div>

              <button type="submit" className="submit-btn" disabled={loading}>
                {loading ? 'Sending...' : 'Send Message'}
              </button>
            </form>
          </div>
        </div>

        <div className="faq-section">
          <h2>Frequently Asked Questions</h2>
          <div className="faq-grid">
            <div className="faq-item">
              <h4>How quickly will I get a response?</h4>
              <p>We aim to respond to all inquiries within 24-48 hours during business days.</p>
            </div>
            <div className="faq-item">
              <h4>Do you offer technical support?</h4>
              <p>Yes, our technical support team is available to help with any issues you may encounter.</p>
            </div>
            <div className="faq-item">
              <h4>Can I request a feature?</h4>
              <p>Absolutely! We love hearing suggestions. Please include your ideas in your message.</p>
            </div>
            <div className="faq-item">
              <h4>Is my data safe?</h4>
              <p>Yes, we prioritize security and encrypt all data. See our Privacy Policy for details.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
