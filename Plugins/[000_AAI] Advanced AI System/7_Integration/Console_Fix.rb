#===============================================================================
# Advanced AI System - Console Output Fix
# Fixes Windows beep issue when using echoln in debug mode
#===============================================================================

# Store the original echoln method if it exists
if !defined?(ORIGINAL_ECHOLN_ALIASED)
  ORIGINAL_ECHOLN_ALIASED = true
  
  # Define a quieter version of echoln that won't trigger Windows beeps
  module Kernel
    # Save the original echoln if it exists
    if respond_to?(:echoln)
      alias original_echoln_aai echoln
    end
    
    def echoln(msg = "")
      # Only output in debug mode
      return unless $DEBUG
      
      begin
        # Try to write directly to STDOUT without triggering beeps
        # Remove any bell characters (\a or \x07) that might cause beeps
        clean_msg = msg.to_s.gsub(/[\a\x07]/, '')
        
        # Use puts instead of the original echoln to avoid beep-triggering behavior
        puts clean_msg
        
        # Force flush to ensure immediate output
        STDOUT.flush
      rescue
        # Fallback: if anything fails, just be silent
        # Better than crashing or beeping
      end
    end
  end
end
                 