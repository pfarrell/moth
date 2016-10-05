require './app'

application = Application.find_or_create(name: 'Developer Login')
application.redirect = '../'
application.homepage = '../'
application.save

