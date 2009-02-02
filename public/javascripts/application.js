// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function check_accept_text_scroll_pos(text_element_id, check_element_id) {
  if ($(text_element_id).scrollTop + $(text_element_id).clientHeight == $(text_element_id).scrollHeight) {
    $(check_element_id).disabled = false;
  }
}
