require "granite/adapter/sqlite"

class Contact < Granite::Base
  connection contacts_app_db
  table contacts

  column id : Int64, primary: true
  column first_name : String?
  column last_name : String?
  column email : String?
  column phone : String?

  timestamps

  validate_not_blank :first_name
  validate_not_blank :last_name
  validate_not_blank :email
  validate_uniqueness :email

  def errors_for(field : String) : Array(String)
    errors.select { |error| error.field == field }.map { |error| error.message }.compact
  end
end
