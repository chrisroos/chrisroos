require 'test/unit'
require File.join(File.dirname(__FILE__), 'wiki_syntax')

module Kernel
  alias_method :__original_p, :p
  def p(*args)
    __original_p(*args)
  end
end

class WikiSyntaxParagraphTest < Test::Unit::TestCase

  def test_should_surround_content_on_one_line_in_one_html_paragraph_tag
    assert_equal "<p>line 1</p>", WikiSyntax.new('line 1').to_html
  end

  def test_should_surround_content_on_two_subsequent_lines_in_one_html_paragraph_tag
    assert_equal "<p>line 1 line 2</p>", WikiSyntax.new("line 1\nline 2").to_html
  end

  def test_should_surround_content_separated_by_a_new_line_in_two_html_paragraph_tags
    assert_equal "<p>line 1</p><p>line 2</p>", WikiSyntax.new("line 1\n\nline 2").to_html
  end

  def test_should_ignore_newlines_at_the_end_of_the_wiki_content
    assert_equal "<p>line 1</p>", WikiSyntax.new("line 1\n\n\n").to_html
  end

  def test_should_create_two_paragraphs_and_ignore_newlines_at_the_end_of_the_wiki_content
    assert_equal "<p>line 1</p><p>line 2</p>", WikiSyntax.new("line 1\n\n\nline 2\n\n").to_html
  end

end

class WikiSyntaxTypefaceTest < Test::Unit::TestCase

  def test_should_enclose_text_in_html_italic_tags
    assert_equal "<p><i>italic</i></p>", WikiSyntax.new('_italic_').to_html
  end

  def test_should_enclose_text_in_html_bold_tags
    assert_equal "<p><b>bold</b></p>", WikiSyntax.new('*bold*').to_html
  end

  def test_should_enclose_text_in_html_sup_tags
    assert_equal "<p><sup>super</sup>script</p>", WikiSyntax.new('^super^script').to_html
  end

  def test_should_enclose_text_in_html_sub_tags
    assert_equal "<p><sub>sub</sub>script</p>", WikiSyntax.new(',,sub,,script').to_html
  end

  def test_should_enclose_text_in_html_strike_tags
    assert_equal "<p><strike>strikeout</strike></p>", WikiSyntax.new('~~strikeout~~').to_html
  end

  def test_should_enclose_bold_tags_within_italic_tags
    assert_equal "<p><i><b>bold</b> in italics</i></p>", WikiSyntax.new("_*bold* in italics_").to_html
  end

  def test_should_enclose_italic_tags_within_bold_tags
    assert_equal "<p><b><i>italics</i> in bold</b></p>", WikiSyntax.new("*_italics_ in bold*").to_html
  end

  def test_should_strike_words_within_bold_tags
    assert_equal "<p><b><strike>strike</strike> works too</b></p>", WikiSyntax.new("*~~strike~~ works too*").to_html
  end

  def test_should_italicise_one_of_the_striked_words
    assert_equal "<p><strike>as well as <i>this</i> way round</strike></p>", WikiSyntax.new("~~as well as _this_ way round~~").to_html
  end
  
end

class WikiSyntaxCodeTest < Test::Unit::TestCase

  def test_should_enclose_text_in_backticks_in_html_code_tags
    assert_equal "<p><code>code</code></p>", WikiSyntax.new('`code`').to_html
  end

  def test_should_enclose_text_in_triple_braces_in_html_code_tags
    assert_equal "<p><code>code</code></p>", WikiSyntax.new('{{{code}}}').to_html
  end

  def test_should_enclose_multiline_text_in_triple_braces_in_html_pre_tags
    assert_equal "<pre>line 1\nline 2</pre>", WikiSyntax.new("{{{\nline 1\nline 2\n}}}").to_html
  end

  def test_should_not_alter_code_in_backticks
    assert_equal "<p><code>_foo = *bar</code></p>", WikiSyntax.new("`_foo = *bar`").to_html
  end

  def test_should_not_alter_code_in_triple_braces
    assert_equal "<p><code>_foo = *bar</code></p>", WikiSyntax.new("{{{_foo = *bar}}}").to_html
  end
 
  def test_should_not_alter_multiline_code_in_triple_braces
    assert_equal "<pre>_foo = *bar</pre>", WikiSyntax.new("{{{\n_foo = *bar\n}}}").to_html
  end

  def test_should_surround_two_multiline_code_blocks_with_pre_tags
    assert_equal "<pre>line1</pre><pre>line2</pre>", WikiSyntax.new("{{{\nline1\n}}}\n{{{\nline2\n}}}").to_html
  end

