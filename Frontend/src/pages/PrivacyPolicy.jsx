import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './PrivacyPolicy.css';

export default function PrivacyPolicy() {
  const navigate = useNavigate();

  return (
    <div className="policy-container">
      <div className="policy-content">
        <button className="back-btn" onClick={() => navigate(-1)}>← Back</button>
        
        <div className="policy-header">
          <h1>Privacy Policy</h1>
          <p className="policy-date">Last updated: January 2026</p>
        </div>

        <div className="policy-sections">
          <section className="policy-section">
            <h2>1. Introduction</h2>
            <p>
              NanoURL ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains 
              how we collect, use, disclose, and safeguard your information when you visit our website and use our 
              URL shortening services.
            </p>
          </section>

          <section className="policy-section">
            <h2>2. Information We Collect</h2>
            <p>
              We may collect information about you in a variety of ways. The information we may collect on the Site includes:
            </p>
            <ul>
              <li><strong>Personal Data:</strong> Name, email address, contact number, and account credentials</li>
              <li><strong>Usage Data:</strong> Information about how you interact with our service</li>
              <li><strong>Technical Data:</strong> IP address, browser type, device information, and log files</li>
              <li><strong>URL Data:</strong> Original URLs you shorten and analytics about their usage</li>
            </ul>
          </section>

          <section className="policy-section">
            <h2>3. How We Use Your Information</h2>
            <p>
              We use the information we collect in the following ways:
            </p>
            <ul>
              <li>To create and manage your user account</li>
              <li>To provide, maintain, and improve our services</li>
              <li>To send you service-related announcements and updates</li>
              <li>To respond to your inquiries and provide customer support</li>
              <li>To analyze usage patterns and improve user experience</li>
              <li>To prevent fraudulent transactions and secure our services</li>
            </ul>
          </section>

          <section className="policy-section">
            <h2>4. Information Sharing</h2>
            <p>
              We do not sell, trade, or rent your personal information to third parties. We may share information only:
            </p>
            <ul>
              <li>With your explicit consent</li>
              <li>When required by law or legal process</li>
              <li>To protect the rights, privacy, safety, or property of our company and users</li>
              <li>With service providers who assist us in operating our website</li>
            </ul>
          </section>

          <section className="policy-section">
            <h2>5. Data Security</h2>
            <p>
              We implement appropriate technical and organizational measures designed to maintain the security of your 
              personal information. However, no method of transmission over the Internet or electronic storage is completely 
              secure. While we strive to use commercially acceptable means to protect your personal data, we cannot guarantee 
              absolute security.
            </p>
          </section>

          <section className="policy-section">
            <h2>6. Cookies and Tracking Technologies</h2>
            <p>
              NanoURL uses cookies and similar tracking technologies to enhance your experience. These may include:
            </p>
            <ul>
              <li><strong>Session Cookies:</strong> Temporary cookies that expire when you close your browser</li>
              <li><strong>Persistent Cookies:</strong> Cookies that remain on your device for a specified period</li>
              <li><strong>Analytics:</strong> Tools to understand how users interact with our service</li>
            </ul>
          </section>

          <section className="policy-section">
            <h2>7. Your Rights</h2>
            <p>
              Depending on your location, you may have the following rights:
            </p>
            <ul>
              <li>Right to access your personal data</li>
              <li>Right to correct inaccurate information</li>
              <li>Right to request deletion of your data</li>
              <li>Right to opt-out of marketing communications</li>
              <li>Right to data portability</li>
            </ul>
          </section>

          <section className="policy-section">
            <h2>8. Data Retention</h2>
            <p>
              We retain your personal information for as long as necessary to provide our services and fulfill the purposes 
              outlined in this Privacy Policy. You can request deletion of your account and data at any time through your 
              account settings.
            </p>
          </section>

          <section className="policy-section">
            <h2>9. Third-Party Links</h2>
            <p>
              NanoURL may contain links to third-party websites. We are not responsible for the privacy practices of these 
              external sites. We encourage you to review their privacy policies before providing any personal information.
            </p>
          </section>

          <section className="policy-section">
            <h2>10. Children's Privacy</h2>
            <p>
              NanoURL is not intended for users under the age of 13. We do not knowingly collect personal information from 
              children under 13. If we become aware that we have collected such information, we will delete it promptly.
            </p>
          </section>

          <section className="policy-section">
            <h2>11. Contact Us</h2>
            <p>
              If you have questions about this Privacy Policy or our privacy practices, please contact us at:
            </p>
            <div className="contact-info">
              <p><strong>Email:</strong> hetps2122004@gmail.com</p>
              <p><strong>Support Page:</strong> Visit our <a href="/contact">+91 9724226612</a></p>
            </div>
          </section>
        </div>
      </div>
    </div>
  );
}
