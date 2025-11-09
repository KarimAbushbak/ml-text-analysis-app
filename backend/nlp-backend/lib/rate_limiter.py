"""
Rate limiting configuration for API endpoints
"""
from slowapi import Limiter
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
from fastapi import Request
from fastapi.responses import JSONResponse


# Initialize rate limiter
# This tracks requests by IP address and enforces limits
limiter = Limiter(
    key_func=get_remote_address,  # Rate limit by IP address
    default_limits=["100/minute"]  # Default: 100 requests per minute per IP
)


# Custom rate limit exceeded handler
async def rate_limit_handler(request: Request, exc: RateLimitExceeded):
    """
    Custom handler for rate limit exceeded errors
    Returns user-friendly JSON response instead of HTML error page
    """
    return JSONResponse(
        status_code=429,
        content={
            "error": "Rate limit exceeded",
            "message": "Too many requests. Please try again later.",
            "detail": str(exc.detail)
        }
    )

