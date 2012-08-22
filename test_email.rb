require_relative 'config.rb'

iw = IronWorkerNG::Client.new
task = iw.tasks.create("email_worker",
                       SingletonConfig.config.merge(
                           to: "treeder@gmail.com",
                           from: "travis@iron.io",
                           subject: "Thanks for the Lead!",
                           body: "Thanks again for the lead"

                       ))
status = iw.tasks.wait_for(task.id)
p status
puts status.msg
puts iw.tasks.log(task.id)
