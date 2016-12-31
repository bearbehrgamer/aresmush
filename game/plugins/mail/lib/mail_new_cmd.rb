module AresMUSH
  module Mail
    class MailNewCmd
      include CommandHandler
      include CommandWithoutArgs
      
      def handle
        unread = enactor.unread_mail.first
        if (!unread)
          client.emit_ooc t('mail.no_unread_messages')
        else
          template = MessageTemplate.new(enactor, unread)
          client.emit template.render
          unread.update(read: true)
          client.program[:last_mail] = unread
        end
      end
    end
  end
end
