namespace :credentials do
  desc "エディタを使わずにHotPepper APIキーをRails credentialsへ保存する"
  task set_hotpepper_key: :environment do
    require "securerandom"

    key_path = Rails.root.join("config/master.key")
    unless File.exist?(key_path)
      File.write(key_path, SecureRandom.hex(16))
      puts "config/master.key を新規作成しました。"
    end

    credentials = ActiveSupport::EncryptedConfiguration.new(
      config_path: Rails.root.join("config/credentials.yml.enc"),
      key_path: key_path,
      env_key: "RAILS_MASTER_KEY",
      raise_if_missing_key: true
    )

    current = credentials.config.dup

    print "HotPepper APIキーを入力してください（そのまま画面に表示されます）: "
    api_key = STDIN.gets.to_s.strip

    puts "読み取った文字数: #{api_key.length}文字"

    if api_key.blank?
      puts "何も入力されなかったため、中断しました。"
      next
    end

    current[:hotpepper] = { api_key: api_key }
    credentials.write(current.to_yaml)

    puts "保存しました（config/credentials.yml.enc を更新）。"
  end
end
