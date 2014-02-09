

native:
	@echo
	@echo ' Start MongoDB'
	sudo service mongodb restart

install-mongodb-ubuntu:
	@echo '   '
	@echo '   If this doesnt work, look here for instructions: http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/'
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
	echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
	sudo apt-get update
	sudo apt-get install mongodb-10gen

test-all:
	./node_modules/.bin/mocha test/* --compilers coffee:coffee-script/register