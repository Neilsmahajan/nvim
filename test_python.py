#!/usr/bin/env python3
"""Test Python file to verify LSP functionality."""

def hello_world(name: str) -> str:
    """Return a greeting message.
    
    Args:
        name: The name to greet.
        
    Returns:
        A greeting message.
    """
    return f"Hello, {name}!"


def main():
    """Main function."""
    message = hello_world("World")
    print(message)
    
    # This should show a type error in LSP
    # result = hello_world(123)  # Uncomment to test type checking


if __name__ == "__main__":
    main()