end

class WikiSyntaxHeadingsTest < Test::Unit::TestCase

  def test_should_generate_h1
    assert_equal "<h1>heading</h1>", WikiSyntax.new("= heading =").to_html
  end

  def test_should_generate_h2
    assert_equal "<h2>heading 2</h2>", WikiSyntax.new("== heading 2 ==").to_html
  end

  def test_should_generate_h3
    assert_equal "<h3>heading 3</h3>", WikiSyntax.new("=== heading 3 ===").to_html
  end

  def test_should_generate_h4
    assert_equal "<h4>heading 4</h4>", WikiSyntax.new("==== heading 4 ====").to_html
  end

  def test_should_generate_h5
    assert_equal "<h5>heading 5</h5>", WikiSyntax.new("===== heading 5 =====").to_html
  end

  def test_should_generate_h6
    assert_equal "<h6>heading 6</h6>", WikiSyntax.new("====== heading 6 ======").to_html
  end
  
end

class WikiSyntaxDividerTest < Test::Unit::TestCase
  
  def test_should_generate_horizontal_rule
    assert_equal '<hr/>', WikiSyntax.new('----').to_html
  end

  def test_should_not_generate_horizontal_rule
    assert_equal '<p>---</p>', WikiSyntax.new('---').to_html
  end

  def test_should_not_generate_horizontal_rule_when_there_is_something_other_than_dashes_on_the_line
    assert_equal '<p>hello ---- world</p>', WikiSyntax.new('hello ---- world').to_html
  end

end

class WikiSyntaxListTest < Test::Unit::TestCase
  
  def test_should_generate_a_one_item_unordered_list
    assert_equal '<ul><li>list item</li></ul>', WikiSyntax.new(' * list item').to_html
  end

  def test_should_generate_a_one_item_unordered_list_when_more_than_one_space_appears_at_the_beginning_of_the_line
    assert_equal '<ul><li>list item</li></ul>', WikiSyntax.new('   * list item').to_html
  end

  def test_should_generate_a_multi_item_unordered_list
    assert_equal '<ul><li>item 1</li><li>item 2</li><li>item 3</li></ul>', WikiSyntax.new(" * item 1\n * item 2\n * item 3").to_html
  end

  def test_should_generate_a_multi_level_multi_item_unordered_list
    assert_equal '<ul><li>level 1 item 1</li><ul><li>level 2 item 2</li></ul></ul>', WikiSyntax.new(" * level 1 item 1\n  * level 2 item 2").to_html
  end

  def test_should_generate_an_unordered_list_that_contains_an_ordered_list
    assert_equal '<ul><li>level 1 ul 1</li><ol><li>level 2 ol</li></ol><li>level 1 ul 2</li></ul>', WikiSyntax.new(" * level 1 ul 1\n  # level 2 ol\n * level 1 ul 2").to_html
  end

  def test_should_generate_an_ordered_list_that_contains_an_unordered_list
    assert_equal '<ol><li>ol 1</li><ul><li>ul 1</li></ul><li>ol 2</li></ol>', WikiSyntax.new(" # ol 1\n  * ul 1\n # ol 2").to_html
  end

  def test_should_generate_two_unordered_lists
    flunk "I know this fails due to the paragraph inbetween the lists - check the output online"
    assert_equal '<ul><li>list 1</li></ul><p>between lists</p><ul><li>list 2</li></ul>', WikiSyntax.new(" * list 1\n\nbetween lists\n\n * list 2").to_html
  end

  def test_should_allow_wiki_formatting_within_the_generated_list
    assert_equal '<ul><li><b>bold</b> list item</li></ul>', WikiSyntax.new(" * *bold* list item").to_html
  end
  
end