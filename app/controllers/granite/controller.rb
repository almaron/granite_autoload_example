require 'granite/projector/translations/helper'

module Granite
  class Controller < ::ApplicationController
    include Granite::Projector::Translations::Helper

    singleton_class.__send__(:attr_accessor, :projector_class)
    singleton_class.delegate :projector_path, :projector_name, :action_class, to: :projector_class
    delegate :projector_path, :projector_name, :action_class, :projector_class, to: 'self.class'

    abstract!

    around_action :setup_granite_view_context
    before_action :authorize_action!

    def projector
      @projector ||= begin
        action_projector_class = action_class.public_send(projector_name)
        action_projector_class = action_projector_class.as(projector_performer) if respond_to?(:projector_performer, true)
        action_projector_class.new(projector_params)
      end
    end
    helper_method :projector

    delegate :action, to: :projector
    helper_method :action

    def self.local_prefixes
      [projector_path]
    end

    private

    def projector_params
      params
    end

    def authorize_action!
      action.authorize!
    end

    def setup_granite_view_context(&block)
      Granite.with_view_context(view_context, &block)
    end
  end
end
