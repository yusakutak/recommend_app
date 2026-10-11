class Restaurant < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :visit_histories, dependent: :destroy

  validates :name, presence: true

  # HotPepperから取得した詳細情報（キャッチコピー・予算・営業時間等）をHashで返す
  def detail
    return {} if detail_json.blank?

    JSON.parse(detail_json).symbolize_keys
  rescue JSON::ParserError
    {}
  end
end
