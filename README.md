# Coin App
## <strong>Section 1 - Creating a Ruby on Rails App and Showing Coin Prices</strong>
## Lecture 1 - Setting Up Cloud Development Environment
Create a new Github account. https://github.com/<br/>
Create a new Cloud9 account. https://ide.c9.io<br/>
Create a <strong>blank</strong> workspace on Cloud9<br/>
Check ruby version (if installed):
```
ruby -v
```
Check rails version (if installed):
```
rails -v
```
Install rails 5:
```
gem install rails 5
```
Check rails version:
```
rails -v
```

## Lecture 2 - Create A New Rails App With Homepage + GIT
Create a new rails app with a Postgresql database:<br/>
(rather than default SQLite3 database)
```
rails new coin_app --database=postgresql
```
Change into coin_app directory using UNIX command cd (change directory):
```
cd coin_app/
```
Start the rails server:<br/>
Note: The $CAPITALIZED_VARIABLES are environment variables
```
rails server -b $IP -p $PORT
```
Direct to the URL to view the web app.<br/>
Click on 'Share' near top right and copy the link to application URL:<br/>
E.g. Mine is: https://davids-workspace-davidprovestapps.c9users.io<br/>
It has the form: https://`<workspace>`-`<username>`.c9users.io<br/>
Observe the 'PG::ConnectionBad' error. This is due to the PG server not started.<br/>
Stop the server:
```
ctrl + C
```
Start the PG server (You may need to do this once every session):
```
sudo service postgresql start
```
Update the config/database.yml to use template0:
```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  template: template0
```
Use rails to create the databases (development and test):
```
rails db:create
```
Start the rails server and visit the URL to view your starter RoR web app:
```
rails server -b $IP -p $PORT
```
Generate a new controller using rails (convention over configuration principle).<br/>
This will create a homepage controller with index action and the associated view:
```
rails g controller Homepage index
```
We now have a homepage view at app/views/homepage/index.html.erb but<br/>
we need to add a root route to direct to it: (Rather than to the placeholder Rails page)<br/>
Update config/routes.rb file to:
```
Rails.application.routes.draw do
  get 'homepage/index'
  root 'homepage#index'
end
```
Start server and view the new homepage, doesn't look great yet.<br>
<strong>But you have created a Rails app!</strong><br>
Let's save our progress to GitHub. Create a new project on GitHub.<br/>
Add all the files to git, then commit your changes with a message:
```
git add .
git commit -m "Created A New Rails App With Homepage"
```
Now using the information provided on GitHub, add the remote link to the URL and push your code to it:
```
git remote add origin https://github.com/<your_username>/<your_project_name>.git
git push -u origin master
```
Enter your email and password credentials when prompted.<br/>
Refresh your GitHub page and see your code saved!<br/>

## Lecture 2.5 (Optional) - Connect to GIT via SSH<br/>(no entering password every GIT push)
SSH authenticates your device (the cloud computer) with your GIT repository.<br/> 
This means you do not need to enter a username and password each time you push your code to GIT.<br/>
<br/>
Go to https://c9.io/account/ssh and copy the key below *"Connect to your private git repository"*.<br/>
It is long string of text starting with ssh-rsa and ending with your email.<br/>
<br/>
Paste your C9 ssh key into your GitHub account at https://github.com/settings/keys then click New SSH key.<br/>
Enter Cloud9 as a title and paste the ssh key that you copied and click Add SSH key.<br/>
<br/>
Now we must update the remote path to GIT from HTTPS to SSH.<br/>
View your current remote (notice the https at the start of the URL):
```
git remote -v
```
Update your GIT remote with:
```
git remote set-url origin git@github.com:<your_username>/<your_project_name>.git
```
View your current remote (notice no https at the start of the URL):
```
git remote -v
```
Let's save the code to GIT.<br/>
Add all the files to git, then commit your changes with a message:
```
git add .
git commit -m "Connecting to GIT via SSH"
git push
```

## Lecture 3 - Add Bootstrap CSS Styling To Homepage 
We will add a Bootstrap navagation bar.<br/>
Helpful Bootstrap links:<br/>
* http://devdocs.io/bootstrap~4/
* https://getbootstrap.com/docs/4.0/components/

