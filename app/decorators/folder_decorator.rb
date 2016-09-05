class FolderDecorator < Draper::Decorator
  delegate_all
  def self.breadcrumbs(id)
  end



end
