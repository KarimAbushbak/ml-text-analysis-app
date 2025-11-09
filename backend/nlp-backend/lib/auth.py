"""
API Key authentication for the NLP API
"""
from fastapi import Security, HTTPException, status
from fastapi.security import APIKeyHeader
import os
from dotenv import load_dotenv

load_dotenv()

# API Key configuration
API_KEY_NAME = "X-API-Key"
API_KEY = os.getenv("API_KEY", "dev-key-12345-change-in-production")

# Create API Key header security scheme
api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=False)


async def get_api_key(api_key: str = Security(api_key_header)):
    """
    Validate API key from request header
    
    Usage in routes:
        @router.post("/protected")
        async def protected_route(api_key: str = Depends(get_api_key)):
            ...
    """
    if not api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="API Key missing. Please provide X-API-Key header."
        )
    
    if api_key != API_KEY:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid API Key"
        )
    
    return api_key


# Optional: Multiple API keys with different permissions
API_KEYS = {
    os.getenv("API_KEY_ADMIN", "admin-key-12345"): {
        "name": "admin", 
        "rate_limit": "100/minute"
    },
    os.getenv("API_KEY_USER", "user-key-12345"): {
        "name": "user", 
        "rate_limit": "20/minute"
    },
    os.getenv("API_KEY_DEV", "dev-key-12345"): {
        "name": "dev", 
        "rate_limit": "1000/minute"
    },
}


async def get_api_key_advanced(api_key: str = Security(api_key_header)):
    """
    Advanced API key validation with user info
    Returns user information along with validation
    Useful for implementing per-user rate limits
    """
    if not api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="API Key missing"
        )
    
    if api_key not in API_KEYS:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid API Key"
        )
    
    return API_KEYS[api_key]

