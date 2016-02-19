class ViewablePresenter < BasePresenter
  def edit_link(name = nil)
    return unless h.cms_edit_mode?

    h.link_to edit_path, edit_options do
      h.concat h.content_tag(:span, h.t('cms.edit'), class: "cms-edit-action")
      h.concat " "
      name = name.is_a?(Symbol) ? m.__send__(name) : name
      h.concat h.content_tag(:span, name, class: "cms-edit-name")
    end
  end

  def sortable(options = {})
    if h.cms_edit_mode?
      h.cms_data_js('cms-sortable-id', m.unique_key.id, options)
    else
      options
    end
  end

  def sortable_html(options = {})
    CMS.options_to_html sortable(options)
  end

  private

  def edit_options
    h.cms_data_js('cms-editable-id', m.unique_key.id, class: "cms-edit cms-edit-#{dashed_name}", 'data-no-turbolink' => true)
  end

  def edit_path
    h.rails_admin.edit_path(model_name: m.class.name.underscore.gsub('/', '~'), id: m.id)
  end

  def dashed_name
    @_dashed_name ||= underscored_name.dasherize
  end

  def underscored_name
    @_underscored_name ||= m.class.name.underscore.gsub('/', '_')
  end
end