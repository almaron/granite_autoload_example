# frozen_string_literal: true

module AuthenticatableController
  extend ActiveSupport::Concern
  extend Memoist

  included do
    before_action :see_user
    helper_method :current_user
  end

  memoize def current_user
    User.all.sample
  end

  private def see_user
    current_user&.touch
  end
end
