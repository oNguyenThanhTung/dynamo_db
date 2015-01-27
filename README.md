dynamo_db
========

Bài viết sẽ giới thiệuề DynamoDB, những định nghĩa và khái niệm quan trọng của DynamoDB và cách sử dụng DynamoDB
trong Ruby. Ngoài ra so sánh 2 No SQL DATABASE là DynamoDB và MongoDB.

1. DynamoDB là gì?
  DynamoDB là 1 No-SQL Database, 1 phần của Amazon Web Service, có sự ổn định, tốc độ nhanh chóng, thích hợp cho việc lưu trũ, xử lí 1 lượng lớn dữ liệu.

2. Định nghĩa trong DynamoDB

  DynamoDB có 4 định nghĩa cần phải chú ý là: bảng, chỉ số phụ, bản ghi và thuộc tính.

  2.1 Bảng (Table)

    Khi định nghĩa bảng trong DynamoDB cần phải cung cấp tên của bảng, khóa chính và giá trị xấc định thông lượng đọc ghi. Trong DynamoDB có 2 kiểu khóa chính

    - Khóa kiểu Hash: Khóa được tao bằng 1 thuộc tính kiểu hash trong bảng. Khi tạo bảng cần chỉ định thuộc tính nào sẽ được chọn làm khóa chính. Ví dụ bảng ProductCatalog có thể dùng ProductID làm khóa chính và DynamoDB sẽ xây dựng 1 hash index theo khóa chính

    - Khóa kiểu Hash and Range: Khóa được tạo bằng 2 thuộc tính trong bảng. 1 thuộc tính sẽ được sử dụng là Hash key và
  1 thuộc tính sẽ được sử dụng làm Range key dùng cho việc sắp xếp thuộc tính. Ví dụ 1 bảng Thread có thể dùng 2 field ForumName và Subject làm khóa chính với ForumName là thuộc tính kiểu Hash và Subject là thuộc tính kiểu range. DynamoDB sẽ xây dựng 1 hash index (không được sắp xếp) theo thuộc tính hash và 1 range index (theo thuộc tính range). Kết quả của câu lệnh truy vấn đươc sắp xếp theo range key.

  2.2 Chỉ số phụ(Secondary Indexes) hay khóa phụ

    Khi khai báo trong DynamoDB chúng ta có thể khai báo thêm các khóa phụ trong bảng. Mục đích là khi truy vấn có thể truy vấn theo các trường là khóa phụ mà không phụ thuộc vào khóa chính Có 2 kiểu khóa phụ trong DynamoDB:
  - Khóa phụ 1 phần (Local Secondary Indexs): là khóa phụ thuộc dạng kiểu Hash and Range key trong đó Hash key là
  thuộc tính giống như đã chọn khi tạo bảng, còn range key là thuộc tính muốn thêm vào khi query
  - Khóa phụ toàn bộ Global Secondary Indexes): là khóa phu thuộc dạng kiểu Hash and Range key trong đó cả Hash key
  và Range key đều không phải 2 thuộc tính Hash and Range Key khi tạo bảng.

  Hướng dẫn về cách sử dựng của 2 loại khóa phụ này sẽ nằm ở mục 3.

  2.3 Bản ghi (Item)

  Bản ghi trong DynamoDB về cơ bản thì cũng giống như bản ghi trong MongoDB hay là SQL, tức là sẽ chứa các giá trị của các thuộc tính. Tuy nhiên trong DynamoDB thì các bản ghi bắt buộc các trường khai báo là khóa chính phải có giá trị, không thể là null hay không tồn tại. Ví dụ, với 1 khóa chính kiểu hash thì chỉ yếu cầu thuộc tính kiểu hash đó phải có giá trị, nếu khóa chính kiểu hash-and-range thì cả thuộc tính kiểu hash và thuộc tính kiểu range đều yêu cầu phải có giá trị. Các bản ghi có thể có số lượng trường là khác nhau, tức là có bản ghi có 3 trường,có bản ghi có 4 trường hay 5 trường.

  2.4 Thuộc tính (attribues)

  Thuộc tính trong DynamoDB có các kiểu dữ liệu sau:

    ・Scalar types: bao gồm có Number, String, Binary, Boolean, and Null.

    ・Multi-valued types: bao gồm Mảng string(String Set), mảng number(Number Set), mảng binary(Binary Set).

    ・Document types: bao gồm List and Map.