We will copy the top HTML from https://getbootstrap.com/docs/4.0/components/navbar/ and<br/>
paste it just above yield in app/views/layouts/application.html.erb:
```
<body>
    <!-- Paste Bootstrap navbar HTML here -->
    <%= yield %>
</body>
```
Start server and view the new homepage, you can see the navbar HTML but it doesn't look like the Bootstrap we copied it from.<br/>
We need to add Bootstrap to our Rails app using the gem at https://github.com/twbs/bootstrap-rubygem<br/>
Note: We are adding Boostrap 4 (beta) to Rails 5.<br/>
Add the bootstrap gem to the Gemfile and JQuery gem:
```
# Add Bootstrap 4 for CSS styling
gem 'bootstrap', '~> 4.0.0.beta2.1'
# Add JQuery as Rails 5 doesn't include this by default
gem 'jquery-rails'
```
Install the gems:
```
bundle install
```
Run the following command to rename the application.css to application.scss:<br/>
This changes the file extension.
```
mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss
```
Open the app/assets/stylesheets/application.scss and delete all its contents and add:
```
@import "bootstrap";
```
Open app/assets/javascripts/application.js above //= require_tree .:
```
//= require jquery3
//= require popper
//= require bootstrap-sprockets
```
Run the server and see the beautiful navbar!<br/>
<br/>
Time for our first refactor. We want to move the big chunk of navbar code out of the application html common code and into a component.<br/>
In Rails this is called a partial.<br/>
Create a new folder called shared under app/views.<br/>
Inside shared create a file _header.html.erb.<br/>
Cut the navbar HTML from app/views/layouts/application.html.erb and paste it in _header.html.erb <br/>
Now we want to render (show the code) from the partial in the application.html.erb:
```
<body>
    <%= render 'shared/header' %>
    <%= yield %>
</body>
```
Run the server and awesome we <strong>still</strong> have a pretty navbar.

