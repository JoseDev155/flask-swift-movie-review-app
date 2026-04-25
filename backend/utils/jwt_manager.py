from flask_jwt_extended import create_access_token, create_refresh_token, decode_token

def generate_tokens(identity: str):
    # Generates both access and refresh tokens for a user identity
    access_token = create_access_token(identity=identity)
    refresh_token = create_refresh_token(identity=identity)
    return {
        'access_token': access_token,
        'refresh_token': refresh_token
    }

def decode_jwt_token(token: str):
    # Decodes a JWT token
    return decode_token(token)
