# frozen_string_literal: true

class BA::User::Create < BaseAction
  projector :page do
    def index_path
      h.root_path
    end

    def redirect_path
      h.root_path
    end
  end

  allow_if { true }

  represents :name, :email, of: :user

  memoize def user
    User.new
  end

  private

  def execute_perform!(*)
    subject.save!
  end
end
