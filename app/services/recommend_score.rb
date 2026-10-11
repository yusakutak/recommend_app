# 個人・グループそれぞれに対する飲食店の推薦スコアを計算するサービスクラス
class RecommendScore
  # 個人向け：ユーザーの、あるジャンルへの評価をマッチ率(%)に変える
  # 未回答、または「1（大嫌い）」の場合はnilを返す
  def self.match_rate(user, restaurant)
    category = restaurant.category
    preference = user.preference_for(category)

    return nil if preference.nil?
    return nil if preference.preference <= 1

    preference.preference * 20
  end

  # 個人向け：マッチ率が高い飲食店を、高い順に返す
  def self.recommend_for_user(user, how_many = 4)
    good_restaurants = []

    Restaurant.all.each do |restaurant|
      rate = match_rate(user, restaurant)
      if rate != nil
        good_restaurants << [restaurant, rate]
      end
    end

    good_restaurants = good_restaurants.shuffle  # 同じマッチ率の中ではランダムな順にする

    sorted = good_restaurants.sort_by { |pair| pair[1] }
    sorted = sorted.reverse

    top = []
    i = 0
    while i < how_many && i < sorted.length
      top << sorted[i][0]
      i += 1
    end

    top
  end

  # グループ向け：論文第4章の計算式 R(G,c) = A_c / (1 + σ_c) で
  # 1つのジャンル分のスコアを計算する（最小不幸度フィルタに該当する場合は0）
  def self.group_score_for_category(members, category)
    scores = []

    members.each do |member|
      preference = member.preference_for(category)
      return 0 if preference.nil?
      scores << preference.preference
    end

    return 0 if scores.min <= 1

    sum = 0
    scores.each do |score|
      sum = sum + score
    end
    average = sum.to_f / scores.length

    sum_of_squares = 0
    scores.each do |score|
      difference = score - average
      sum_of_squares = sum_of_squares + difference * difference
    end
    variance = sum_of_squares / scores.length
    stddev = Math.sqrt(variance)

    average / (1 + stddev)
  end

  # グループ向け：全ジャンルのスコアを計算して、高い順に並べる
  # 戻り値：[[ジャンル, スコア], [ジャンル, スコア], ...]
  def self.recommend_for_group(group)
    members = group.users
    results = []

    Category.all.each do |category|
      score = group_score_for_category(members, category)
      if score > 0
        results << [category, score]
      end
    end

    sorted = results.sort_by { |pair| pair[1] }
    sorted.reverse
  end

  # グループ向け：スコア上位ジャンルに属する、実際の飲食店を返す
  # area・budget_codeを指定すると、その条件でHotPepperに問い合わせて最新の結果を返す
  # （指定が無ければ、これまでにキャッシュ済みの飲食店から探す）
  def self.recommend_restaurants_for_group(group, how_many = 6, area: nil, budget_code: nil)
    ranked_categories = recommend_for_group(group)

    top_categories = []
    i = 0
    while i < 3 && i < ranked_categories.length
      top_categories << ranked_categories[i][0]
      i += 1
    end

    return [] if top_categories.empty?

    if area.present? || budget_code.present?
      genre_codes = []
      top_categories.each do |category|
        genre_codes << category.code
      end

      HotpepperClient.import_and_search(
        keyword: area,
        genre_codes: genre_codes,
        budget_code: budget_code,
        count: how_many
      )
    else
      Restaurant.where(category: top_categories).limit(how_many)
    end
  end
end
