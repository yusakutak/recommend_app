# ジャンルデータ
genres = [
  "和食", "洋食", "中華", "イタリアン", "フレンチ",
  "焼肉", "寿司", "ラーメン", "カレー", "ファストフード",
  "カフェ", "居酒屋", "エスニック", "その他"
]

genres.each do |name|
  Genre.find_or_create_by(name: name)
end

puts "#{Genre.count}件のジャンルを作成しました"
