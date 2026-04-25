from flask import request
from . import movie_bp
from services import MovieService
from flask_jwt_extended import jwt_required

@movie_bp.route('/', methods=['GET'])
def get_movies():
    response, status = MovieService.get_all_movies()
    return response, status

@movie_bp.route('/popular', methods=['GET'])
def get_popular_movies():
    page = request.args.get('page', default=1, type=int)
    response, status = MovieService.get_popular_movies(page=page)
    return response, status

@movie_bp.route('/upcoming', methods=['GET'])
def get_upcoming_movies():
    page = request.args.get('page', default=1, type=int)
    response, status = MovieService.get_upcoming_movies(page=page)
    return response, status

@movie_bp.route('/search', methods=['GET'])
def search_movies():
    page = request.args.get('page', default=1, type=int)
    query = request.args.get('query', default='', type=str)
    response, status = MovieService.search_movies(query, page=page)
    return response, status

@movie_bp.route('/', methods=['POST'])
@jwt_required()
def add_movie():
    data = request.get_json()
    response, status = MovieService.add_movie(data)
    return response, status

@movie_bp.route('/<int:api_id>', methods=['GET'])
def get_movie(api_id):
    response, status = MovieService.get_movie_by_api_id(api_id)
    return response, status

@movie_bp.route('/<int:api_id>', methods=['PUT'])
@jwt_required()
def update_movie(api_id):
    data = request.get_json()
    response, status = MovieService.update_movie(api_id, data)
    return response, status

@movie_bp.route('/<int:api_id>', methods=['DELETE'])
@jwt_required()
def delete_movie(api_id):
    response, status = MovieService.delete_movie(api_id)
    return response, status
