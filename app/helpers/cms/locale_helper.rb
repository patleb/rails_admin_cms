module CMS
  module LocaleHelper
    def cms_locale_selector
      content_tag(:ul, class: 'cms-locale-selector') do
        cms_locale_links.each do |link|
          concat content_tag(:li, link)
        end
      end
    end

    def cms_locale_links
      @cms_locale_links ||= begin
        if RailsAdminCMS::Config.hide_current_locale?
          links = []
        else
          links = [ link_to(t('cms.locale_selector.language'), '#', class: 'active') ]
        end

        I18n.available_locales.reject{ |l| l == locale }.each do |locale|
          path = current_url_for(locale)
          links << link_to(t('cms.locale_selector.language', locale: locale), path)
        end

        links
      end
    end

    private

    def current_url_for(locale)
      url = case controller_path
      when /^cms\/(pages|forms)/
        if @cms_view
          @cms_view.other_uuid(locale).try(:url)
        else
          main_app.try("#{params[:cms_view_type]}_#{locale}_path")
        end
      else
        url_for(:locale => locale.to_s)
      end
      url.presence || main_app.root_path(locale: locale)
    end
  end
end
