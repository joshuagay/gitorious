require "test_helper"
require "command"
require "command/init"
require "command/clone"
require "command/delete"
require "command/git"

describe Command do
  before do
    @command = Command.new('git upload-pack foo.git', '/var/git')
  end

  describe '.build' do
    describe 'with init verb' do
      before do
        @action = Command.build('init foo')
      end

    it 'creates Init action' do
        assert_equal Command::Init, @action.class
      end
    end

    describe 'with clone verb' do
      before do
        @action = Command.build('clone source target')
      end

      it 'creates Clone action' do
        assert_equal Command::Clone, @action.class
      end
    end

    describe 'with delete verb' do
      before do
        @action = Command.build('delete foo')
      end

      it 'creates Delete action' do
        assert_equal Command::Delete, @action.class
      end
    end

    describe "with git-receive-pack verb" do
      it "creates a Git action" do
        action = Command.build('git-receive-pack repo.git', '/var/git')
        assert_equal Command::Git, action.class
      end
    end

    describe 'with an invalid verb' do
      it 'raises ArgumentError' do
        assert_raises ArgumentError do
          Command.build('whatever foo')
        end
      end
    end
  end
end

describe Command::Init do
  before do
    @action = Command.build('init foo')
  end

  describe '#execute' do
    it 'executes git init command' do
      assert_equal "/bin/sh -c \"mkdir -p /var/git/foo && cd /var/git/foo && git init --bare\"", @action.execute
    end
  end
end

describe Command::Clone do
  before do
    @action = Command.build('clone source target')
  end

  describe '#execute' do
    it 'executes git clone command' do
      assert_equal 'git clone /var/git/source /var/git/target', @action.execute
    end
  end
end

describe Command::Delete do
  before do
    @action = Command.build('delete foo.git')
  end

  describe '#execute' do
    describe 'when directory does not exist' do
      it 'raises an error' do
        File.expects(:directory?).with('/var/git/foo.git').returns(false)

        assert_raises Command::Delete::InvalidPathError do
          @action.execute
        end
      end
    end

    describe 'path is valid' do
      it 'removes the repository' do
        File.expects(:directory?).with('/var/git/foo.git').returns(true)
        assert_equal 'rm -Rf /var/git/foo.git', @action.execute
      end
    end
  end
end

describe Command::Git do
  it "executes git shell" do
    action = Command.build("git-receive-pack foo.git", "/srv/repositories")
    assert_equal "git-shell -c \"git-receive-pack /srv/repositories/foo.git\"", action.execute
  end
end
