# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(name:"Admin",slug:"admin",email:"admin@gmail.com",password:"admin1234",status:1)
role = Role.create(role_name:"Super Admin",slug:"admin",status:1)
permission = Permission.create(permission_name:"admin",permission_slug:"admin",status:1)

UserRolePermission.create(user_id:user.id,role_id:role.id,permission_id:permission.id)

