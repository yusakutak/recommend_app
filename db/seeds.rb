# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# HotPepperグルメサーチAPI「ジャンルマスタAPI」の中ジャンル一覧（2026年7月時点でAPIから取得したもの）
[
  { code: "G001", name: "居酒屋" },
  { code: "G002", name: "ダイニングバー・バル" },
  { code: "G003", name: "創作料理" },
  { code: "G004", name: "和食" },
  { code: "G005", name: "洋食" },
  { code: "G006", name: "イタリアン・フレンチ" },
  { code: "G007", name: "中華" },
  { code: "G008", name: "焼肉・ホルモン" },
  { code: "G017", name: "韓国料理" },
  { code: "G009", name: "アジア・エスニック料理" },
  { code: "G010", name: "各国料理" },
  { code: "G011", name: "カラオケ・パーティ" },
  { code: "G012", name: "バー・カクテル" },
  { code: "G013", name: "ラーメン" },
  { code: "G016", name: "お好み焼き・もんじゃ" },
  { code: "G014", name: "カフェ・スイーツ" },
  { code: "G015", name: "その他グルメ" }
].each do |genre|
  Category.find_or_create_by!(code: genre[:code]) do |category|
    category.category = genre[:name]
  end
end
