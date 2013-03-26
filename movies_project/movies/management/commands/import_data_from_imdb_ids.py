from movies.functions import (get_movie_id_from_tmdb_from_imdb_id,
                              add_to_list_from_db)

from django.core.management.base import BaseCommand

class Command(BaseCommand):
    help = 'Import data from IMDB ids'

    def handle(self, *args, **options):
        user_id = 3
        list_id = 1

        imdb_ids = '''

        '''
        imdb_ids = imdb_ids.split('\n')
        for imdb_id in imdb_ids:
            imdb_id = imdb_id.strip()
            if imdb_id:
                id = get_movie_id_from_tmdb_from_imdb_id(imdb_id)
                if id:
                    result = add_to_list_from_db(id, list_id, user_id)
                    if result:
                        print('%s - error #%d' % (imdb_id, result))
                    else:
                        print('%s - done' % imdb_id)
                else:
                    print('%s - movie not found in TMDB' % imdb_id)
