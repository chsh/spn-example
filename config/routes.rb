Your::Application.routes.draw do

	scope '/spn/push/v1', controller: 'spn' do
		post 'pushPackages/YOUR-WEBSITE-PUSH-ID', action: 'download'
		post 'log', action: 'log'
		post 'devices/:device_token/registrations/YOUR-WEBSITE-PUSH-ID',
				 action: 'create'
		delete 'devices/:device_token/registrations/YOUR-WEBSITE-PUSH-ID',
				 action: 'destroy'
	end

  get '/start', 'page#start'

end
