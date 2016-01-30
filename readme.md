RUC Search - Episode 4

## Start server
supervisor -e 'html|jade|less|coffee' node coffee/server.coffee

## Modules
* https://github.com/EvanOxfeld/node-unzip
* elasticsearch


## Elasticsearch
* https://www.elastic.co/guide/en/elasticsearch/client/javascript-api/current/api-reference-2-2.html
* https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html



### Npm modules 
npm i --save browserify-shim caching-coffeeify connect connect-livereload serve-static serve-index cordova-lib del gulp gulp-autoprefixer gulp-cache gulp-coffee gulp-csso gulp-filter gulp-flatten gulp-imagemin gulp-jshint gulp-less gulp-livereload gulp-load-plugins gulp-notify gulp-run gulp-size gulp-sourcemaps gulp-uglify gulp-useref gulp-util jshint-stylish main-bower-files opn pretty-hrtime vinyl-source-stream watchify wiredep serve-static serve-index coffee-script

### Server
/home/sun/.nvm/v5.4.1/bin/node
rsync -chavP --exclude 'node_modules' dist server node_modules lib 107.170.166.67:~/ruc4


### PM2
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-14-04
sudo su -c "env PATH=$PATH:/home/sun/.nvm/v5.4.1/bin pm2 startup ubuntu -u sun --hp /home/sun"
pm2 start ruc4/server/ruc4-server.coffee
pm2 list
pm2 stop ruc4-server
pm2 restart ruc4-server
pm2 info ruc4-server
pm2 monit
* Logs in ~/.pm2/logs

# Create temporary swap file to index
https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-12-04
sudo dd if=/dev/zero of=/swapfile bs=1024 count=2048k
sudo mkswap /swapfile
sudo swapon /swapfile

### Nginx conf
/etc/nginx/sites-available/default
sudo service nginx restart

curl -XDELETE 'http://localhost:9200/ruc-1454100420930/'
