require 'byebug' 

# defines ActiveRecord models
# defined DATABASE_PATH
require_relative("./db_setup.rb")
require_relative("./metatagger.rb")

class Commands

# Custom stuff

  def search(query, page=0)
    ap Metatagger.search(query, page)
  end

  def search_wikipedia(query, page=0)
    ap Metatagger.search_site("wikipedia.org", query, page)
  end

  def search_site(site, query, page=0)
    ap Metatagger.search_site(site, query, page)
  end


# Standard stuff

    # make sure this method accepts a hash argument, which is passed from OptionParser
  def initialize(options={})
    # test db connection
    Todo.count rescue migrate
    puts "try 'help'".yellow
  end
  def hello_world(msg="")
    # a sample event, call it with hello_world
    puts "hello_world #{msg}"
    return { foo: :bar }
  end
  def migrate
    puts "migrating".green_on_black
    Migrations.migrate(:up)
  end
end