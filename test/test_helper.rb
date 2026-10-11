ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # 指定のワーカー数でテストを並列実行する
  parallelize(workers: :number_of_processors)

  # test/fixtures/*.ymlにあるすべてのfixtureをセットアップする
  fixtures :all

  # アプリケーションヘルパーをテストで使用する
  include ApplicationHelper

  # （すべてのテストで使うその他のヘルパーメソッドは省略）
end

class ActionDispatch::IntegrationTest
  # sign_in / sign_out をテスト内で使えるようにする
  include Devise::Test::IntegrationHelpers
end
