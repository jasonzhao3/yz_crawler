Gem::Specification.new do |s|
	s.name        = 'yz_crawler'
	s.version     = '0.0.1'
	s.date        = '2015-03-22'
	s.summary     = 'My first gem'
	s.description = 'A simple web crawler gem'
	s.authors     = ['Yang Zhao']
	s.email       = 'yang.notold@gmail.com'
	s.files       = %w(
										lib/command_line_argument_parser.rb
										lib/spider.rb
										lib/url_store.rb
										lib/url_utils.rb
										lib/yz_crawler.rb
									)
	s.executables   = ['crawler']
	s.add_runtime_dependency 'hpricot', '~> 0.8'
	s.homepage    = 'http://rubygems.org/gems/yz_crawler'
	s.license     = 'MIT'
end