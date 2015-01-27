require 'aws-sdk-core'
require 'pry'

# DynamoDB Local connection
@dynamo_db = Aws::DynamoDB::Client.new(
  access_key_id: "test",
  secret_access_key: "testtest",
  endpoint: 'http://localhost:8000', region: 'ap-northeast-1')

list_tables = @dynamo_db.list_tables.data.table_names
@dynamo_db.delete_table(table_name: "accesslog") if list_tables.include? "accesslog"

accesslog_table = @dynamo_db.create_table(
  table_name: "accesslog",
  attribute_definitions: [
    {attribute_name: "client_id", attribute_type: "S"},
    {attribute_name: "_id", attribute_type: "S"},
    {attribute_name: "uid", attribute_type: "N"}
  ],
  key_schema: [
    {attribute_name: "client_id", key_type: "HASH"},
    {attribute_name: "_id", key_type: "RANGE"}
  ],
  local_secondary_indexes: [
    {
      index_name: "uid_index",
      key_schema: [
        {attribute_name: "client_id", key_type: "HASH"},
        {attribute_name: "uid", key_type: "RANGE"}
      ],
      projection: {
        projection_type: "ALL"
      }
    }
  ],
  provisioned_throughput: {
    read_capacity_units: 10,
    write_capacity_units: 5
  }
)

data = [
 {"_id" => "547bdd4072dc47de74c1f44c", "created_at" => "2014-12-01 03:15:12", "updated_at" => "2014-12-01 03:15:12", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412011215155767, "url" => "https://ferret-plus.com/457", "referrer" => "(not set)", "title" => "Web担当者必見！Webマーケティング関連の良質なスライド資料30選｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 03:15:08"},
 {"_id" => "547bdd4672dc47de74c1f44f", "created_at" => "2014-12-01 03:15:18", "updated_at" => "2014-12-01 03:15:18", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412011215155767, "url" => "https://ferret-plus.com/news?tag=リスティング広告", "referrer" => "(not set)", "title" => "「リスティング広告」に関するまとめ読みニュース　1記事｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 03:15:13"},
 {"_id" => "547bddf172dc47de74c1f49a", "created_at" => "2014-12-01 03:18:09", "updated_at" => "2014-12-01 03:18:09", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412011215155767, "url" => "https://ferret-plus.com/3", "referrer" => "(not set)", "title" => "SEOでキーワード選定が重要な理由｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 03:18:07"},
 {"_id" => "547bddf672dc47de74c1f49e", "created_at" => "2014-12-01 03:18:14", "updated_at" => "2014-12-01 03:18:14", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412011215155767, "url" => "https://ferret-plus.com/62", "referrer" => "(not set)", "title" => "Google AdWordsキーワードプランナーの使い方｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 03:18:10"},
 {"_id" => "547cdc9c72dc47de74c229e8", "created_at" => "2014-12-01 21:24:44", "updated_at" => "2014-12-01 21:24:44", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/", "referrer" => "(not set)", "title" => "Ferret [フェレット]｜webマーケティングがわかる・できる・がんばれる", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:24:42"},
 {"_id" => "547cdca872dc47de74c229ea", "created_at" => "2014-12-01 21:24:56", "updated_at" => "2014-12-01 21:24:56", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/curriculums", "referrer" => "(not set)", "title" => "カリキュラム｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:24:54"},
 {"_id" => "547cdcae72dc47de74c229ee", "created_at" => "2014-12-01 21:25:02", "updated_at" => "2014-12-01 21:25:02", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/users/sign_in", "referrer" => "(not set)", "title" => "ログイン｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:25:01"},
 {"_id" => "547cdcb872dc47de74c229f0", "created_at" => "2014-12-01 21:25:12", "updated_at" => "2014-12-01 21:25:12", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/users/sign_up#_=_", "referrer" => "https://ferret-plus.com/users/auth/facebook", "title" => "新規登録｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:25:11"},
 {"_id" => "547cdcc272dc47de74c229f2", "created_at" => "2014-12-01 21:25:22", "updated_at" => "2014-12-01 21:25:22", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/users/sign_in", "referrer" => "https://ferret-plus.com/users/auth/facebook", "title" => "ログイン｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:25:20"},
 {"_id" => "547cdcd872dc47de74c229f8", "created_at" => "2014-12-01 21:25:44", "updated_at" => "2014-12-01 21:25:44", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/users/sign_in", "referrer" => "https://ferret-plus.com/users/sign_in", "title" => "ログイン｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:25:43"},
 {"_id" => "547cdcf272dc47de74c229fc", "created_at" => "2014-12-01 21:26:10", "updated_at" => "2014-12-01 21:26:10", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/curriculums", "referrer" => "https://ferret-plus.com/users/sign_in", "title" => "カリキュラム｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:26:08"},
 {"_id" => "547cdcf872dc47de74c22a00", "created_at" => "2014-12-01 21:26:16", "updated_at" => "2014-12-01 21:26:16", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/news", "referrer" => "https://ferret-plus.com/users/sign_in", "title" => "まとめ読みニュース ｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:26:14"},
 {"_id" => "547cdcfc72dc47de74c22a02", "created_at" => "2014-12-01 21:26:20", "updated_at" => "2014-12-01 21:26:20", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/", "referrer" => "https://ferret-plus.com/users/sign_in", "title" => "Ferret [フェレット]｜webマーケティングがわかる・できる・がんばれる", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:26:18"},
 {"_id" => "547cdd0072dc47de74c22a04", "created_at" => "2014-12-01 21:26:24", "updated_at" => "2014-12-01 21:26:24", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412020624519820, "url" => "https://ferret-plus.com/432", "referrer" => "https://ferret-plus.com/", "title" => "【永久保存】Webマーケティングに役立つ心理学用語36選｜Ferret [フェレット]", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-01 21:26:23"},
 {"_id" => "547d51ac72dc47de74c26382", "created_at" => "2014-12-02 05:44:12", "updated_at" => "2014-12-02 05:44:12", "client_id" => "c14101400051", "uid" => 201410201137202443, "sid" => 201412021444176780, "url" => "https://ferret-plus.com/", "referrer" => "https://ferret-plus.com/", "title" => "Ferret [フェレット]｜webマーケティングがわかる・できる・がんばれる", "ip" => "118.22.215.89", "ua" => "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "resolution" => "1920x1080", "created" => "2014-12-02 05:44:09"}
]

data.each do |i|
  @dynamo_db.put_item(
    table_name: "accesslog",
    item: i
  )
end

value = @dynamo_db.query(
  table_name: "accesslog",
  index_name: "uid_index",
  key_conditions: {
    "client_id" => {
      attribute_value_list: ["c14101400051"],
      comparison_operator: "EQ"
    },
    "uid" => {
      attribute_value_list: [201410201137202443],
      comparison_operator: "EQ"
    }
  },
  query_filter: {
    "sid" => {
      attribute_value_list: [201412021444176780],
      comparison_operator: "EQ"
    }
  },
  select: "ALL_PROJECTED_ATTRIBUTES"
)

puts value.data.items