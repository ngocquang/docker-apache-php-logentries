docker-apache-php-logentries
================
# Web Server Image for our production container: #

- Apache with Mod_rewrite enable
- PHP 5.6 with PDO, MySQL, Redis, Memcache Extension
- Supervisord to monitor apache process to prevent failure
- Logentries

# Environment Variables #
- CONFIG_URL
- LOGENTRIES_TOKEN

# Binding code directory for development #
- If you want to mount your developing source code directory to running container (to prevent re-build each time when code change), you can mount volumn from your source code directory to "/var/www/site/".
`
    docker run ... -v /path/to/source/code:/var/www/site/
`
# Example Run #
- Normal start web server:
    `
    $ > docker run -ti -d -p 8080:80 -h webserver -e CONFIG_URL="http://configurl/" -e LOGENTRIES_TOKEN="Token" --name web01 ngocquang/docker-apache-php-logentries
    `

# Docker Hub Repository #
- You can pull from my image at: https://hub.docker.com/r/ngocquang/docker-apache-php-logentries/
    `
    $ > docker pull ngocquang/docker-apache-php-logentries
    `
