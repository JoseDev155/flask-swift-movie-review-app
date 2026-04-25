from . import bcrypt

def hash_password(password: str) -> str:
    """Hashes a plaintext password."""
    return bcrypt.generate_password_hash(password).decode('utf-8')

def verify_password(password_hash: str, password: str) -> bool:
    """Verifies a plaintext password against a hash."""
    return bcrypt.check_password_hash(password_hash, password)
