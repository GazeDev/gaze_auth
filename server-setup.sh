# before you can do this, you will need git to easily get this repo
# run:
# sudo apt install git

# digital ocean has a droplet with docker and docker-compose installed
# if you aren't using that, you will need to install them as well
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04

sudo apt install nginx-full -y

sudo vim /etc/nginx/sites-available/mastodon

# Edit this to look like the mastodon nginx config file below.

sudo cd /etc/nginx/sites-enabled
sudo ln -sf ../sites-available/mastodon .

# to enable the new configuration...

sudo nginx -t

# To check for typos in you file. If you get no errors, you can restart nginx:

sudo service nginx restart

# Let's Encrypt

sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot
