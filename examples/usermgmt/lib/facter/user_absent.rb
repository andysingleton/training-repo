Facter.add(:user_absent) do
  setcode do

    def read_file(file_name)
      data = File.readlines(file_name)
      return data
    end

    def grab_users(array)
      data = []
      array.each { |line|
        data << line.gsub(/([a-z-]+):x:.*/, '\1').chomp
      }
      return data
    end

    def convert_user_array_to_hash(array)
      data = Hash[array.collect { |line| [line, { 'ensure' => 'absent' }] }]
      return data
    end

    data = read_file('/etc/passwd')
    userlist = grab_users(data)
    user_absent = convert_user_array_to_hash(userlist)

  end
end
