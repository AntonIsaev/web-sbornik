require 'uri'
require 'net/http'
require 'json'

class Doc2PDFClient

   def initialize(ip, port)
       @ip = ip
       @port = port
   end

   def convert(sourceFile, destFile)
       puts "Waiting... This process may take several seconds"
       resp = upload_doc(sourceFile, @ip, @port)
       response_hash = JSON.parse(resp)

       if response_hash["status"] == "ok" 
          download_pdf(destFile, response_hash["id"], @ip, @port)
          puts "File was downloaded"
       elsif response_hash["status"] == "error" 
          message = response_hash["message"]
          tracestack = response_hash["tracestack"]
          puts "Message: #{message}"
          puts "Trace stack: #{tracestack}"
       else
          puts "unknown request"
       end
   end

   private 
 
   def upload_doc(file, ip, port)
       boundary = "AaBbCcDd123456EeFf"
       uri = URI.parse("http://#{ip}:#{port}/api/upload")

       post_body = []
       post_body << "--#{boundary}\r\n"
       post_body << "Content-Disposition: form-data; name=\"datafile\"; filename=\"#{File.basename(file)}\"\r\n"
       post_body << "Content-Type: application/msword\r\n"
       post_body << "\r\n"
       post_body << File.read(file)
       post_body << "\r\n--#{boundary}\r\n"

       http = Net::HTTP.new(uri.host, uri.port)
       request = Net::HTTP::Post.new(uri.request_uri)
       request.body = post_body.join
       request["Content-Type"] = "multipart/form-data; boundary=#{boundary}"

       response = http.request(request)
       return response.body
   end

   def download_pdf(file, id, ip, port)
        uri = URI.parse("http://#{ip}:#{port}/api/download/#{id}") 
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)  

        response = http.request(request)

        open(file, "wb") do |f|
           f.write(response.body)
        end 
    end
end
