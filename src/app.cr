DATABASE_URL = ENV.fetch("DATABASE_URL", "sqlite3://./contacts.sqlite")
Granite::Connections << Granite::Adapter::Sqlite.new(name: "contacts_app_db", url: DATABASE_URL)

require "kemal"
require "./models/contact"

get "/" do |context|
  context.redirect("/contacts")
end

get "/contacts" do |context|
  search = context.params.query["q"]?
  contacts = if search.nil? || search.strip == ""
               Contact.order(first_name: :asc)
             else
               Contact.where(:first_name, :like, "%#{search}%")
                 .or(:last_name, :like, "%#{search}%")
                 .or(:email, :like, "%#{search}%")
                 .order(first_name: :asc)
             end
  render("#{__DIR__}/views/index.ecr", "#{__DIR__}/views/layout.ecr")
end

get "/contacts/new" do |context|
  contact = Contact.new
  render("#{__DIR__}/views/new.ecr", "#{__DIR__}/views/layout.ecr")
end

post "/contacts/new" do |context|
  contact = Contact.new(context.params.body.to_h)
  if contact.save
    context.redirect("/contacts")
  else
    render("#{__DIR__}/views/new.ecr", "#{__DIR__}/views/layout.ecr")
  end
end

get "/contacts/:contact_id" do |context|
  contact = Contact.find(context.params.url["contact_id"])
  if contact.nil?
    context.response.status_code = 404
    "Contact #{context.params.url["contact_id"]} not found."
  else
    render("#{__DIR__}/views/show.ecr", "#{__DIR__}/views/layout.ecr")
  end
end

get "/contacts/:contact_id/edit" do |context|
  contact = Contact.find(context.params.url["contact_id"])
  if contact.nil?
    context.response.status_code = 404
    "Contact #{context.params.url["contact_id"]} not found."
  else
    "#{contact.last_name}, #{contact.first_name} <#{contact.email}>"
    render("#{__DIR__}/views/edit.ecr", "#{__DIR__}/views/layout.ecr")
  end
end

post "/contacts/:contact_id/edit" do |context|
  contact = Contact.find(context.params.url["contact_id"])
  if contact.nil?
    context.response.status_code = 404
    "Contact #{context.params.url["contact_id"]} not found."
  elsif contact.update(context.params.body.to_h)
    context.redirect("/contacts/#{contact.id}")
  else
    render("#{__DIR__}/views/edit.ecr", "#{__DIR__}/views/layout.ecr")
  end
end

post "/contacts/:contact_id/delete" do |context|
  contact = Contact.find(context.params.url["contact_id"])
  if contact.nil?
    context.response.status_code = 404
    "Contact #{context.params.url["contact_id"]} not found."
  else
    contact.destroy
    context.redirect("/contacts")
  end
end

Kemal.run do |config|
  server = config.server.not_nil!
  server.bind_tcp "0.0.0.0", 5001, reuse_port: true
end
