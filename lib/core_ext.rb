# Include each of the files in the core_ext directory
Dir[File.dirname(__FILE__) + "/core_ext/*.rb"].each{ |file| require(file) }