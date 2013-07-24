module ConfigModule
  def get_vars(conf_file)
    unless File.exists?(conf_file) then
      raise "Config file does not exist."
    end

    process_vars(File.open(conf_file))
  end

  def process_vars(conf)
    vars = {}
    conf.each_line do |line|
      if line.match(/^#/) || line.match(/^$/) # ignore comments and blank lines
        next
      else
       vars.merge! get_hash(line)
      end
    end
    vars
  end

  def get_hash(line)
    temp = []
    line_sub= Regexp.new(/\s+|"|\[|\]/)
    temp[0], temp[1]=line.split('=')
    temp.collect! do |val|
      val.gsub(line_sub, "")
    end
     {temp[0]=>temp[1]}
  end
end  # end module

        
