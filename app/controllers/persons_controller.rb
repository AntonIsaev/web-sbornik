class PersonsController < ApplicationController
  def profile
    add_bootstrap_breadcrumb I18n.t("journals.index.title"), journals_path 
    add_bootstrap_breadcrumb I18n.t("devise.sessions.persons_profile"), persons_profile_path
  end
end
