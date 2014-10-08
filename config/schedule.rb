set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every 10.minutes do
  runner "Advert.archivate_old_adverts", :environment => :development
end