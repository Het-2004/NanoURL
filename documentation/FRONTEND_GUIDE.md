# 🎨 Frontend Guide - Complete Setup & Configuration

## React Frontend Setup, Development, and Deployment

---

## **Part 1: Frontend Overview**

### Technology Stack
- **Framework:** React 19
- **Build Tool:** Vite
- **Language:** JavaScript
- **Package Manager:** npm
- **State Management:** Context API
- **HTTP Client:** Axios
- **Authentication:** JWT (localStorage)

### Project Structure

```
frontend/nanourl-frontend/
├── src/
│   ├── components/
│   │   ├── FeaturesModal.jsx
│   │   ├── Header.jsx
│   │   ├── History.jsx
│   │   ├── Result.jsx
│   │   └── UrlShortener.jsx
│   ├── pages/
│   │   ├── AuthPage.jsx
│   │   ├── Contact.jsx
│   │   ├── FeaturesPage.jsx
│   │   ├── HistoryPage.jsx
│   │   ├── PrivacyPolicy.jsx
│   │   └── TermsOfService.jsx
│   ├── context/
│   │   └── AuthContext.jsx
│   ├── hooks/
│   │   └── useUrlHistory.js
│   ├── services/
│   │   └── api.js
│   ├── App.jsx
│   ├── main.jsx
│   └── index.css
├── public/
├── package.json
├── vite.config.js
└── eslint.config.js
```

---

## **Part 2: Installation & Setup**

### Step 1: Navigate to Frontend

```bash
cd frontend/nanourl-frontend
```

### Step 2: Install Dependencies

```bash
npm install
```

This installs all packages from `package.json`:
- React & ReactDOM
- Axios (HTTP client)
- Vite (build tool)
- ESLint (code linter)

### Step 3: Start Development Server

```bash
npm run dev
```

Expected output:
```
VITE v4.x.x ready in XXX ms

➜  Local:   http://localhost:5173/
➜  press h to show help
```

### Step 4: Open in Browser

Open: **http://localhost:5173**

You should see the NanoURL frontend!

---

## **Part 3: Frontend Configuration**

### API URL Configuration

Edit **`src/services/api.js`:**

**Development:**
```javascript
const API_BASE = 'http://localhost:8080';
```

**Production:**
```javascript
const API_BASE = 'https://nanourl-backend.onrender.com';
```

Or use environment variables:

**Create `.env` file:**
```env
VITE_API_URL=http://localhost:8080
```

**Use in code:**
```javascript
const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:8080';
```

### Environment Files

Create different `.env` files:

**.env.development:**
```env
VITE_API_URL=http://localhost:8080
VITE_APP_NAME=NanoURL Dev
```

**.env.production:**
```env
VITE_API_URL=https://nanourl-backend.onrender.com
VITE_APP_NAME=NanoURL
```

### Build Configuration

**vite.config.js:**
```javascript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    strictPort: false
  },
  build: {
    outDir: 'dist',
    sourcemap: false
  }
})
```

---

## **Part 4: Component Guide**

### AuthContext (State Management)

**`src/context/AuthContext.jsx`**

Manages:
- User authentication state
- Login/signup/logout
- Token storage
- User data

**Usage:**
```javascript
import { useAuth } from '../context/AuthContext';

function MyComponent() {
  const { user, token, login, logout } = useAuth();
  
  return <div>{user?.email}</div>;
}
```

### API Service

**`src/services/api.js`**

Axios instance configured with:
- Base URL from environment
- JWT token in headers
- Error handling
- Request/response interceptors

**Usage:**
```javascript
import api from '../services/api';

// Get user's URLs
api.get('/api/urls/history')
  .then(res => console.log(res.data))
  .catch(err => console.error(err));
```

### useUrlHistory Hook

**`src/hooks/useUrlHistory.js`**

Custom hook for:
- Fetching user's shortened URLs
- Deleting URLs
- Caching results
- Error handling

**Usage:**
```javascript
import useUrlHistory from '../hooks/useUrlHistory';

function HistoryPage() {
  const { urls, loading, error, deleteUrl } = useUrlHistory();
  
  return (
    <div>
      {urls.map(url => (
        <div key={url.id}>
          {url.shortCode} → {url.longUrl}
          <button onClick={() => deleteUrl(url.id)}>Delete</button>
        </div>
      ))}
    </div>
  );
}
```

