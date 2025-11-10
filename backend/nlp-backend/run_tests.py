#!/usr/bin/env python
"""
Convenient test runner script
Runs pytest with common configurations
"""
import sys
import subprocess


def run_tests(args=None):
    """
    Run tests with pytest
    
    Usage:
        python run_tests.py              # Run all tests
        python run_tests.py -v           # Verbose output
        python run_tests.py -k test_name # Run specific test
        python run_tests.py --markers    # Show available markers
    """
    cmd = [sys.executable, "-m", "pytest"]  # Use python -m pytest for Windows compatibility
    
    if args:
        cmd.extend(args)
    else:
        # Default: run all tests with coverage
        cmd.extend([
            "-v",              # Verbose
            "--tb=short",      # Short traceback format
            "--cov=lib",       # Coverage for lib directory
            "--cov-report=term-missing",  # Show missing lines
        ])
    
    print("=" * 70)
    print("Running NLP Backend Tests")
    print("=" * 70)
    print(f"Command: {' '.join(cmd)}\n")
    
    result = subprocess.run(cmd)
    return result.returncode


if __name__ == "__main__":
    sys.exit(run_tests(sys.argv[1:]))

