require 'rdoc/task'

RDoc::Task.new do |rdoc|
  # rdoc.main = "README.rdoc"
  rdoc.rdoc_dir = "public/apidoc"
  rdoc.rdoc_files.include("app/models","app/controllers","app/helpers","app/views")
end

