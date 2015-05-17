#Create ANT_HOME location
export ANT_HOME=<%= scope['config::ant_home'] %>
export PATH=$PATH:$ANT_HOME/bin