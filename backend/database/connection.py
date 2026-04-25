import os

class Config:
    _SECRET_KEY = os.environ.get('SECRET_KEY')
    _JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY')
    _DB_USER = os.environ.get('DB_USER')
    _DB_PASSWORD = os.environ.get('DB_PASSWORD')
    _DB_HOST = os.environ.get('DB_HOST')
    _DB_PORT = os.environ.get('DB_PORT')
    _DB_NAME = os.environ.get('DB_NAME')
    _DB_DRIVER = os.environ.get('DB_PYTHON_DRIVER')

    # Construcción robusta de la URI de la base de datos
    # Solo se incluye el puerto si db_port tiene un valor
    port_part = f":{_DB_PORT}" if _DB_PORT else ""
    
    SQLALCHEMY_DATABASE_URI = f"{_DB_DRIVER}://{_DB_USER}:{_DB_PASSWORD}@{_DB_HOST}{port_part}/{_DB_NAME}"
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    SECRET_KEY = _SECRET_KEY
    JWT_SECRET_KEY = _JWT_SECRET_KEY

    # Configuración básica para flask-smorest (OpenAPI)
    API_TITLE = 'Movie Review API'
    API_VERSION = 'v1'
    OPENAPI_VERSION = '3.0.2'
    OPENAPI_URL_PREFIX = '/'
    OPENAPI_SWAGGER_UI_PATH = '/swagger-ui'
    OPENAPI_SWAGGER_UI_URL = 'https://cdn.jsdelivr.net/npm/swagger-ui-dist/'
