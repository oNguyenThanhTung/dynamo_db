require 'aws-sdk-core'

dynamo_db = Aws::DynamoDB::Client.new(
  access_key_id: "test",
  secret_access_key: "testtest",
  endpoint: 'http://localhost:8000', region: 'ap-northeast-1')

list_tables = dynamo_db.list_tables.data.table_names
dynamo_db.delete_table(table_name: "issues") if list_tables.include? "issues"

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

items = Array.new

items << {"issue_id" => "A-101",
  "title" => "Compilation error",
  "description" => "Can't compile Project X - bad version number. What does this mean?",
  "created_date" => "2013-11-01",
  "last_updated_date" => "2013-11-02",
  "due_date" => "2013-11-10",
  "priority" => 1,
  "status" => "Assigned"}

items << {"issue_id" => "A-102",
  "title" => "Can't read data file",
  "description" => "The main data file is missing, or the permissions are incorrect",
  "created_date" => "2013-11-01",
  "last_updated_date" => "2013-11-04",
  "due_date" => "2013-11-30",
  "priority" => 2,
  "status" => "In progress"}

items << {"issue_id" => "A-103",
  "title" => "Test failure",
  "description" => "Functional test of Project X produces errors",
  "created_date" => "2013-11-01",
  "last_updated_date" => "2013-11-02",
  "due_date" => "2013-11-10",
  "priority" => 1,
  "status" => "In progress"}

items << {"issue_id" => "A-104",
  "title" => "Compilation error",
  "description" => "Variable 'messageCount' was not initialized.",
  "created_date" =>"2013-11-15",
  "last_updated_date" => "2013-11-16",
  "due_date" => "2013-11-30",
  "priority" => 3,
  "status" =>"Assigned"}

items << {"issue_id" => "A-105",
  "title" => "Network issue",
  "description" => "Can't ping IP address 127.0.0.1. Please fix this.",
  "created_date" =>"2013-11-15",
  "last_updated_date" => "2013-11-16",
  "due_date" => "2013-11-19",
  "priority" => 5,
  "status" =>"Assigned"}

items.each do |i|
  dynamo_db.put_item(
    table_name: "issues",
    item: i
  )
end

forum_value = dynamo_db.query(
  table_name: "issues",
  index_name: "created_date_index",
  key_conditions: {
    "created_date" => {
      attribute_value_list: ["2013-11-01"],
      comparison_operator: "EQ"
    },
    "issue_id" => {
      attribute_value_list: ["A-"],
      comparison_operator: "BEGINS_WITH"
    }
  }
  # select: "ALL_PROJECTED_ATTRIBUTES",
  # return_consumed_capacity: "ALL"
)

puts forum_value.data