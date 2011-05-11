# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ym4r/anonymizer', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{ym4r-anonymizer}
  s.version = Ym4r::Anonymizer::Version
  s.date = %q{2011-05-11}
  s.authors = ["Zhang, Xiaohui"]
  s.email = %q{xiaohui@zhangxh.net}
  s.homepage = %q{http://github.com/xiaohui-zhangxh/ym4r-anonymizer}
  s.summary = %q{An extension of Ym4r, allow us geocode address with proxy and automatically iterate API keys}
  s.description = %q{An extension of Ym4r, allow us geocode address with proxy and automatically iterate API keys}
  
  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.add_development_dependency "bundler", ">= 1.0.0"
  
  s.files        = `git ls-files`.split("\n")
  s.require_path = "lib"
  
  s.add_runtime_dependency(%q<ym4r>, [">= 0"])
end
