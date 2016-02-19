module Viewable
  class LinkPresenter < ViewablePresenter
    def link_to(name = nil, options = {})
      if block_given?
        options = normalize_link_options(nil, name)
        name = options.first
        h.active_link_to(*options.drop(1)) do
          h.concat name
          yield
         end
      else
        h.active_link_to *normalize_link_options(name, options)
      end
    end

    def sortable_link_to(name_or_options = nil, options = {})
      if block_given?
        link_to(sortable(name_or_options || {})) do
          yield
        end
      else
        link_to(name_or_options, sortable(options))
      end
    end

    def youtube_embed_url(width = 420, height = 315)
      if (url = m.url)
        link = YouTubeAddy.youtube_embed_url(url, width, height)
        # verify url validity
        unless link[/\[\/\^/]
          link.html_safe
        end
      end
    end

    def url(options = {})
      @url ||= begin
        if m.file.present?
          h.main_app.file_path(id: m)
        else
          m.page.presence || m.url.presence || options[:path] || options[:url] || '#'
        end
      end
    end

    def active?(options = {})
      @active ||= begin
        path = url(options)
        if path == '#' || path[/^http/]
          false
        else
          !!(h.request.path =~ /^#{path}/)
        end
      end
    end

    private

    def normalize_link_options(name, options)
      name = m.title.presence || name
      if m.target_blank?
        options = options.merge target: '_blank'
      end
      if !m.turbolink?
        options = options.merge 'data-no-turbolink' => true
      end
      [name, url(options), options]
    end
  end
end
