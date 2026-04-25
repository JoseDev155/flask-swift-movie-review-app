from flask import request
from . import favorite_bp
from services import FavoriteService
from flask_jwt_extended import jwt_required, get_jwt_identity

@favorite_bp.route('/', methods=['GET'])
@jwt_required()
def get_favorites():
    user_id = get_jwt_identity()
    response, status = FavoriteService.get_user_favorites(int(user_id))
    return response, status

@favorite_bp.route('/', methods=['POST'])
@jwt_required()
def add_favorite():
    user_id = get_jwt_identity()
    data = request.get_json()
    response, status = FavoriteService.add_favorite(int(user_id), data)
    return response, status

@favorite_bp.route('/<int:api_id>', methods=['DELETE'])
@jwt_required()
def remove_favorite(api_id):
    user_id = get_jwt_identity()
    response, status = FavoriteService.remove_favorite(int(user_id), api_id)
    return response, status
