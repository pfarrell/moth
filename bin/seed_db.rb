require './app'

user = User.find_or_create(name: 'root', email: 'patf@patf.net')
user.set_password('root')
user.save

application = Application.find_or_create(name: 'moth', redirect: '../', homepage: '/')
application.add_user user

