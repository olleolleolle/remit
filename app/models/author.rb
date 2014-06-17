# Pair commits provide name and email but no username.
# Regular commits provide all three.
# Comment webhooks only include a username, no email or name.

class Author < ActiveRecord::Base
  validate :has_at_least_one_property

  def self.create_or_update_from_payload(payload)
    payload = payload.symbolize_keys

    name, email, username = payload.values_at(:name, :email, :username)

    existing_author = where("email = ? OR username = ?", email, username).first

    author = existing_author || Author.new
    author.name = name if name
    author.email = email if email
    author.username = username if username
    author.save!

    author
  end

  private

  def has_at_least_one_property
    return if name? || email? || username?
    errors.add(:base, "Must have name or email or username.")
  end
end
