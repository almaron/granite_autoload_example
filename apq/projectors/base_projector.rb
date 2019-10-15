class BaseProjector < Granite::Projector
  extend Memoist

  controller_class.class_eval do
    extend Memoist

    prepend_view_path(
      [
        Rails.root.join('apq', 'actions'),
        Rails.root.join('apq', 'projectors')
      ]
    )
  end

  def self.as_system
    as(::Role.system)
  end

  def self.perform_with(action, &block)
    block ||= proc { do_perform }
    public_send(action, :perform, as: '', &block)
  end

  def self.template_accessible(name)
    controller_class.delegate name, to: :projector
    controller_class.helper_method name
  end

  def self.template_accessibles(*names)
    names.each(&method(:template_accessible))
  end

  template_accessible def subject
    @subject ||= action.subject&.decorated
  end

  # @return [String]
  def notice_text
    t('.notice', display_name: display_name)
  end

  def display_name
    return unless action.respond_to?(:subject)

    %i[display_name title name to_s].each do |name|
      return subject.public_send(name) if subject.respond_to?(name)
    end
  end

  def build_action(*args)
    action_class.as(self.class.proxy_performer || h.current_user).new(*args)
  end
end
