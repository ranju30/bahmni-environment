require 'rubygems'
require 'fileutils'
require 'mysql'

current_images_directory = '/home/jss/patient_images/'
new_images_directory = '/home/jss/.OpenMRS/person_images/'
count = 0
connection = Mysql.new('localhost', 'root', 'password', 'openmrs')

Dir[current_images_directory+"*.jpeg"].each do |file_name|
  count += 1
  identifier = File.basename(file_name, '.jpeg')
  query = "select p.uuid from patient_identifier pi join person p on p.person_id = pi.patient_id and pi.identifier = '"+identifier+"'"
  result = connection.query(query)

  uuid = result.fetch_row[0]

  FileUtils.cp(file_name, new_images_directory + uuid + ".jpeg")
end
puts "Migrated " + count.to_s() + " files from \"" + current_images_directory +"\" to \"" + new_images_directory+"\""