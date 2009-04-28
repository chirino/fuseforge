module ProjectMailingListsHelper
  
  def display_if_internal(type='table-row')
    "display:#{ @project_mailing_list.use_internal? ? type : 'none'};"
  end

  def display_unless_internal(type='table-row')
    "display:#{ @project_mailing_list.use_internal? ? 'none': type};"
  end
  
end