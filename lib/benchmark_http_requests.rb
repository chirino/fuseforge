# ===========================================================================
# Copyright (C) 2009, Progress Software Corporation and/or its 
# subsidiaries or affiliates.  All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===========================================================================
#
# Module which extends the HTTPClient class so that it logs benchmark statistics 
# of the HTTPClient requests which are done.  Usefull when trying to debug
# performance issues of an app which uses the HTTPClient
#

require 'httpclient'

module BenchmarkLogging
  
  def benchmark(title, details=nil, log_level=Logger::DEBUG)
    logger = ActiveRecord::Base.logger;
    if logger && logger.level <= log_level
      result = nil
      seconds = Benchmark.realtime { result = yield }
      logger.add(log_level, format_benchmark_log_message(seconds, title, details))
      
      # Uncomment if your trying to figure out who's doing the HTTP call.
      # begin
      #   raise 'error'
      # rescue Exception => error
      #   logger.error(error.backtrace.join("\n"))
      # end
          
      result
    else
      yield
    end
  end
  
  def format_benchmark_log_message(seconds, title, details=nil)
    #if( @colorize_logging ) 
      titile_color, details_color, end_color = "\e[4;34;1m", "\e[0;1m", "\e[0m"
    #else
    #  titile_color, details_color, end_color = "", "", ""
    #end    
    log_entry = "  #{titile_color}#{title} (#{sprintf("%.1f", seconds * 1000)}ms)#{end_color}"
    log_entry << "#{details_color}:  #{details}#{end_color}" if details
    log_entry
  end
end

class HTTPClient
  
  private
  
  include BenchmarkLogging
  
  def request_benchmarked(method, uri, query=nil, body=nil, extheader={}, &block)
    benchmark("HTTP #{method}", uri) do
      request_original(method, uri, query, body, extheader, &block)
    end
  end
  
  public

  alias :request_original :request
  alias :request :request_benchmarked


end
