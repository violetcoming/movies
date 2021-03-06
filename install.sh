./installation_settings.sh

pip install -r requirements.txt
bower install

#create scripts

mkdir scripts
echo "cat /dev/null > $PWD/movies_project/cache/tmdb3.cache" >> scripts/update_movie_data.sh
echo "$PYTHON_PATH/python $PWD/movies_project/manage.py update_movie_data" >> scripts/update_movie_data.sh
chmod +x scripts/update_movie_data.sh

#create logs dir
mkdir logs

#install crontab records
crontab -l > crontab
echo "0 0 * * * $PYTHON_PATH/python $PWD/movies_project/manage.py update_vk_profiles > $PWD/logs/update_vk_profiles.log 2>&1" > crontab
echo "0 0 1 * * $PYTHON_PATH/python $PWD/scripts/update_movie_data.sh > $PWD/logs/update_movie_data.log 2>&1" > crontab
crontab crontab
rm crontab

#create cache dirs
mkdir movies_project/cache
cd movies_project/cache
touch tmdb3.cache
chmod 777 tmdb3.cache

cd ..
./manage.py syncdb
./manage.py collectstatic
