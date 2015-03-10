require 'zeus/rails'
require 'pathname'

host_app_path = Pathname('../mainline').expand_path

ROOT_PATH = File.expand_path(Dir.pwd)
ENV_PATH  = host_app_path.join('config/environment').to_s
BOOT_PATH = host_app_path.join('config/boot').to_s
APP_PATH  = host_app_path.join('config/application').to_s
ENGINE_ROOT = ROOT_PATH
ENGINE_PATH = File.expand_path('lib/gitorious-issues/engine', ENGINE_ROOT)

class EnginePlan < Zeus::Rails
end

Zeus.plan = EnginePlan.new
