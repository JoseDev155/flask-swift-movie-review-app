import json
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen

from flask import current_app


def _request_tmdb(path: str, query: dict[str, object]):
    api_key = current_app.config.get('TMDB_API_KEY')
    if not api_key:
        return None, {"error": "TMDB_API_KEY no configurada"}, 503

    base_url = current_app.config.get('TMDB_BASE_URL', 'https://api.themoviedb.org/3').rstrip('/')
    language = current_app.config.get('TMDB_LANGUAGE', 'es-ES')
    request_query = {'api_key': api_key, 'language': language}
    request_query.update({key: value for key, value in query.items() if value is not None})
    url = f'{base_url}{path}?{urlencode(request_query)}'

    request = Request(url, headers={'Accept': 'application/json'})

    try:
        with urlopen(request, timeout=10) as response:
            payload = json.load(response)
    except HTTPError as error:
        if error.code == 404:
            return None, {"error": "Película no encontrada en TMDB"}, 404

        if error.code in (401, 403):
            return None, {"error": "No fue posible autenticar la consulta a TMDB"}, 502

        return None, {"error": "No se pudo consultar TMDB"}, 502
    except URLError:
        return None, {"error": "No se pudo conectar con TMDB"}, 502

    return payload, None, 200


def fetch_movie_details(api_id: int):
    return _request_tmdb(f'/movie/{api_id}', {})


def fetch_movies_page(path: str, page: int = 1, search_query: str | None = None):
    query = {'page': page}
    if search_query:
        query['query'] = search_query

    return _request_tmdb(path, query)