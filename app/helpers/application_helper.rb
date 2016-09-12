module ApplicationHelper
  def folders_breadcrumbs_list history, current_page_folder
    breadcrumbs = []
    breadcrumbs << {path: '', title: current_page_folder.title}
    tmp_folder = current_page_folder
    while tmp_folder = tmp_folder.parent_folder do
      breadcrumbs << {path: child_folders_history_folder_path(history, tmp_folder), title: tmp_folder.title}
    end
    breadcrumbs << {path: root_path, title: 'Home'}
    breadcrumbs.reverse!
    if block_given?
      breadcrumbs.each {|breadcrumb| yield breadcrumb }
    end
  end
end