---

## **Part 5: Pages Overview**

### AuthPage (Login/Signup)

- Login form
- Signup form
- Email/password validation
- JWT token storage
- Error messages

**File:** `src/pages/AuthPage.jsx`

### FeaturesPage

- Shows all features
- Features modal
- Visual examples
- Feature descriptions

**File:** `src/pages/FeaturesPage.jsx`

### HistoryPage

- Lists user's shortened URLs
- Shows click counts
- Copy to clipboard
- Delete URLs
- Access shortcuts

**File:** `src/pages/HistoryPage.jsx`

### Contact Page

- Contact form
- Name, email, message
- Form validation
- Success/error messages

**File:** `src/pages/Contact.jsx`

### Policy Pages

- Privacy Policy
- Terms of Service
- Legal information

**Files:** `src/pages/PrivacyPolicy.jsx`, `src/pages/TermsOfService.jsx`

---

## **Part 6: Styling**

### CSS Files

```
src/
├── App.css ...................... App styles
├── index.css .................... Global styles
├── components/
│   ├── FeaturesModal.css ........ Modal styles
│   └── Result.css ............... Result styles
└── pages/
    ├── AuthPage.css ............ Login/Signup styles
    ├── Contact.css ............. Contact form
    ├── FeaturesPage.css ........ Features page
    ├── HistoryPage.css ......... History page
    ├── PrivacyPolicy.css ....... Privacy styles
    └── TermsOfService.css ...... Terms styles
```

### Tailwind/Utility Classes

If using utility classes:
```javascript
<div className="flex justify-center items-center h-full">
  <button className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded">
    Click me
  </button>
</div>
```

### Responsive Design

Make sure CSS includes media queries:
```css
@media (max-width: 768px) {
  /* Mobile styles */
  .container {
    padding: 10px;
  }
}
```

---

## **Part 7: Development Workflow**

### Common npm Commands

```bash
# Start development
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run linter
npm run lint

# Fix lint errors
npm run lint --fix
```

### Hot Module Replacement (HMR)

Vite provides HMR by default:
- Save a file
- Browser auto-updates
- No full page reload needed
- Very fast!

### Debugging

**Browser DevTools:**
1. Open browser DevTools (F12)
2. Go to "Sources" tab
3. Set breakpoints
4. Step through code

**Console Logging:**
```javascript
console.log('Debug:', data);
console.error('Error:', error);
console.warn('Warning:', message);
```

---

## **Part 8: Authentication Flow**

### Login Flow

1. User enters email/password
2. Frontend sends to `/api/auth/login`
3. Backend returns JWT token
4. Frontend stores token in localStorage
5. Token sent in Authorization header for future requests

### Token Management

```javascript
// Store token
localStorage.setItem('token', token);

// Get token
const token = localStorage.getItem('token');

// Send with requests
headers: {
  Authorization: `Bearer ${token}`
}

// Remove on logout
localStorage.removeItem('token');
```

### Protected Routes

```javascript
function ProtectedRoute({ children }) {
  const { token } = useAuth();
  
  if (!token) {
    return <Navigate to="/auth" />;
  }
  
  return children;
}

// Usage
<Route 
  path="/history" 
  element={<ProtectedRoute><HistoryPage /></ProtectedRoute>} 
/>
```

---

## **Part 9: Building for Production**

### Build Command

```bash
npm run build
```

Creates `dist/` folder with:
- Minified JavaScript
- Optimized CSS
- Bundled assets
- Production-ready files

### Build Output

```
dist/
├── index.html
├── assets/
│   ├── main-xxxxx.js (minified code)
│   └── index-xxxxx.css (minified styles)
└── favicon.ico
```

### Optimizations Applied

✅ Code minification  
✅ CSS optimization  
✅ Asset compression  
✅ Tree shaking (unused code removal)  
✅ Source map generation (for debugging)  

---

## **Part 10: Deployment to Render**

### Step 1: Prepare for Deployment

**Update API URL in production:**

Edit `.env.production`:
```env
VITE_API_URL=https://your-backend-url.onrender.com
```

### Step 2: Push to GitHub

