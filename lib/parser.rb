require "redcarpet"
require "pygments.rb"

class Parser
  class HTMLRuby < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
  end

  def self.markdown_to_html(content)
    renderer = HTMLRuby.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true,
    }
    Redcarpet::Markdown.new(renderer, options).render(content).html_safe
  end
end
