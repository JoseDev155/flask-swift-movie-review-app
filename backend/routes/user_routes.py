from flask import request
from routes import user_bp
from services import UserService
from flask_jwt_extended import jwt_required, get_jwt_identity

@user_bp.route('/profile', methods=['GET'])
@jwt_required()
def get_profile():
    user_id = get_jwt_identity()
    response, status = UserService.get_user_profile(int(user_id))
    return response, status

@user_bp.route('/profile', methods=['PUT'])
@jwt_required()
def update_profile():
    user_id = get_jwt_identity()
    data = request.get_json()
    response, status = UserService.update_profile(int(user_id), data)
    return response, status

@user_bp.route('/profile', methods=['DELETE'])
@jwt_required()
def delete_profile():
    user_id = get_jwt_identity()
    response, status = UserService.delete_account(int(user_id))
    return response, status
