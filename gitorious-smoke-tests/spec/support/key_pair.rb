class KeyPair < Struct.new(:name)
  def self.generate
    key = new(gen_name)
    key.generate_key
    key.generate_git_ssh
    key
  end

  def generate_key
    `ssh-keygen -f #{key_path} -P ''`
  end

  def key_path
    File.expand_path("tmp/#{name}")
  end

  def script_path
    File.expand_path("tmp/ssh_#{name}")
  end

  def generate_git_ssh
    script = <<-EOF
#!/bin/sh
ssh -o 'IdentityFile "#{key_path}"' -o 'IdentitiesOnly yes' -o 'StrictHostKeyChecking no' "$@"
    EOF

    File.write(script_path, script)
    File.chmod(0700, script_path)
  end

  def public
    File.read("#{key_path}.pub")
  end
end
