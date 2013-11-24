
require 'fileutils'
require 'stringio'

class Spn::Packager

	def initialize(params = {})
		@strong_params = params.slice :authentication_token
	end

	def content
		@content ||= build_content
	end

	LIB_PATH = ENV['SPN_PATH'] || File.join(Rails.root, 'res', 'spn')
	def build_content
		domain = ENV['DOMAIN_NAME']
		builder = Grocer::Pushpackager::Package.new({
				websiteName: ENV['SPN_WEBSITE_NAME'],
				websitePushID: ENV['SPN_WEBSITE_PUSH_ID'],
				allowedDomains: ["http://#{domain}", "https://#{domain}"],
				urlFormatString: "http://#{domain}%@",
				authenticationToken: authentication_token,
				webServiceURL: "https://#{domain}/spn/push",
				certificate: cer,
				key: pem,
				iconSet: icon_set,
		})
		builder.send(:build_zip).string
	end

	def authentication_token
		@strong_params[:authentication_token]

	def pem
		@@pem ||= build_pem
	end
	def cer
		@@cer ||= build_cer
	end
	def build_pem
		OpenSSL::PKey::RSA.new(File.read(ENV['PEM_PATH']), ENV['PEM_PASS_PHRASE'])
	end
	def build_cer
		OpenSSL::X509::Certificate.new(File.read(ENV['CERT_PATH']))
	end
	def icon_set
		set = {}
		%w(16x16 16x16@2x 32x32 32x32@2x 128x128 128x128@2x).each do |size|
			set[size.to_sym] = StringIO.new(icon_data(size))
		end
		set
	end

	def icon_data(size)
		@@icon_data ||= {}
		@@icon_data[size] ||= bin_read(lib_path('icons', "#{size}.png"))
	end

	def bin_read(file_path)
		b = nil
		File.open(file_path, 'rb') do |f|
			b = f.read
		end
		b
	end

	def prepare_path(path)
		prepare_dir path
	end

	def prepare_dir(path)
		dir = File.dirname path
		unless File.directory? dir
			raise "Dir:#{dir} is prese, 'spnnt. but not directory." if File.exists? dir
			FileUtils.mkdir_p dir
		end
	end
	def lib_path(*relative_paths)
		File.join(LIB_PATH, *relative_paths)
	end
end
