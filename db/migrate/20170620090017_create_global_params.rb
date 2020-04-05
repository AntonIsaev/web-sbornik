class CreateGlobalParams < ActiveRecord::Migration
  def change
    create_table :global_params do |t|
      t.string :param_name
      t.string :val
      t.string :description

      t.timestamps null: false
    end
    GlobalParam.create param_name: "auto_convert_to_pdf", val: "1", description: "1 = enable auto convert to PDF function, 0 = disable auto convert to PDF function"
    GlobalParam.create param_name: "app_version", val: "1.0.6.96", description: "Current version of web-application."
    GlobalParam.create param_name: "app_date", val: "20.06.2017", description: "Date of last application's updates."
    GlobalParam.create param_name: "app_email", val: "web.sbornik@gmail.com", description: "Main e-mail of application. It is used to send notifications to all users."
  end
end
