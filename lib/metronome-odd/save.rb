module Save
  def self.file_name_format(short_name)
    "./sp." + short_name + ".marshal"
  end

  def self.save_exist?(short_name)
    File.exist?(Save.file_name_format(short_name))
  end

  def self.save_obj(short_name, obj)
    file_name = Save.file_name_format(short_name)
    file_handler = File.open(file_name, "w") {|to_file| Marshal.dump(obj, to_file)}
    file_handler.close
    if File.exist?(file_name)
      return 0
    else
      return -1
    end
  end  

  def self.load_obj(short_name)
    file_name = Save.file_name_format(short_name)
    Save.load(file_name)
  end

  def self.delete_obj(short_name)
    file_name = Save.file_name_format(short_name)
    Save.delete(file_name)
  end

  def self.list
    list = []
    ls = Dir.entries(".")
    ls.each do |f|
      m = f.match(/^sp\.(?<name>\w+)\.marshal$/)
      if m
        list.push(m[:name])
      end
    end
    list
  end

  def self.load(file_name)
    if File.exist?(file_name)
      begin
        file_handler = File.open(file_name, "r")
        obj = Marshal.load(file_handler)
        file_handler.close
      rescue
        obj = false
      end
    else
      obj = nil
    end
    obj
  end
end
