module AresMUSH
  module Login
    class EmailSetCmd
      include CommandHandler
      
      attr_accessor :email

      def crack!
        self.email = trim_input(cmd.args)
      end

      def required_args
        {
          args: [ self.email ],
          help: 'email'
        }
      end
      
      def check_email_format
        if self.email !~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
          return t('login.invalid_email_format')
        end
        return nil
      end
      
      def handle      
        enactor.update(login_email: self.email)
        client.emit_success t('login.email_set')
      end
    end
  end
end