3. Truy vấn trong DynamoDB

  Khi truy vấn trong DynamoDB thì ngoài việc phải khai báo là truy vấn từ bảng nào thì một điều rất quan trọng   là phải chỉ ra được giá trị của khóa của bản ghi chúng ta muốn tìm là bao nhiêu, hoặc phải chỉ ra 1 tập mà giá   trị của khóa của bản ghi muốn tìm nằm trong đó. Việc này giống như việc bắt buộc phải có câu lệnh ```ruby
  WHERE (id = 3)``` hay ``` WHERE id in [3, 4, 5]``` trong SQL vậy. Do đó việc chọn giá trị nào là khóa chính là cực kì quan trọng trong DynamoDB.
  Chẳng hạn có 1 bảng là Thread với các giá trị như sau:

  Forum Name( hash key)  | Subject( Range key)  | LastPostDateTime | Replies
  ---------------------- | -------------------- | ---------------- | ------
  S3  | AAA | 2014 - 12 - 12 | 6
  S3  | BBB | 2014 - 12 - 11 | 5
  S3  | CCC | 2014 - 12 - 10 | 7
  A4  | BBB | 2014 - 12 - 11 | 5
  A3  | DDD | 2014 - 12 - 11 | 5
  A6  | AAA | 2014 - 12 - 13 | 5

  Nếu không khai báo gì khác thì chỉ có thể lấy ra được cá bản ghi có trường Forum Name là S3 và Subject là AAA hoặc bản ghi có trường A3 mà không thể thực hiện được câu truy vấn ví dụ như đưa ra các bản ghi có của Forum S3 và có Replie là 5 hoặc đưa ra các bản ghi có LastPostDateTime là 2014 - 12 - 11 và có Replies là 5. Muốn thực hiện được các câu truy vấn như vậy thì phải sử dụng khóa phụ (Secondary Indexes).
  Local Secondary Indexes sẽ được sử dụng cho trường hợp đưa ra các bản ghi có của Forum S3 và có Replie là 5. Tức là các trường hợp mà câu lệnh truy vấn có liên quan đến HashKey, thì cần khai báo local secondary indexes vó hash key là hashkey của bảng, rangekey là trường Replies chẳng hạn. Sau đó chỉ đơn giản là khai báo cho Dynamo biết là truy vấn sẽ sử dụng Local Secondary Indexes, forum == S3 và Replies == 5.
  Global Secondary Indexes sẽ được sử dụng cho trường hợp  đưa ra các bản ghi có LastPostDateTime là 2014 - 12 - 11 và có Replies là 5. Tức là câu lệnh truy vấn ở đây không liên quan gì đến HashKey và Range Key của bảng. Khi định nghĩa Global Secondary Indexes cần chỉ ra Hash key và Range key mới.
  DynamoDB cho phép định nghĩa nhiều Secondary Indexes, tuy nhiên càng nhiều thì performance của truy vấn càng giảm xuống.Do đó khi tạo bảng trong Dynamo cần quan tâm đến việc trường nào sẽ thường xuyên được sử dụng trong truy vấn, trườn nào ít được sử dụng hoặc không sử dụng để đặt key cũng như khai báo Secondary Indexes một cách hợp lí.

4. DynamoDB Local

  Việc chạy DynamoDB trên server hiển nhiên sẽ cần phải trả phí. Tuy nhiên Amazon có hỗ trợ DynamoDB LOcal cho những người muốn sử dụng hay học DynamoDB trên Local mà không cần trả phí. Link chi tiết về cách cài cũng như chạy ở link dưới đây:
  http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Tools.DynamoDBLocal.html
  Tuy nhiên cần lưu í là Amazon DB Local sẽ chỉ chạy với version V20111205của AWS SDK Ruby.

