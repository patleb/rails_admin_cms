module CMS
  module LocaleHelper
    def cms_locale_links
      @cms_locale_links ||= begin
        if RailsAdminCMS::Config.hide_current_locale?
          links = []
        else
          options = cms_data_js('cms-locale-selector', locale, class: 'cms-locale-selector active')
          links = [ link_to(t('cms.locale_selector.language'), '#', options) ]
        end

        I18n.available_locales.reject{ |l| l == locale }.each do |locale|
          path = current_url_for(locale)
          options = cms_data_js('cms-locale-selector', locale, class: 'cms-locale-selector')
          links << link_to(t('cms.locale_selector.language', locale: locale), path, options)
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
        if request.request_method != 'GET' && request.referer
          "#{request.referer.sub(/\?.*/, '')}?locale=#{locale}"
        else
          url_for(:locale => locale.to_s)
        end
      end
      url.presence || main_app.root_path(locale: locale)
    end
  end
end
