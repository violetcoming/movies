#Movies

The web application on Python2/Django/CoffeeScript/jQuery to create movie lists ("watched" and "to watch"), to share these lists along with ratings and comments. 
The interface is in Russian.

##Used APIs
* [TMDb](http://www.themoviedb.org/) (Requires API Key)
* [OMDb](http://www.omdbapi.com/)
* [2torrents.org](http://2torrents.org)
 
##Installation instructions

* Change/Add the following variables in settings.py:
    * DATABASES
    * TMDB_KEY
    * VK_APP_ID
    * VK_APP_SECRET
* Insert your analytics code to movies_project/static/js/analytics.js if you'd like
* Change variable in installation_settings.sh
* Run install.sh
* Import db.sql to your database.
* Run deploy.sh to deploy 
* You can delete movies_project/static/src directory after deployment.