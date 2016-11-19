module AresMUSH
  module Describe
    class DescNotifyCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :option

      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        {
          args: [ self.option ],
          help: 'desc'
        }
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        enactor.update(desc_notify: self.option.is_on?)
        client.emit_success t('describe.notify_set', :status => self.option)
      end
    end
  end
end