5. DynamoDB trong Ruby

  AMAZON hỗ trỡ AWS SDK Ruby cho người sử dụng Ruby. Cần phải lưu í là hiện nay có 2 version cho AWS SDK Ruby là V20111205, V20120810. Link docs cho AWS SDK Ruby là:
  http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/DynamoDB/Client.html
  Điểm khác nhau giữa 2 version ngoài việc khác nhau ở tên khai báo là AWS và Aws thì còn có 1 khác nhau quan trọng là khi lưu hay xuất dữ liệu.
  Ví dụ khi cần gán giá trị cho trường id là 547bdd4072dc47de74c1f44c
  Đối với version V20120810 thì ghi án giá trị cần phải chỉ ra giá trị đó là thuộc kiểu dữ liệu nào, String hay Integer hay Binary... ví dụ ``` {"_id" => {"S" => "547bdd4072dc47de74c1f44c"} ``` và dữ liệu khi lấy ra cũng sẽ có dạng như vậy.
  Còn đối với version V20111205 thì không cần chỉ ra kiểu dữ liệu chỉ cần khai báo ``` {"_id" => {"S" => "547bdd4072dc47de74c1f44c"} ```. Dữ liệu khi lấy ra cũng sẽ không kèm theo kiểu dữ liệu.

  Sau đây sẽ hướng dẫn cơ bản về cách tạo bảng, lưu dữ liệu , xuất dữ liệu cũng như các chú ý.
  5.1 Tạo bảng

    Ví dụ cho tạo bảng với local secondary indexes
    ```ruby
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
    ```
    Tạo bảng sử dụng global secondary indexes
    ```ruby
      result = dynamo_db.create_table(
        table_name: "issues",
        attribute_definitions: [
          {attribute_name: "issue_id", attribute_type: "S"},
          {attribute_name: "title", attribute_type: "S"},
          {attribute_name: "created_date", attribute_type: "S"},
          {attribute_name: "due_date", attribute_type: "S"}
        ],

        key_schema: [
          {attribute_name: "issue_id", key_type: "HASH"},
          {attribute_name: "title", key_type: "RANGE"}
        ],

        global_secondary_indexes: [
          {
            index_name: "created_date_index",
            key_schema: [
              {attribute_name: "created_date", key_type: "HASH"},
              {attribute_name: "issue_id", key_type: "RANGE"}
            ],
            projection: {
              projection_type: "INCLUDE",
              non_key_attributes: ["description", "status"]
            },
            provisioned_throughput: {
              read_capacity_units: 10,
              write_capacity_units: 5
            }
          },

          {
            index_name: "title_index",
            key_schema: [
              {attribute_name: "title", key_type: "HASH"},
              {attribute_name: "issue_id", key_type: "RANGE"}
            ],
            projection: {
              projection_type: "KEYS_ONLY"
            },
            provisioned_throughput: {
              read_capacity_units: 10,
              write_capacity_units: 5
            }
          },

          {
            index_name: "due_date_index",
            key_schema: [
              {attribute_name: "due_date", key_type: "HASH"}
            ],
            projection: {
              projection_type: "ALL"
            },
            provisioned_throughput: {
              read_capacity_units: 10,
              write_capacity_units: 5
            }
          }
        ],

        provisioned_throughput: {
          read_capacity_units: 10,
          write_capacity_units: 5
        }
      )
    ```
    Khi tạo bảng cần phải khai báo tất cả các trường sẽ được sử dụng làm key trong ```attribute_definitions```.
  Và khi lưu dữ liệu vào bảng tất cả các trường này buộc phải có giá trị, không thê null hay không tồn tại.

  5.2 Truy vấn

    Dưới đây sẽ là câu truy vấn cho ví dụ đưa ra các bản ghi có LastPostDateTime là 2014 - 12 - 11 và có
  Replies là 5
    ```ruby
      forum_value = dynamo_db.query(
      table_name: "issues",
      index_name: "created_date_index",
      key_conditions: {
        "created_date" => {
          attribute_value_list: ["2013-11-01"],
          comparison_operator: "EQ"
        },
        "Replies" => {
          attribute_value_list: [5],
          comparison_operator: "5"
        }
      }
      # select: "ALL_PROJECTED_ATTRIBUTES",
      # return_consumed_capacity: "ALL"
    )
    ```
   Dữ liệu đưa ra có dạng sau:
   ```
   {"uid"=>#<BigDecimal:3c46730,'0.2014102011 37202443E18',18(27)>, "sid"=>#<BigDecimal:3c464b0,'0.2014120214 4417678E18',18(27)>, "resolution"=>"1920x1080", "url"=>"https://ferret-plus.com/", "ip"=>"118.22.215.89", "referrer"=>"https://ferret-plus.com/", "title"=>"Ferret [フェレット]｜webマーケティングがわかる・できる・がんばれる", "updated_at"=>"2014-12-02 05:44:12", "_id"=>"547d51ac72dc47de74c26382", "created"=>"2014-12-02 05:44:09", "created_at"=>"2014-12-02 05:44:12", "ua"=>"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36", "client_id"=>"c14101400051"}
   ```

6. MongoDB vs DynamoDB

  MongoDB và DynamoDB đều là No-SQL vậy điều gì khác nhau giữa 2 database này:
    - Về query: Cả 2 sẽ đều query trực tiếp lên bảng trong database. Tuy nhiên MongoDB cung cấp khả năng query mạnh hơn rất nhiều, khi có thể sắp xếp, so sánh vs regex... Hoặc bằng cách sử dụng $aggreation thì MongoDB cho phép sử dụng nhiều query một lúc mà output của query này sẽ là input của query sau. Ngoải ra số lượng giá trị đưa ra của DynamoDB cũng là có hạn cho 1 lần query là 1Mb data.
    - Về tạo bảng: Theo ý kiến đánh giá cá nhân thì mặc dù khai báo bảng trong DynamoDB rất phực tạp khi ngoài key còn phải tính toán khai báo về local hay global secondary indexes tuy nhiên khi khai báo bảng trong DynamoDB thì còn có thể khai báo cả về tốc độ đọc hay ghi của bảng. Dù chưa sử dụng đến hết khả năng của DynamoDB nhưng điều này có thể khiến performance của Dynamodb cao hơn???
    - Về bản ghi: Bản ghi trong DynamoDB có thể có số lượng trường tùy ý (ngoài key) tuy nhiên 1 trường của bản ghi cũng ko thể quá 400KB data.
  Ngoài ra còn 1 và điểm khác nhau thì được ghi ở chú ý mục 7.
  Điểm giống nhau là cả 2 đều được sử dụng trong big data, lưu data với dữ liệu lớn.

7. Một vài chú ý về DynamoDB
  - Không có hàm delete toàn bộ bản ghi trong bảng, chỉ có thể delete được bằng cách delete bảng hoặc tạo 1 vòng loop duyệt toàn bộ bản ghi và xóa ( performance sẽ rất thấp)
  - Không có hàm delete 1 trường cho tất cả các bản ghi. VÍ dụ delete trường Replies ở bảng Thread kể trên. Ngoại trừ việc tạo vòng loop :(
  2 chú ý trên đã được tìm kiếm và xác nhận là không thể trong DynamoDB.


