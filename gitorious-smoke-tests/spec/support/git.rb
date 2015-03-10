class Git < Struct.new(:name, :origin, :key)
  def clone
    git("clone #{origin} #{path}", ".")
  end

  def configure_user
    git("config user.email test@gitorious.org")
    git("config user.name 'Gitorious Smoke Test'")
  end

  def add_file(files = {})
    files.each do |file, contents|
      File.write(path(file), contents)
    end
    git("add --all")
    git("commit -m 'Add files'")
  end

  def push
    git("push origin master")
  end

  def head_sha
    git("rev-parse HEAD")
  end

  private

  def path(*parts)
    ["tmp", name].concat(parts).join("/")
  end

  def git(cmd, dir = path)
    `cd #{dir} && GIT_SSH=#{key.script_path} git #{cmd}`
  end
end
