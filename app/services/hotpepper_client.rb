require "net/http"
require "json"

# HotPepperグルメサーチAPIと連携
# APIキーは Rails.application.credentials.dig(:hotpepper, :api_key) 
class HotpepperClient
  ENDPOINT = URI("https://webservice.recruit.co.jp/hotpepper/gourmet/v1/")

  # HotPepper予算マスタAPIから取得した実際のコード（2026年10月時点）
  BUDGET_OPTIONS = [
    [ "～1000円", "B010" ],
    [ "1001～1500円", "B011" ],
    [ "1501～2000円", "B001" ],
    [ "2001～3000円", "B002" ],
    [ "3001～4000円", "B003" ],
    [ "4001～5000円", "B008" ],
    [ "5001円～", "B015" ]
  ].freeze

  class ApiError < StandardError; end

  # HotPepperを検索し、結果をRestaurantとしてキャッシュ保存したうえで、
  # 今回の検索結果の並び順のまま返す（一覧表示にはこの戻り値をそのまま使う）
  def self.import_and_search(keyword: nil, genre_codes: [], budget_code: nil, count: 20)
    shops = search(keyword: keyword, genre_codes: genre_codes, budget_code: budget_code, count: count)
    shops.map { |shop| upsert_restaurant(shop) }
  end

  # HotPepperグルメサーチAPIを直接呼び出し、店舗情報の配列（APIの生データ）を返す
  # genre_codesが複数指定された場合、APIには絞り込みをかけずに取得し、こちら側でフィルタする
  # （HotPepper側のgenreパラメータは1コードのみ指定可能なため）
  # keywordには店名・エリア名どちらも指定できる（HotPepper側があいまい検索してくれる）
  def self.search(keyword: nil, genre_codes: [], budget_code: nil, count: 20)
    api_key = Rails.application.credentials.dig(:hotpepper, :api_key)
    raise ApiError, "HotPepper APIキーが設定されていません（credentials:edit で hotpepper.api_key を設定してください）" if api_key.blank?

    genre_codes = Array(genre_codes).reject(&:blank?)

    params = {
      key: api_key,
      keyword: keyword,
      genre: (genre_codes.first if genre_codes.size == 1),
      budget: budget_code,
      count: count,
      format: "json"
    }.compact

    uri = ENDPOINT.dup
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    raise ApiError, "HotPepper APIへのリクエストに失敗しました（status: #{response.code}）" unless response.is_a?(Net::HTTPSuccess)

    body = JSON.parse(response.body)

    if (api_errors = body.dig("results", "error"))
      raise ApiError, api_errors.map { |e| e["message"] }.join(" / ")
    end

    shops = body.dig("results", "shop") || []

    if genre_codes.size > 1
      shops = shops.select { |shop| genre_codes.include?(shop.dig("genre", "code")) }
    end

    shops
  end

  # APIレスポンス1件をRestaurantとして保存（shop_idで重複防止、既存分も最新情報に更新）
  def self.upsert_restaurant(shop)
    category = Category.find_by(code: shop.dig("genre", "code")) || Category.find_by(code: "G015")

    restaurant = Restaurant.find_or_initialize_by(shop_id: shop["id"])
    restaurant.name = shop["name"]
    restaurant.category = category
    restaurant.address = shop["address"]
    restaurant.latitude = shop["lat"]
    restaurant.longitude = shop["lng"]
    restaurant.image_url = shop.dig("photo", "pc", "l") || shop.dig("photo", "pc", "m")
    restaurant.detail_json = {
      catch: shop["catch"],
      budget: shop.dig("budget", "name"),
      budget_average: shop.dig("budget", "average"),
      open: shop["open"],
      close: shop["close"],
      access: shop["access"],
      capacity: shop["capacity"],
      card: shop["card"],
      non_smoking: shop["non_smoking"],
      private_room: shop["private_room"],
      parking: shop["parking"],
      child: shop["child"],
      wifi: shop["wifi"],
      hotpepper_url: shop.dig("urls", "pc")
    }.compact.to_json
    restaurant.save!
    restaurant
  end
end
