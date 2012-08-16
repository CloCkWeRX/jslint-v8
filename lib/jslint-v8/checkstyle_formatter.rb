require 'rubygems'
require 'htmlentities'

module JSLintV8
   class CheckstyleFormatter < Formatter
      attr_reader :output_stream
    
      def initialize(stream)
         @output_stream = stream
      end

      def tick(errors)
         output_stream.flush
      end

      def summary(tested_files, lint_result)
         output_stream.print '<?xml version="1.0" encoding="utf-8"?>' + "\n"
         output_stream.print '<checkstyle>' + "\n"
         if lint_result.keys.any?
            print_error_summary(lint_result)
            output_stream.print "\n"
         end
         output_stream.print '</checkstyle>' + "\n"
         
      end

   private
      def print_error_summary(result) 
         out = output_stream

         coder = HTMLEntities.new
         # we iterate the sorted keys to prevent a brittle test and also the output
         # should be nicer as it will be guaranteed to be alphabetized
         result.keys.sort.each do |file|
            errors = result[file]

            #out.print "#{file}:\n"
            out.print "<file name=\"#{file}\">\n"
            errors.each do |error|
               out.print "\t<error line=\"#{coder.encode(error.line_number, :decimal)}\" column=\"#{coder.encode(error.character, :decimal)}\" severity=\"warning\" message=\"#{coder.encode(error.reason, :decimal)}\" source=\"net.csslint.Catfish\" />\n"

               #source=\"" + generateSource(message.rule) +"\"
               # net.csslint.' + rule.name.replace(/\s/g,'')
            end
            out.print "</file>"
         end
      end
   end
end