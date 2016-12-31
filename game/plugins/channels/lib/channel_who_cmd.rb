module AresMUSH
  module Channels
    class ChannelWhoCmd
      include CommandHandler
           
      attr_accessor :name

      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'channels'
        }
      end
      
      def handle
        Channels.with_an_enabled_channel(self.name, client, enactor) do |channel|
          online_chars = Channels.channel_who(channel)
          names = online_chars.map { |c| "#{c.ooc_name}#{Channels.gag_text(c, channel)}" }
          text = t('channels.channel_who', :name => channel.display_name, :chars => names.join(", "))
          
          client.emit_ooc "%xn#{text}"
        end
      end
    end  
  end
end