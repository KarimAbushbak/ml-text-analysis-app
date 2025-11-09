# Environment Setup Guide

## Creating Your .env File

Since `.env` files contain secrets, they are gitignored. You need to create your own.

### Step 1: Create .env file

In the `backend/nlp-backend/` directory, create a file named `.env`:

```bash
cd backend/nlp-backend
touch .env  # On Linux/Mac
# or
type nul > .env  # On Windows
```

### Step 2: Add Configuration

Copy and paste this content into your `.env` file:

```env
# Environment Configuration
ENVIRONMENT=development

# CORS - Allowed Origins (comma-separated, no spaces)
ALLOWED_ORIGINS=http://localhost:8000,http://10.0.2.2:8000,http://127.0.0.1:8000,http://localhost:3000

# API Key (change this to a secure random string in production)
API_KEY=dev-key-12345-change-in-production
API_KEY_ADMIN=admin-key-12345
API_KEY_USER=user-key-12345
API_KEY_DEV=dev-key-12345

# Server Configuration
HOST=0.0.0.0
PORT=8000
```

### Step 3: Generate Secure API Keys for Production

For production, generate secure random keys:

```bash
# On Python
python -c "import secrets; print(secrets.token_urlsafe(32))"

# On Linux/Mac
openssl rand -base64 32
```

Replace the example keys with generated ones!

### Important Security Notes

⚠️ **NEVER commit .env to version control!**
⚠️ **Change all default keys before deploying to production!**
⚠️ **Use different keys for different environments (dev/staging/prod)**

## Environment Variables Explained

- `ENVIRONMENT`: Set to "development", "staging", or "production"
- `ALLOWED_ORIGINS`: Comma-separated list of allowed CORS origins
- `API_KEY`: Secret key for API authentication
- `HOST`: Server host address (0.0.0.0 allows external connections)
- `PORT`: Server port number

