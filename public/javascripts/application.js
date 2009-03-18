// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function check_accept_text_scroll_pos(text_element_id, check_element_id) {
  if ($(text_element_id).scrollTop + $(text_element_id).clientHeight == $(text_element_id).scrollHeight) {
    $(check_element_id).disabled = false;
  }
}

function toggle_other_license_url(select_id, other_value) {
  if ($(select_id).value == other_value) {
	Element.show('other-license-url');
  } else {
	Element.hide('other-license-url');
  }	
}
