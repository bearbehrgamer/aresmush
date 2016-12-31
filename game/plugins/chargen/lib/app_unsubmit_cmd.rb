module AresMUSH
  module Chargen
    class AppUnsubmitCmd
      include CommandHandler
      include CommandWithoutArgs
      
      def check_approval
        return t('chargen.you_are_already_approved') if enactor.is_approved?
        return nil
      end
      
      def check_approval_job
        return t('chargen.you_have_not_submitted_app') if !Chargen.approval_job(enactor)
        return nil
      end
      
      def handle
        job = Chargen.approval_job(enactor)
        
        Jobs::Api.change_job_status(enactor,
          job,
          Global.read_config("chargen", "jobs", "app_hold_status"),
          t('chargen.app_job_unsubmitted'))
          
        enactor.chargen_info.update(locked: false)
          
        client.emit_success t('chargen.app_unsubmitted')
      end
    end
  end
end