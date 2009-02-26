BaseController.class_eval do
  def change_to(page_name)
    main_controller.change_to(page_name)
  end
end

BaseMainController.class_eval do
  def change_to(page_name)
    self.main_view.change_to(page_name)
  rescue Exception => e
    logger.error "Probably you didn't register the main view in your main controller. Take a look at the setup_views method into the file app/controller/main_controller.rb"
    raise e
  end
end

BaseView.class_eval do
  def change_to(page_name)
    self.main_notebook.page = RuGUI::Routing::Routes.mapping.inverse(page_name)
  rescue Exception => e
    logger.error "Probably you didn't create the main notebook in the glade file of your main view."
    raise e
  end
end
