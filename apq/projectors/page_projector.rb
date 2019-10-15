class PageProjector < BaseProjector
  get(:page, as: '') do
    @assigns = projector.get_data_assigns
  end

  post(:performed, as: '') do
    action.perform!

    flash.notice = projector.flash_success_message

    respond_to do |format|
      format.html { projector.redirect_path ? redirect_back_or_to(projector.redirect_path) : projector.respond_html }
      format.json do
        render json: projector.final_success_response
      end
    end
  end

  template_accessible def title_text
    t('.title_text', humanized_model_name: humanized_model_name)
  end

  template_accessible def flash_success_message
    t('.success', humanized_model_name: humanized_model_name)
  end

  def get_data_assigns
    {}
  end

  def index_path
    h.polymorphic_path(model_class)
  end

  def respond_html; end

  def redirect_path; end

  private

  def button_action_url
    page_path
  end

  def final_success_response
    {
      message: flash_success_message
    }
  end

  def model_class
    if action.respond_to?(:subject)
      action.subject.class
    else
      self.class.to_s.split('::').reject { |c| c == 'BA' }.first.constantize
    end
  end

  def humanized_model_name
    t('.humanized_model_name')
  end
end