```bash
git add .
git commit -m "Update production API URL"
git push origin main
```

### Step 3: Create Static Site on Render

1. Go to https://render.com
2. Click "New +" → "Static Site"
3. Connect GitHub repository
4. Select your repository

### Step 4: Configure

**Build Settings:**
- Build Command: `cd frontend/nanourl-frontend && npm install && npm run build`
- Publish Directory: `frontend/nanourl-frontend/dist`

**Environment Variables:**
```
VITE_API_URL=https://your-backend-url.onrender.com
```

### Step 5: Deploy

Click "Create Static Site"

Wait for build to complete (2-3 minutes)

Your frontend is now live! 🚀

---

## **Part 11: Performance Optimization**

### Code Splitting

```javascript
import { lazy, Suspense } from 'react';

const HistoryPage = lazy(() => import('./pages/HistoryPage'));

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <HistoryPage />
    </Suspense>
  );
}
```

### Memoization

```javascript
import { memo } from 'react';

const UrlItem = memo(function UrlItem({ url, onDelete }) {
  return (
    <div>
      {url.shortCode}
      <button onClick={() => onDelete(url.id)}>Delete</button>
    </div>
  );
});
```

### useCallback Hook

```javascript
const handleDelete = useCallback((id) => {
  deleteUrl(id);
}, [deleteUrl]);
```

### Image Optimization

```javascript
<img 
  src="image.jpg" 
  alt="Description"
  loading="lazy"
  width="300"
  height="200"
/>
```

---

## **Part 12: Testing**

### Manual Testing

1. Test signup/login
2. Create short URL
3. Copy and redirect
4. View history
5. Delete URL
6. Logout
7. Test all pages

### Automated Testing (Optional)

Install testing library:
```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom
```

---

## **Part 13: Troubleshooting**

### Issue: "npm install" fails
**Solution:**
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules
rm -r node_modules

# Reinstall
npm install
```

### Issue: "Port 5173 already in use"
**Solution:**
```bash
# Use different port
npm run dev -- --port 5174
```

### Issue: CORS errors
**Solution:**
1. Check backend CORS configuration
2. Check API URL matches backend
3. Check WebConfig.java has correct origin

### Issue: Login fails
**Solution:**
1. Check backend is running
2. Check credentials are correct
3. Check network tab in DevTools
4. Verify API endpoint exists

### Issue: Build fails
**Solution:**
```bash
# Check for errors
npm run build

# Fix issues shown
# Rebuild
npm run build
```

---

## **Part 14: Browser Support**

### Supported Browsers

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

### Check Browser Compatibility

```javascript
// Check localStorage support
if (typeof(Storage) === "undefined") {
  console.warn("localStorage not supported");
}
```

---

## **Part 15: Security Best Practices**

### Never Commit Secrets

**`.gitignore`:**
```
.env.local
.env.*.local
node_modules/
dist/
```

### Secure Token Storage

```javascript
// ✅ Good: Use token from secure source
const token = localStorage.getItem('token');

// ❌ Avoid: Storing sensitive data
localStorage.setItem('password', password);
```

### Input Validation

```javascript
// ✅ Good: Validate before sending
function validateEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

// Use it
if (validateEmail(email)) {
  login(email, password);
}
```

### Content Security

```javascript
// ✅ Good: Escape HTML
function escapeHtml(text) {
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;'
  };
  return text.replace(/[&<>]/g, m => map[m]);
}
```

---

## **Quick Commands**

```bash
# Development
npm run dev

# Production build
npm run build

# Preview build
npm run preview

# Lint code
npm run lint
```

---

## **Useful Resources**

- React Docs: https://react.dev
- Vite Docs: https://vitejs.dev
- Axios Docs: https://axios-http.com
- MDN Web Docs: https://developer.mozilla.org

---

## **More Documentation**

- Backend Setup: [BACKEND_GUIDE.md](BACKEND_GUIDE.md)
- Security Guide: [SECURITY_GUIDE.md](SECURITY_GUIDE.md)
- Database: [MYSQL_COMPLETE_SETUP.md](MYSQL_COMPLETE_SETUP.md)
- Deployment: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- All Docs: [README.md](README.md)

---

**Frontend setup complete! Happy coding! 🎨🚀**
