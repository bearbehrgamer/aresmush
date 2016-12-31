module AresMUSH
  module Friends
    class FriendRemoveCmd
      include CommandHandler
      
      attr_accessor :name

      def crack!
        self.name = cmd.args
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'friends'
        }
      end
      
      def handle
        result = Friends.find_friendship(enactor, self.name)
      
        if (result[:friendship].nil?)
          client.emit_failure client.emit_failure result[:error]
          return
        end
      
        result[:friendship].delete
        client.emit_success t('friends.friend_removed', :name => self.name)        
      end
    end
  end
end
