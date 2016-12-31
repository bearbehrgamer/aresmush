module AresMUSH
  module Manage
    class LoadPluginCmd
      include CommandHandler
      
      attr_accessor :load_target
      
      def crack!
        self.load_target = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.load_target ],
          help: 'load'
        }
      end
      
      def check_plugin_name
        return t('manage.invalid_plugin_name') if self.load_target !~ /^[\w\-]+$/
        return nil
      end
      
      def handle
        begin
          can_manage = Manage.can_manage_game?(enactor)
          if (!can_manage)
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
        rescue
          client.emit_failure t('manage.management_config_messed_up')
        end
        
        client.emit_ooc t('manage.loading_plugin_please_wait', :name => load_target)
        begin
          begin
            
            Global.plugin_manager.unload_plugin(load_target)
          rescue SystemNotFoundException
            # Swallow this error.  Just means you're loading a plugin for the very first time.
          end
          Global.plugin_manager.load_plugin(load_target)
          Help::Api.reload_help
          Global.locale.reload
          Global.dispatcher.queue_event ConfigUpdatedEvent.new
          client.emit_success t('manage.plugin_loaded', :name => load_target)
        rescue SystemNotFoundException => e
          client.emit_failure t('manage.plugin_not_found', :name => load_target)
        rescue Exception => e
          Global.logger.debug "Error loading plugin: #{e}"
          client.emit_failure t('manage.error_loading_plugin', :name => load_target, :error => e)
        end
      end
    end
  end
end
