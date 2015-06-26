
1. Prerequisites
____________________________________________________
  1.1. mysql-server-5.6 or newer
        $ sudo apt-get install mysql-server-5.6
  1.2. libsaxon-java 
  		$ sudo apt-get install libsaxon-java
____________________________________________________

2. Setup mailer for production environments
____________________________________________________

  2.1. go to "library/config/environments"
  2.2. open the "production.rb" file in any text editor
  2.3. on line 82 set your host site (config.action_mailer.default_url_options = { :host => 'yoursite.com' })
  2.4. save the file and close it
____________________________________________________

3. Setup database
____________________________________________________

    3.1. go to "library/config"
    3.2. open the "database.yml" file in any text editor
    3.3. insert your username, password and host
    3.4. save the file and close it

____________________________________________________

4. Setup admin account
____________________________________________________

  4.1. go to "library/db"
  4.2. open the "seeds.rb" file in any text editor
  4.3. find "Admin.create!" and setup admins email a password
  4.4. save the file and close it

____________________________________________________

5. Install RVM, Ruby and Ruby on Rails
____________________________________________________

    5.1. execute "./bin/install_rvm.sh"
    5.2. execute "./bin/install_ruby_on_rails.sh"
    5.3. go to "library" folder and execute "./bin/setup"
____________________________________________________

6. Apache installation (skip if you use the rails server in development environment)
____________________________________________________

	# install Apache
	6.1. $ sudo apt-get install apache2

	# Setup Phusion Passenger
	# Tutorial from: https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#install_on_debian_ubuntu

	# Install PGP key
	6.2. $ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7

	# Add HTTPS support for APT
	6.3. $ sudo apt-get install apt-transport-https ca-certificates

	6.4. Create a file /etc/apt/sources.list.d/passenger.list and insert one of the following lines, depending on your distribution. 
		##### !!!! Only add ONE of these lines, not all of them !!!! #####
		# Ubuntu 14.04
		deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main
		# Ubuntu 12.04
		deb https://oss-binaries.phusionpassenger.com/apt/passenger precise main
		# Ubuntu 10.04
		deb https://oss-binaries.phusionpassenger.com/apt/passenger lucid main
		# Debian 7
		deb https://oss-binaries.phusionpassenger.com/apt/passenger wheezy main
		# Debian 6
		deb https://oss-binaries.phusionpassenger.com/apt/passenger squeeze main

	# Secure passenger.list and update your APT cache: 
	6.5. $ sudo chown root: /etc/apt/sources.list.d/passenger.list
	6.6. $ sudo chmod 640 /etc/apt/sources.list.d/passenger.list
	6.7. $ sudo apt-get update

	# Installing Passenger packages
	6.8. $ sudo apt-get install libapache2-mod-passenger
	# Enable the Phusion Passenger Apache module and restart Apache 
	6.9. $ sudo a2enmod passenger
	

	6.10. Setup apache conf file according to https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html#_configuring_phusion_passenger

	6.11. Generate secret key
	 $ rake secret
	6.12. Put secret key into /etc/apache2/envvars:
	 export SECRET_KEY_BASE=<generated_secret_key>

	6.13. Precompile CSS and JS files
	 $ rake assets:precompile --trace

	6.14. Restart Apache
	    $ sudo /etc/init.d/apache2 restart
____________________________________________________

7. Setup rails server (skip if you use Apache)
____________________________________________________

    7.1. go to "library/config/environments"
    7.2. open the "development.rb"
    7.3. on the line 10 uncomment 'config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }'
    7.4. on the line 9 comment 'config.action_mailer.default_url_options = { host: 'localhost', port: 80 }'
    7.5. Run server
     	$ rails server 
____________________________________________________

8. How to run the acceptance test suite
____________________________________________________

	8.1. execute "./bin/prepare_test_database.sh"

	8.2. run all acceptance tests
		$  cucumber features

	8.3. run specific feature from acceptance tests
		$  cucumber features/<selected_feature>

	8.4. run all unit tests
		$  rake test

	8.5. run specific unit test
		$ rake test test/controllers/<test>
  		$ rake test test/models/<test>




