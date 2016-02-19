module Viewable
  class LinkListPresenter < ViewableListPresenter
    def active_menu?
      !!active_link
    end

    def active_link
      @active_link ||= begin
        breadcrumbs
        @active_link
      end
    end

    def breadcrumbs
      @breadcrumbs ||= begin
        @active_link = nil
        take_while do |link|
          if link.active?
            @active_link = link
            false
          else
            true
          end
        end
      end
    end
  end
end
