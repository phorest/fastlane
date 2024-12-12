module Fastlane
  module Actions
    class ClipboardAction < Action
      def self.run(params)
        value = params[:value]

        truncated_value = value[0..800].gsub(/\s\w+\s*$/, '...')
        UI.message("Storing '#{truncated_value}' in the clipboard 🎨")

        copy_to_clipboard(value)
      end

      #####################################################
      # Helper Methods
      #####################################################

      def self.copy_to_clipboard(content)
        if RbConfig::CONFIG['host_os'] =~ /darwin/ # macOS
          IO.popen('pbcopy', 'w') { |clip| clip.write(content) }
        elsif RbConfig::CONFIG['host_os'] =~ /linux/ # Linux
          if system('command -v xclip > /dev/null') # Check if xclip is available
            IO.popen(['xclip', '-selection', 'clipboard'], 'w') { |clip| clip.write(content) }
          elsif system('command -v xsel > /dev/null') # Check if xsel is available
            IO.popen(['xsel', '--clipboard', '--input'], 'w') { |clip| clip.write(content) }
          else
            UI.error("Neither 'xclip' nor 'xsel' is installed. Install one of these tools to use clipboard functionality.")
          end
        else
          UI.error("Clipboard functionality is not supported on this OS.")
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Copies a given string into the clipboard. Works on macOS and Linux"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :value,
                                       env_name: "FL_CLIPBOARD_VALUE",
                                       description: "The string that should be copied into the clipboard")
        ]
      end

      def self.authors
        ["KrauseFx", "joshdholtz", "rogerluan"]
      end

      def self.is_supported?(platform)
        true # Supports all platforms
      end

      def self.example_code
        [
          'clipboard(value: "https://docs.fastlane.tools/")',
          'clipboard(value: lane_context[SharedValues::HOCKEY_DOWNLOAD_LINK] || "")'
        ]
      end

      def self.category
        :misc
      end
    end
  end
end