## Lecture 4 - Show Current Coin Prices and Add Footer
Visit [https://min-api.cryptocompare.com/] and read the documentation.<br/>
We want to get the prices of multiple coins at once.<br/>
For example, to get the current price of Bitcoin and Ethereum (in USD, AUD and CNY) got to URL:<br/>
[https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH&tsyms=USD,AUD,CNY]<br/>
Now we need to get our web app to access this data and show it.<br/>
We need to first acknowledge the site which we are retriving the data from.<br/>
Inside app/views/shared folder create a file _footer.html.erb.<br/>
Add a footer HTML to the website (API) which we will get our coin prices from:
```
<footer class="footer">
  <div class="container">
    <p class="text-center"><a href="https://www.cryptocompare.com/api/">Powered with CryptoCompare Open API</a></p>
  </div>
</footer>
```
Update the app/views/layouts/application.html.erb to render the footer partial:
```
<body>
    <%= render 'shared/header' %>
    <%= yield %>
    <%= render 'shared/footer' %>
</body>
```
Start the server and see the footer link. It isn't pretty yet.<br/> 
Add footer CSS styling in app/assets/stylesheets/application.scss:
```
.footer {
  background-color: black;
  position: absolute;
  bottom: 0;
  width: 100%;
  height: 50px;
  line-height: 50px;
}
```
Start the server and see the pretty footer.<br/> 
We need to use HTTParty to talk to other websites and get the price data.<br/>
Let's use the integrated ruby environment (irb) in the terminal to learn HTTParty.<br/>
In terminal run:
```
irb
```
Now we are in the integrated ruby environment, to exit at anytime run:
```
quit
```
Start the integrated ruby environment and require the HTTParty gem:
```
require 'httparty'
```
Now lets make a request to the API (website) to find the current prices of some cryptocurrencies.<br/>
This is a RESTful GET request and returns JSON:
```
HTTParty.get('https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH&tsyms=USD,EUR')
```
We can change the format (called parsing) from JSON to a ruby hash,and store is in a variable x for later use:
```
x = HTTParty.get('https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH&tsyms=USD,EUR').parsed_response
```
Now to access just the BTC prices in both currencies:
```
x['BTC']
```
Or to access BTC in USD only:
```
x['BTC']['USD']
```
View the response of the current prices, how easy was that!<br/>
Quit the integrated ruby environment and let's get back to coding.<br/>
Add HTTParty gem to Gemfile:
```
# Add HTTParty for connecting to APIs
gem 'httparty'
```
Install the gem:
```
bundle install
```
The controller will access the data. Add the follow code to app/controllers/homepage_controller.rb:
```
include HTTParty
  def index
    @data = HTTParty.get('https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH&tsyms=USD,AUD,CNY')
  end
```
The view will show the data. Render the data below the heading in app/views/homepage/index.html.erb:
```
<%= @data %>
```
Start the server and see the data on the homepage.<br/> 
To make the data request more flexible we will split out the base website address, currencies and coins.<br/>
Update the app/controllers/homepage_controller.rb:
```
class HomepageController < ApplicationController
  include HTTParty
  BASE_URI = 'https://min-api.cryptocompare.com/data/pricemulti'
  DEFAULT_CURRENCIES = 'USD,AUD,CNY'
  DEFAULT_COINS = 'BTC,ETH,LTC'

  def index
    # GET request to external API service - returns JSON
    @data = HTTParty.get(BASE_URI,
            query: { fsyms: DEFAULT_COINS, tsyms: DEFAULT_CURRENCIES })
  end
end
```

## Lecture 5 - Adding User Authentication (Devise) + Adding Admin Users (Active Admin)
Add Devise gem to the Gemfile:
```
# For user authentication
gem 'devise', '~> 4.3'
```
Run bundle install to install new gem in Gemfile:
```
bundle install
```
Run devise generator (read the instruction output):
```
rails generate devise:install
```
Add the following to config/environments/development.rb:
```
# define default url options for mailer
config.action_mailer.default_url_options = { host: ENV['IP'], port: ENV['PORT'] }
```
We have already defined a root route.<br/>
Ensure you have flash message in app/views/layouts/application.html.erb:
```
<body>
    <%= render 'shared/header' %>
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
    <%= yield %>
    <%= render 'shared/footer' %>
</body>
```
Add Activeadmin gem to the Gemfile:
```
# For managing admins
gem 'activeadmin', '~> 1.1'

```
Run bundle install to install new gem in Gemfile:
```
bundle install
```
Run Activeadmin generator:
```
rails g active_admin:install
```
Look at the files generated (including admin migration file and seed admin)<br/>
Open db/seeds.rb and see the generator added a default admin at the bootm of the file.</br>
We <strong>ALWAYS</strong> want to change the default admin credentials, I will change mine to:
```
if Rails.env.development?
    AdminUser.create!(email: 'admin@example.com', password: 'password1', password_confirmation: 'password1')
end
```
Run database migrations (db/migrate/*):
```
rails db:migrate
```
Reset the databases:
```
rails db:reset
```
Start the server and got to URL/admin to view the admin login and try logging in.<br/>
We will not add a link to the admin page as it should only be visited by superusers.<br/>
Next we will add normal users.

## Lecture 6 - Adding Users
We add users using Devise generator:
```
rails generate devise User
```
Update the migration file `<timestamp>`_devise_create_users.rb to include firstname and lastname columns:
```
create_table :users do |t|
 ## Adding our own addtional columns to the User table
  t.string :first_name, null: false
  t.string :last_name, null: false
  
  ## Database authenticatable
  t.string :email,              null: false, default: ""
  t.string :encrypted_password, null: false, default: ""
  ...
```
Update the db/seeds.rb with a default user:
```
if Rails.env.development?
    AdminUser.create!(email: 'david@example.com', password: 'password1', password_confirmation: 'password1')
    User.create!(first_name: 'David', last_name: 'Provest', email: 'davidprovest@example.com', password: 'password1', password_confirmation: 'password1')
end
```
Run database migrations:
```
rails db:migrate
```
Reset the databases:
```
rails db:reset
```
Add links to Sign In and Sign Up in the header partial at app/views/shared/_header.html.erb:
Repalce:
```
<li class="nav-item dropdown">
    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      Dropdown
    </a>
    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
      <a class="dropdown-item" href="#">Action</a>
      <a class="dropdown-item" href="#">Another action</a>
      <div class="dropdown-divider"></div>
      <a class="dropdown-item" href="#">Something else here</a>
    </div>
</li>
```
With:
```
<li class="nav-item dropdown">
    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      Users
    </a>
    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
      <a class="dropdown-item" href="#">Sign In</a>
      <a class="dropdown-item" href="#">Sign Up</a>
    </div>
</li>
```
Start the server and observe the difference. We removed the divider and the 3rd item in the dropdown menu.<br/>
We also renamed Dropdown to Users, Action to Sign In and Another action to Sign Up.<br/>
Let's now change the HTML links to embedded ruby links:<br/>
Replace:
```
    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
      <a class="dropdown-item" href="#">Sign In</a>
      <a class="dropdown-item" href="#">Sign Up</a>
    </div>
```
With:
```
    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
      <%= link_to 'Sign In', new_user_session_path, { class: "dropdown-item" } %>
      <%= link_to 'Sign Up', new_user_registration_path, { class: "dropdown-item" } %>
    </div>
```
Awesome now we have users that can sign in and sign up.<br/>
Let's clean up the navbar.<br/>
Delete the disabled link in app/views/shared/_header.html.erb:
```
<li class="nav-item">
    <a class="nav-link disabled" href="#">Disabled</a>
</li>
```
Now we will use embedded ruby to show alternative navbar links dependent if the user is signed in or not.<br/>
If the user <strong>is</strong> signed in we want to show them their settings and a sign out link.<br/>
If the user <strong>is not</strong> signed in we want to show the user sign in and sign up options.<br/>
For the user settings we are using the Devise method current_user to get the current user and then the first name and interpolate it in the string.<br/>
Interpolation means insert a ruby object into a string but when it prints, it prints out the value of the variable into the text.<br/>
Update:
```
<li class="nav-item dropdown">
  <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    Users
  </a>
  <div class="dropdown-menu" aria-labelledby="navbarDropdown">
    <%= link_to 'Sign In', new_user_session_path, { class: "dropdown-item" } %>
    <%= link_to 'Sign Up', new_user_registration_path, { class: "dropdown-item" } %>
  </div>
</li>
```
To:
```
<li class="nav-item dropdown">
  <% if user_signed_in? %>
    <li class="nav-item">
      <%= link_to "#{current_user.first_name}\'s Settings", edit_user_registration_path, { class: "nav-link" } %>
    </li>
    <li class="nav-item">
       <%= link_to 'Sign Out', destroy_user_session_path, { method: :delete, class: "nav-link" } %>
    </li>
  <% else %>
    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      Users
    </a>
    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
      <%= link_to 'Sign In', new_user_session_path, { class: "dropdown-item" } %>
      <%= link_to 'Sign Up', new_user_registration_path, { class: "dropdown-item" } %>
    </div>
  <% end %>
</li>
```
## Lecture 7 - Graphing Coin Prices on Homepage
We will use the Chartkick gem to graph the coin prices.<br/>
Add the gem to the Gemfile:
```
# Adding charts
gem 'chartkick'
```
Install the gem:

```
bundle install
```
Now we need to include our links to Chart.JS libraries (could choose and equivalent like Google Charts).<br/>
Add them to app/assets/javascripts/application.js just above require_tree:
```
//= require Chart.bundle
//= require chartkick
```
Render an example pie chart at the bottom of app/views/homepage/index.html.erb:
```
<%= pie_chart [["Football", 10], ["Basketball", 5]] %>
```
Now we will render a bar chart which will show the current coin prices.<br/>
Add this to the bottom of app/views/homepage/index.html.erb:
```
<%= bar_chart @chart_data %>
```
Now we must make a value @chart_data in the controller with the data accessed by HTTParty.<br/>
Add a default denomaintion (defaults are always all-caps) as we will graph each coin price in just a single currency.<br/>
Add this under the other default values in app/controllers/homepage_controller.rb:
```
DENOMINATION = 'USD'
```
The data returned by HTTParty is JSON format and we would like to use a ruby hash instead.<br/>
A hash is a (key, value) pair. E.g. Name (key): David, Email (value): davidprovestexample@gmail.com.<br/>
For each coin_code (key) we will get the price (value) in USD.<br/>
Update the following code in app/controllers/homepage_controller.rb:
```
def index
  # GET request to external API service - returns JSON, parse it to be a ruby hash
  @data = HTTParty.get(BASE_URI,
          query: { fsyms: DEFAULT_COINS, tsyms: DEFAULT_CURRENCIES }).parsed_response
  
  # chartkick wants to receive an array as [coin_code, price]
  @chart_data = Array.new([])
  # For each coin get its price in the given denomination
  @data.each do |key, value|
    entry = [key, value[DENOMINATION]]
    @chart_data.push(entry)
  end
end
```
The footer is covering our chart, let's move it to the bottom of the webpage.<br/>
Add an extra class to the footer paragraph by modifying the below line in app/views/shared/_footer.html.erb:
```
<p class="text-center footer-p"><a href="https://www.cryptocompare.com/api/">Powered with CryptoCompare Open API</a></p>
```
Update the CSS in app/assets/stylesheets/application.scss to remove the absolute position attribute.<br/>
Add styling for the new footer-p class to have no bottom margin:
```
.footer {
  background-color: black;
  // position: absolute;
  bottom: 0;
  width: 100%;
  height: 50px;
  line-height: 50px;
}

.footer-p {
  margin-bottom: 0;
}
```
To customise the chart colours we create a file config/initializers/chartkick.rb and add the following:
```
Chartkick.options = {
  colors: ["#63b598", "#ce7d78", "#ea9e70", "#a48a9e", "#c6e1e8"]
}
```

## <strong>Section 2 - Historic Coin Price Charts and Homepage Styling</strong>
## Lecture 8 - Graphing Weekly History of Coin Prices
The current price of the coin is important, but we really want to see the historical performance of the coin.<br/>
Add a new histroical\_data variable to the index action in app/controllers/homepage_controller.rb:
```
# historic data - return data (exluding metadata) parsed as ruby hash
    @historic_data = HTTParty.get(HISTORIC_URI,
                     query: { fsym: 'BTC', tsym: 'USD' }).parsed_response['Data']
```
Now show the histroical data ruby hash on the view, app/views/homepage/index.html.erb:
```
<%= @historic_data %>
```
At this point we can delete the example pie chart in app/views/homepage/index.html.erb.<br/>
In the same file add a line chart below the bar chart:

```
<%= line_chart @coin_timeseries[key] %>
```
We cannot directly feed the historic\_data to the line_chart.<br/>
Instead we must format it in the app/controllers/homepage_controller.rb:
```
@timeseries_data = Hash.new
@historic_data.each do |entry|
  # For each timestamp (key) store the close price (value)
  # Also we must convert Unix time to Ruby DateTime
  @timeseries_data[Time.at(entry["time"])] = entry["close"]
end
```
Start the server and view the weekly data graphed for BTC in USD.<br/>
Create a new instance variable (@denomination) that is visible in the view rather than a local variable.<br/>
Update the app/controllers/homepage_controller.rb:
```
# need to expose denomination for chart axis
    @denomination = DENOMINATION
    # chartkick wants to receive an array as [coin_code, price]
    @chart_data = Array.new([])
    # For each coin get its price in the given denomination
    @data.each do |key, value|
      entry = [key, value[@denomination]]
      @chart_data.push(entry)
    end
```
Update the line chart in app/views/homepage/index.html.erb with axis titles:
```
<%= line_chart @timeseries_data, xtitle: "Date & Time", ytitle: '$'+@denomination %>
```
Just like we used partials to keep our views clean, we use helpers to move complexity out of our views.<br/>
Add the following method defintion to app/helpers/application_helper.rb:
```
module ApplicationHelper
  def coin_graph_title(coin, price)
    coin + " - Current Price (#{@denomination}): " + number_to_currency(price[@denomination]).to_s
  end
end
```
Now we must update the line chart to render with a title (calling the helper method).<br/>
Update the line chart in app/views/homepage/index.html.erb:

```
<%= line_chart @timeseries_data, title: coin_graph_title(coin, price), xtitle: "Date & Time", ytitle: '$'+@denomination %>
```
Or to keep our view even cleaner let's move the complexity to the helper.<br/>
Add a new method defintion to app/helpers/application_helper.rb for the chart:
```
def coin_line_chart
  line_chart @timeseries_data, title: coin_graph_title('BTC', @data['BTC']), xtitle: "Date & Time", ytitle: '$'+@denomination
end
```
Now replace the line\_chart with a call to the coin\_line_chart method in app/views/homepage/index.html.erb:
```
<%= coin_line_chart %>
```
Also in app/views/homepage/index.html.erb delete the placeholder heading and paragraph.<br/>
Insert the new header that is centered at the top instead:
```
<h1 class="text-center">Market Prices</h1>
```
In app/controllers/homepage_controller.rb we will create a new hash - remember this is a (key, value) pair.<br/>
This hash will use the coin code as the key and the value will be all the timeseries data for that coin.<br/>
We loop through for each coin code and get the historic data from the API and store it as the timeseries value:
```
  # create an array of coins. e.g. [BTC,ETH,LTC]
  @coins = DEFAULT_COINS.split(",")
  # create a hash
  # e.g. { "BTC"=>@timeseries_data_btc, "ETH"=>@timeseries_data_eth, "LTC"=>@timeseries_data_ltc }
  @coin_timeseries = Hash.new
  
  @coins.each do |coin|
    # historic data - return data (exluding metadata) parsed as ruby hash
    @historic_data = HTTParty.get(HISTORIC_URI,
                   query: { fsym: coin, tsym: 'USD' }).parsed_response['Data']
    
    @timeseries_data = Hash.new
    @historic_data.each do |entry|
      # For each timestamp (key) store the close price (value)
      # Also we must convert Unix time to Ruby DateTime
      @timeseries_data[Time.at(entry["time"])] = entry["close"]
    end
    # add the current coin's timeseries data to the hash
    @coin_timeseries[coin] = @timeseries_data
  end
```
Update the line\_chart in app/helpers/application_helper.rb:
```
line_chart @coin_timeseries['ETH'], title: coin_graph_title('ETH', @data['ETH']), xtitle: "Date & Time", ytitle: '$'+@denomination
```
We need to display charts for each coin code, lets update the helper and view.<br/>
First update the helper to accept the coin\_code as an argument in app/helpers/application_helper.rb:
```
def coin_line_chart(coin_code)
  line_chart @coin_timeseries[coin_code], title: coin_graph_title(coin_code, @data[coin_code]), xtitle: "Date & Time", ytitle: '$'+@denomination
end
```
Now we must update the view to render 3 graphs, one for each coin code.<br/>
At this stage we will delete the bar\_chart (as this data is shown in the title of the line\_chart).<br/>
And delete the rendering of the two ruby hashes (@data and @historic_data).<br/>
Update the code in app/views/homepage/index.html.erb:
```
<h1 class="text-center">Market Prices</h1>
<%= coin_line_chart('BTC') %>
<%= coin_line_chart('ETH') %>
<%= coin_line_chart('LTC') %>
```
We can now delete the @chart\_data from app/controllers/homepage_controller.rb.<br/>
Delete the following code:
```
# chartkick wants to receive an array as [coin_code, price]
    @chart_data = Array.new([])
    # For each coin get its price in the given denomination
    @data.each do |key, value|
      entry = [key, value[@denomination]]
      @chart_data.push(entry)
    end
```
Ruby on Rails uses DRY (Don't Repeat Yourself) pattern, which mean remove code duplication.<br/>
Imagine if we had 1000 charts to render we would need to have 1000 lines and more places for errors.<br/>
Let's add a for each loop to render the line charts, update the code in app/views/homepage/index.html.erb:
```
<h1 class="text-center">Market Prices</h1>
<% @coins.each do |coin_code| %>
    <%= coin_line_chart(coin_code) %>
<% end %>
```
Best practices are to make the chart a re-usable asset and to keep the main views clean.<br/>
Create a new file app/views/shared/_chart.html.erb which is a called a partial.<br/>
In the app/views/homepage/index.html.erb cut the below and paste it into the chart partial you just created:
```
<% @coins.each do |coin_code| %>
    <%= coin_line_chart(coin_code) %>
<% end %>
```
In the app/views/homepage/index.html.erb where you cut the above code put a reference to the chart partial:
```
<%= render 'shared/chart' %>
```

## Lecture 9 - Styling the Navbar 
Install Active\_link_to gem so we can highlight the current active link.<br/>
Add the gem to the Gemfile:
```
# Can highlight the active link
gem 'active_link_to'
```
Run bundle install:
```
bundle install
```
Create a new file app/stylesheets/custom.css.scss and add:
```
.navbar-light .navbar-nav .nav-link.active {
    color: black;
}
```
Update app/stylesheets/application.css.scss to:<br/>
The order of imports matters, as we want our custom CSS to override the bootstrap CSS.
```
@import "bootstrap";
@import "custom";
```
Currently 'Home' is always active.<br/>
Update Home with an active\_link and use the exclusive option to only match if it is exactly the root_path.<br/>
Replace:
```
<li class="nav-item active">
  <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
</li>
```
With:
```
<li class="nav-item">
  <%= active_link_to 'Home', root_path, { active: :exclusive, class: "nav-link" } %>
</li>
```
Update 'User's Settings' to be an active_link.<br/>
Replace:
```
<%= link_to "#{current_user.first_name}\'s Settings", edit_user_registration_path, { class: "nav-link" } %>
```
With:
```
<%= active_link_to "#{current_user.first_name}\'s Settings", edit_user_registration_path, { class: "nav-link" } %>
```
Update 'Users' dropdown to be an active_link and match any route that starts with /users (using regex).<br/>
Replace:
```
<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
  Users
</a>
```
With:
```
<%= active_link_to 'Users', '#', { class: 'nav-link dropdown-toggle', active: /^\/users/, id: 'navbarDropdown', role: 'button', 'data-toggle': 'dropdown', 'aria-haspopup': 'true', 'aria-expanded': 'false' } %>
```
Great, the navbar is looking and feeling much better. 

## Lecture 10 - Styling Home, User Sign Up and Login Pages
Now we will add a Jumbotron. This is a common landing page feature.<br/>
Add it to the top of the app/views/homepage/index.html.erb:
```
<div class="jumbotron">
  <h1 class="display-3">Hello, world!</h1>
  <p class="lead">This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.</p>
  <hr class="my-4">
  <p>It uses utility classes for typography and spacing to space content out within the larger container.</p>
  <p class="lead">
    <a class="btn btn-primary btn-lg" href="#" role="button">Learn more</a>
  </p>
</div>
```
We only want to show the jumbotron if the user is not signed in.<br/>
Update the jumbrotron code in app/views/homepage/index.html.erb:
```
<% if !user_signed_in? %>
  <div class="jumbotron">
    <h1 class="display-3">CryptoCoin</h1>
    <p class="lead">Welcome to the Cryptocurrency Practice Trader App</p>
    <hr class="my-4">
    <p>Use this app to emulate buying and selling cryptocurrencies and track your portfolio's performance.</p>
    <p class="lead">
      <%= link_to 'Sign Up', new_user_registration_path, { class: "btn btn-success btn-lg" } %>
      <%= link_to 'Log In', new_user_session_path, { class: "btn btn-primary btn-lg" } %>
    </p>
  </div>
<% end %>
```
To finish the homepage we need a logo image. Generate a favicon at: https://favicon.io/<br/>
Add the favicon.ico file to app/assets/images/<br/>
In app/views/shared/_header.html.erb, delete the navbar with anchor link:
```
<a class="navbar-brand" href="#">Navbar</a>
```
And replace it with a static logo image:
```
<a class="navbar-brand">
  <%= image_tag("favicon.ico", class: "img-thumbnail") %>
</a>
```
Let's update the user interface for the login and sign up.<br/>
Run the terminal command to generate the views using Devise:
```
rails generate devise:views users
```
You will now see a folder app/views/users that contains many folders.<br/>
The login view is app/views/users/sessions/new.html.erb.<br/>
Update the heading to include an exclamation mark:
```
<h2>Log in!</h2>
```
Now run the server and view the login page and you cannot see the exclamation.<br/>
Reading the documentation for Devise, we must add below to app/config/initializers/devise.rb:
```
config.scoped_views = true
```
Add a span to center the text and give it a nice font (thanks bootstrap) and we can remove the exclamation mark.<br/>
Add the span around the code in app/views/users/sessions/new.html.erb.<br/>
Note: the '...' represents the existing code, which we do not want to change:
```
<span class="text-center">
  <h2>Log in</h2>
  
  ...
  
</span>
```
Update the Sign In page too at app/views/users/registrations/new.html.erb:<br/>
```
<span class="text-center">

  ...
  
</span>
```
Add the above span to the app/views/users/registrations/edit.html.erb which is the user edit details page.<br/>
Add the above span to the app/views/users/passwords/new.html.erb which is the forgot password page.<br/>
Add the above span to the app/views/users/passwords/edit.html.erb which is the edit password page.<br/>
Add the above span to the app/views/users/confirmations/new.html.erb which is the resend confirmation page.<br/>
Add the above span to the app/views/users/unlocks/new.html.erb which is the  resend unlock instructions page.<br/>
Let's put a space (<\/br>) between the Sign Up button and password confirmation field:
```
    <div class="field">
      <%= f.label :password_confirmation %><br />
      <%= f.password_field :password_confirmation, autocomplete: "off" %>
    </div>
    <br/>
    <div class="actions">
      <%= f.submit "Sign up" %>
    </div>
```
Now all our user views are formatted nicely. 

## Lecture 11 - Add Loading Spinners to Charts
Add to the Gemfile:
```
# Renders partials to your views asynchronously 
gem 'render_async'
```
Run:
```
bundle install
```
Now we will follow the 5 steps in order at https://github.com/renderedtext/render_async<br/>
First in app/views/controllers/homepage\_controller.rb, rename the index action to coin_data:
```
def coin_data
```
Then in the same controller make a new blank action for index:
```
def index
end
```
Include render_async in the view app/views/homepage/index.html.erb:
```
<%= render_async homepage_coin_data_path do %>
  <h1 class="text-center">Charts are loading...</h1>
<% end %>
```
Create a route for the new coin_data action we just defined:
```
get 'homepage/coin_data'
```
Add the call to render the partial at the bottom of the coin_data action.<br>
Add the code to the controller, app/views/controllers/homepage\_controller.rb:
```
def coin_data
    
  ...
  
  render :partial => "chart"
end
```
This will render the partial homepage/_chart.html.erb.<br/>
So we need to move our _chart.html.erb from the app/views/shared folder to app/views/homepage folder.<br/>
Restart the server and view how much faster the page loads (the slow part is the API call over the network).<br/>
Let's get really fancy now and add a cool spinner as our charts load.<br/>
Go to http://tobiasahlin.com/spinkit/ to view the different spinner options and copy the source code of your favourite.<br/>
Paste the code at the bottom of app/assets/stylesheets/custom.css.scss:<br/>
Note: Choose your fave spinner, I just chosse the square because it was my fave.
```
// Spinner CSS
.spinner {
  width: 40px;
  height: 40px;
  background-color: #333;

  margin: 100px auto;
  -webkit-animation: sk-rotateplane 1.2s infinite ease-in-out;
  animation: sk-rotateplane 1.2s infinite ease-in-out;
}

@-webkit-keyframes sk-rotateplane {
  0% { -webkit-transform: perspective(120px) }
  50% { -webkit-transform: perspective(120px) rotateY(180deg) }
  100% { -webkit-transform: perspective(120px) rotateY(180deg)  rotateX(180deg) }
}

@keyframes sk-rotateplane {
  0% {
    transform: perspective(120px) rotateX(0deg) rotateY(0deg);
    -webkit-transform: perspective(120px) rotateX(0deg) rotateY(0deg)
  } 50% {
    transform: perspective(120px) rotateX(-180.1deg) rotateY(0deg);
    -webkit-transform: perspective(120px) rotateX(-180.1deg) rotateY(0deg)
  } 100% {
    transform: perspective(120px) rotateX(-180deg) rotateY(-179.9deg);
    -webkit-transform: perspective(120px) rotateX(-180deg) rotateY(-179.9deg);
  }
}
```
Add the spinner class below the chart loading text, it will place the moving icon in this position.<br/>
Update the app/views/homepage/index.html.erb:
```
<%= render_async homepage_coin_data_path do %>
  <h1 class="text-center">Charts are loading...</h1>
  <div class="spinner"></div>
<% end %>
```
The charts will now load with your favourite spinner!<br/>
Also at this point let's clean up app/assets/stylesheets/application.scss<br/>
Move the footer and footer-p CSS to the app/assets/stylesheets/custom.css.scss so it only has the @imports remaining.<br/>
Congratulations! You have created an application that accesses data from another website (an API).<br/>
Your application lets users sign in and shows charts that load asynchronously (instead of slowing the app loading).<br/>