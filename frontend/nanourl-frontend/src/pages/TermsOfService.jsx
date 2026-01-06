import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './TermsOfService.css';

export default function TermsOfService() {
  const navigate = useNavigate();

  return (
    <div className="policy-container">
      <div className="policy-content">
        <button className="back-btn" onClick={() => navigate(-1)}>← Back</button>
        
        <div className="policy-header">
          <h1>Terms of Service</h1>
          <p className="policy-date">Last updated: January 2026</p>
        </div>

        <div className="policy-sections">
          <section className="policy-section">
            <h2>1. Agreement to Terms</h2>
            <p>
              By accessing and using NanoURL, you accept and agree to be bound by the terms and provision of this agreement. 
              If you do not agree to abide by the above, please do not use this service. NanoURL reserves the right to make 
              changes to these terms at any time, and your continued use of the site following the posting of revised terms means 
              that you accept and agree to the changes.
            </p>
          </section>

          <section className="policy-section">
            <h2>2. Use License</h2>
            <p>
              Permission is granted to temporarily download one copy of the materials (information or software) on NanoURL for 
              personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under 
              this license you may not:
            </p>
            <ul>
              <li>Modify or copy the materials</li>
              <li>Use the materials for any commercial purpose or for any public display</li>
              <li>Attempt to decompile or reverse engineer any software contained on the site</li>
              <li>Remove any copyright or other proprietary notations from the materials</li>
              <li>Transfer the materials to another person or "mirror" the materials on any other server</li>
              <li>Use automated tools to access or monitor the site without express written permission</li>
            </ul>
          </section>

          <section className="policy-section">
            <h2>3. Disclaimer</h2>
            <p>
              The materials on NanoURL's website are provided "as is". NanoURL makes no warranties, expressed or implied, and 
              hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions 
              of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other 
              violation of rights.
            </p>
          </section>

          <section className="policy-section">
            <h2>4. Limitations</h2>
            <p>
              In no event shall NanoURL or its suppliers be liable for any damages (including, without limitation, damages for 
              loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials 
              on NanoURL, even if NanoURL or an authorized representative has been notified orally or in writing of the possibility 
              of such damage.
            </p>
          </section>

          <section className="policy-section">
            <h2>5. Accuracy of Materials</h2>
            <p>
              The materials appearing on NanoURL's website could include technical, typographical, or photographic errors. NanoURL 
              does not warrant that any of the materials on the website are accurate, complete, or current. NanoURL may make changes 
              to the materials contained on its website at any time without notice.
            </p>
          </section>

          <section className="policy-section">
            <h2>6. Links</h2>
            <p>
              NanoURL has not reviewed all of the sites linked to its website and is not responsible for the contents of any such 
              linked site. The inclusion of any link does not imply endorsement by NanoURL of the site. Use of any such linked website 
              is at the user's own risk.
            </p>
          </section>

          <section className="policy-section">
            <h2>7. Modifications</h2>
            <p>
              NanoURL may revise these terms of service for the website at any time without notice. By using this website, you are 
              agreeing to be bound by the then current version of these terms of service.
            </p>
          </section>

          <section className="policy-section">
            <h2>8. Governing Law</h2>
            <p>
              These terms and conditions are governed by and construed in accordance with the laws of the jurisdiction in which 
              NanoURL operates, and you irrevocably submit to the exclusive jurisdiction of the courts in that location.
            </p>
          </section>

          <section className="policy-section">
            <h2>9. User Content</h2>
            <p>
              Any URLs or data you submit to NanoURL becomes our property, and we may use it without restriction. You represent and 
              warrant that you own or have the necessary rights to the URLs you shorten and that they do not violate any third-party 
              rights or applicable laws.
            </p>
          </section>

          <section className="policy-section">
            <h2>10. Prohibited Activities</h2>
            <p>
              You agree not to use NanoURL for any of the following purposes:
            </p>
            <ul>
              <li>Violating any laws or regulations</li>
              <li>Infringing intellectual property rights</li>
              <li>Spreading malware or harmful content</li>
              <li>Creating shortened URLs for phishing or fraud</li>
              <li>Harassing or abusing other users</li>
              <li>Spamming or sending unsolicited communications</li>
              <li>Attempting unauthorized access to our systems</li>
            </ul>
          </section>

          <section className="policy-section">
            <h2>11. Account Security</h2>
            <p>
              You are responsible for maintaining the confidentiality of your account credentials and for all activities that 
              occur under your account. You agree to notify NanoURL immediately of any unauthorized use of your account.
            </p>
          </section>

          <section className="policy-section">
            <h2>12. Termination</h2>
            <p>
              NanoURL reserves the right to terminate your account and access to the service at any time, for any reason, with or 
              without notice. Upon termination, your right to use the service will cease immediately.
            </p>
          </section>

          <section className="policy-section">
            <h2>13. Contact Information</h2>
            <p>
              If you have any questions about these Terms of Service, please contact us at:
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
