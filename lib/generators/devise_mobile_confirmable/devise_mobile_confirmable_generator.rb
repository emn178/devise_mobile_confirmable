module DeviseMobileConfirmable
  module Generators
    class DeviseMobileConfirmableGenerator < Rails::Generators::NamedBase
      namespace "devise_mobile_confirmable"

      desc "Add :mobile_confirmable directive in the given model. Also generate migration for ActiveRecord"

      def inject_devise_invitable_content
        path = File.join(destination_root, "app", "models", "#{file_path}.rb")
        inject_into_file(path, "mobile_confirmable, :", :after => "devise :") if File.exists?(path)
      end

      hook_for :orm
    end
  end
end
