require 'formula'

# cloned from runit Formular

class Socklog < Formula
  homepage 'http://smarden.org/socklog'
  url 'http://smarden.org/socklog/socklog-2.1.0.tar.gz'
  sha1 '27a117eae00105f491e6ef301206f7b92d7438ce'

  def install
    # Socklog untars to 'admin/runit-VERSION'
    cd "socklog-#{version}" do
      # Per the installation doc on OS X, we need to make a couple changes.
      system "echo 'cc -Xlinker -x' >src/conf-ld"
      #inreplace 'src/Makefile', / -static/, ''

      #inreplace 'src/sv.c', "char *varservice =\"/service/\";", "char *varservice =\"#{var}/service/\";"
      system "package/compile"

      # The commands are compiled and copied into the 'command' directory and
      # names added to package/commands. Read the file for the commands and
      # install them in homebrew.
      rcmds = File.open("package/commands").read

      rcmds.each do |r|
        bin.install("command/#{r.chomp}")
        man8.install("man/#{r.chomp}.8") rescue man1.install("man/#{r.chomp}.1") 
      end

      # (var + "service").mkpath
    end
  end
end
