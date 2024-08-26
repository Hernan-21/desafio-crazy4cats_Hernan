# db/seeds.rb
require 'faker'

# Limpiar la base de datos existente
puts "Limpiando la base de datos..."
Reaction.destroy_all
Comment.destroy_all
Post.destroy_all
User.destroy_all

# Crear usuarios
puts "Creando usuarios..."
5.times do
  User.create!(
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password'
  )
end

# Crear posts
puts "Creando posts..."
users = User.all
20.times do
  post = Post.create!(
    title: Faker::Lorem.sentence,
    content: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
    user: users.sample
  )

  # Crear comentarios para cada post
  puts "Creando comentarios para el post #{post.id}..."
  rand(5..10).times do
    Comment.create!(
      content: Faker::Lorem.paragraph,
      post: post,
      user: [users.sample, nil].sample # 50% de probabilidad de ser anónimo
    )
  end

  # Crear reacciones para cada post
  puts "Creando reacciones para el post #{post.id}..."
  users.sample(rand(1..5)).each do |user|
    Reaction.create!(
      reaction_type: [:like, :dislike].sample,
      post: post,
      user: user
    )
  end
end

puts "Seed completado!"
