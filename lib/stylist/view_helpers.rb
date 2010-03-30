module Stylist
  module ViewHelpers
    def render_stylesheets
      Stylist.stylesheets.process!
      html = Stylist.stylesheets.inject('') do |html, (media, stylesheets)|
        html << stylesheet_link_tag(*(stylesheets +
          [ :media => media.to_s,
            :recursive => true,
            :cache => "all-#{stylesheets.hash.to_s}" ]))
      end
      html.respond_to?(:html_safe) ? html.html_safe : html
    end
  end
end