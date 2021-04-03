require 'fileutils'

class VerboseShell
  @@verbose = nil
  def self.verbose;     @@verbose;     end
  def self.verbose=(v); @@verbose = v; end

  def self.system_trace(*args)
    return unless @@verbose
    puts "+ "+args.map{|a| a =~ /\s/ ? '"'+a+'"' : a}.join(' ')
  end

  def self.system(*args)
    system_trace *args
    Kernel.system *args or abort "#{args[0]} failed"
  end

  def self.systemr(*args)
    system_trace *args
    Kernel.system *args
  end

  def self.capture(*args)
    system_trace *args
    IO.popen(args + (@verbose == 0 ? [{:err => "/dev/null"}] : []), "r") {|io| io.read}.strip
  end

  def self.mv(src,dest)
    system_trace *%W"mv #{src} #{dest}"
    FileUtils.mv(src, dest)
  end

  def self.chmod(mode,list)
    list = [list] unless list.class == Array
    system_trace *%W"chmod #{mode} "+list
    FileUtils.chmod(mode, list)
  end

  def self.cp(src,dest)
    system_trace *%W"cp #{src} #{dest}"
    FileUtils.cp(src, dest)
  end

  def self.cp_r(src,dest)
    system_trace *%W"cp -r #{src} #{dest}"
    FileUtils.cp_r(src, dest)
  end

  def self.ln_s(src,dest)
    system_trace *%W"ln -s #{src} #{dest}"
    FileUtils.ln_s(src, dest)
  end

  def self.rm_rf(file)
    system_trace *%W"rm -rf #{file}"
    FileUtils.rm_rf file
  end

  def self.mkdir_p(file)
    system_trace *%W"mkdir -p #{file}"
    FileUtils.mkdir_p file
  end

  def self.chdir(dir)
    system_trace *%W"chdir #{dir}"
    Dir.chdir dir
  end
end
