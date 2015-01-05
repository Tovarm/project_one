require 'twilio-ruby' 
 
# put your own credentials here 
account_sid = 'ACbb965bef42d969da2a19e0fb68d75577' 
auth_token = '97f0553078b9b21f1b52d2f185e1ea41' 
 
# set up a client to talk to the Twilio REST API 
@client = Twilio::REST::Client.new account_sid, auth_token 
 
@client.account.messages.create({
	:from => '+13479675006',
	:to => ['9176648369', '7188407191', '7188407037'],
	:body => "Hello from blobby"    
})