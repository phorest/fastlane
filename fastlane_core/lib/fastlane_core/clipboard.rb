require 'fastlane_core'
require 'open3'

module FastlaneCore
  class Clipboard
    def self.copy(content: nil)
      return UI.crash!("Clipboard functionality is not supported on this platform.") unless is_supported?

      if macos?
        Open3.popen3('pbcopy') { |input, _, _| input << content }
      elsif linux?
        if `which xclip`.strip.length > 0
          Open3.popen3('xclip -selection clipboard') { |input, _, _| input << content }
        elsif `which xsel`.strip.length > 0
          Open3.popen3('xsel --clipboard --input') { |input, _, _| input << content }
        else
          UI.crash!("Neither 'xclip' nor 'xsel' is installed. Please install one to use clipboard functionality on Linux.")
        end
      end
    end

    def self.paste
      return UI.crash!("Clipboard functionality is not supported on this platform.") unless is_supported?

      if macos?
        return `pbpaste`
      elsif linux?
        if `which xclip`.strip.length > 0
          return `xclip -selection clipboard -o`
        elsif `which xsel`.strip.length > 0
          return `xsel --clipboard --output`
        else
          UI.crash!("Neither 'xclip' nor 'xsel' is installed. Please install one to use clipboard functionality on Linux.")
        end
      end
    end

    def self.is_supported?
      macos? || linux?
    end

    def self.macos?
      RbConfig::CONFIG['host_os'] =~ /darwin/
    end

    def self.linux?
      RbConfig::CONFIG['host_os'] =~ /linux/
    end
  end
end
