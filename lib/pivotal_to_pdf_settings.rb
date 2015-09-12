# - Hack to deal with P2pdf not taking command line options
def store_pivotal_to_pdf_settings(project_id)
  settings = YAML.load_file('settings.yml')
  f = File.open("/Users/scottspeidel/.pivotal.yml","w")
  f.write("token: #{settings['token']}\n") 
  f.write("project_id: #{project_id}\n") 
  f.write("formatter: #{settings['formatter']}") 
  f.close
end


