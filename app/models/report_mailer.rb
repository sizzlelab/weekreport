class ReportMailer < ActionMailer::Base
  
  default :from => "\"OtaSizzle Week Reporter\" <no-reply@OtaSizzle.Weekreport>"
  
  
  def request_reports(team)
    logger.info "Sending request for report for #{team.name} to #{team.email}."
    
    @team = team
    mail(:to =>  team.email,
    :subject => "Time for short week reporting")
    
  end
  
  def reminder(team)
    logger.info "Sending reminder for #{team.name} to #{team.email}."
    
    @team = team
    
    mail(:to =>  team.email,
    :subject => "Please remember to submit a short report for OtaSizzle weekly mail")
    
  end
  
  def weekly_report
    logger.info "Sending weekly report"
     
    mail(:to =>  APP_CONFIG.reporter_recipients,
    :subject =>  "OtaSizzle weekly report, week #{Date.today.cweek}")
  end
  
  def ReportMailer.send_requests
    Team.all.each do |team|
      request_reports(team).deliver
    end
  end
  
  def ReportMailer.send_reminders
    logger.info { "Sending reminders." }
    Team.all.each do |team|
      puts "Team #{team.name} has message for this week? #{team.has_message_for_this_week?}"
      unless (team.has_message_for_this_week?)
        puts "Delivering reminder to #{team.name}"
        reminder(team).deliver
      end
    end
  end
  
  def ReportMailer.send_report
    logger.info { "Sending the weekly report." }
    weekly_report.deliver
    Team.all.each do |team|
      team.messages.last.update_attribute(:is_sent, 1) unless (team.messages.last.nil?)
    end  
  end
  
end