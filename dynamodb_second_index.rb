require 'aws-sdk-core'

dynamo_db = Aws::DynamoDB::Client.new(
  access_key_id: "test",
  secret_access_key: "testtest",
  endpoint: 'http://localhost:8000', region: 'ap-northeast-1')

list_tables = dynamo_db.list_tables.data.table_names
dynamo_db.delete_table(table_name: "CustomerOrders") if list_tables.include? "CustomerOrders"

result = dynamo_db.create_table(
  table_name: "CustomerOrders",
  attribute_definitions: [
    {attribute_name: "CustomerId", attribute_type: "S"},
    {attribute_name: "OrderId", attribute_type: "N"},
    {attribute_name: "OrderCreationDate", attribute_type: "S"},
    {attribute_name: "IsOpen", attribute_type: "N"}
  ],
  key_schema: [
    {attribute_name: "CustomerId", key_type: "HASH"},
    {attribute_name: "OrderId", key_type: "RANGE"}
  ],
  local_secondary_indexes: [
    {
      index_name: "OrderCreationDateIndex",
      key_schema: [
        {attribute_name: "CustomerId", key_type: "HASH"},
        {attribute_name: "OrderCreationDate", key_type: "RANGE"}
      ],
      projection: {
        projection_type: "INCLUDE",
        non_key_attributes: ["ProductCategory", "ProductName"]
      }
    },
    {
      index_name: "IsOpenIndex",
      key_schema: [
        {attribute_name: "CustomerId", key_type: "HASH"},
        {attribute_name: "IsOpen", key_type: "RANGE"}
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

items = Array.new

items << {"CustomerId"  => "alice@example.com",
  "OrderId" => 1,
  "IsOpen" => 1,
  "OrderCreationDate" => "#{DateTime.new(2013,1,1).to_time}",
  "ProductCategory" => "Book",
  "ProductName" => "The Great Outdoors",
  "OrderStatus" => "PACKING ITEMS"}

items << {"CustomerId" => "alice@example.com",
  "OrderId" => 2,
  "IsOpen" => 1,
  "OrderCreationDate" => "#{DateTime.new(2013,2,21).to_time}",
  "ProductCategory" => "Bike",
  "ProductName" => "Super Mountain",
  "OrderStatus" => "ORDER RECEIVED"}

items << {"CustomerId" => "alice@example.com",
  "OrderId" => 3,
  # no IsOpen attribute
  "OrderCreationDate" => "#{DateTime.new(2013,3,4).to_time}",
  "ProductCategory" => "Music",
  "ProductName" => "A Quiet Interlude",
  "OrderStatus" => "IN TRANSIT",
  "ShipmentTrackingId" => "176493"}

items << {"CustomerId" => "bob@example.com",
  "OrderId"  => 1,
  # no IsOpen attribute
  "OrderCreationDate" => "#{DateTime.new(2013,1,11).to_time}",
  "ProductCategory" => "Movie",
  "ProductName" => "Calm Before The Storm",
  "OrderStatus" => "SHIPPING DELAY",
  "ShipmentTrackingId" => "859323"}

items << {"CustomerId" => "bob@example.com",
  "OrderId" => 2,
  #  no IsOpen attribute
  "OrderCreationDate" => "#{DateTime.new(2013,1,24).to_time}",
  "ProductCategory" => "Music",
  "ProductName" => "E-Z Listening",
  "OrderStatus" => "DELIVERED",
  "ShipmentTrackingId" => "756943"}

items << {"CustomerId" => "bob@example.com",
  "OrderId" => 3,
  #  no IsOpen attribute
  "OrderCreationDate" => "#{DateTime.new(2013,2,21).to_time}",
  "ProductCategory" => "Music",
  "ProductName" => "Symphony 9",
  "OrderStatus" => "DELIVERED",
  "ShipmentTrackingId" => "645193"}

items << {"CustomerId" => "bob@example.com",
  "OrderId" => 4,
  #  Open"              => 1,
  "OrderCreationDate" => "#{DateTime.new(2013,2,22).to_time}",
  "ProductCategory" => "Hardware",
  "ProductName" => "Extra Heavy Hammer",
  "OrderStatus" => "PACKING ITEMS"}

items << {"CustomerId" => "bob@example.com",
  "OrderId" => 5,
  #  no IsOpen attribute
  "OrderCreationDate" => "#{DateTime.new(2013,3,9).to_time}",
  "ProductCategory" => "Book",
  "ProductName" => "How To Cook",
  "OrderStatus" => "IN TRANSIT",
  "ShipmentTrackingId" => "440185"}

items << {"CustomerId" => "bob@example.com",
  "OrderId" => 6,
  #  no IsOpen attribute
  "OrderCreationDate" => "#{DateTime.new(2013,3,18).to_time}",
  "ProductCategory" => "Luggage",
  "ProductName" => "Really Big Suitcase",
  "OrderStatus" => "DELIVERED",
  "ShipmentTrackingId" => "893927"}

items << {"CustomerId" => "bob@example.com",
  "OrderId" => 7,
  #  no IsOpen attribute
  "OrderCreationDate" => "#{DateTime.new(2013,3,24).to_time}",
  "ProductCategory" => "Golf",
  "ProductName" => "PGA Pro II",
  "OrderStatus" => "OUT FOR DELIVERY",
  "ShipmentTrackingId" => "383283"}

items.each do |i|
  dynamo_db.put_item(
    table_name: "CustomerOrders",
    item: i
  )
end

forum_value = dynamo_db.query(
  table_name: "CustomerOrders",
  index_name: "OrderCreationDateIndex",
  key_conditions: {
    "CustomerId" => {
      attribute_value_list: ["bob@example.com"],
      comparison_operator: "EQ"
    },
    "OrderCreationDate" => {
      attribute_value_list: ["#{DateTime.new(2013,1,1).to_time}"],
      comparison_operator: "GE"
    }
  },
  select: "ALL_PROJECTED_ATTRIBUTES",
  return_consumed_capacity: "ALL"
)

puts forum_value.data