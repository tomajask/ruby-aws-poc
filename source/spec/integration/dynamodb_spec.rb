# frozen_string_literal: true

RSpec.describe DynamoDB do
  let(:db) { DynamoDB.new }

  describe "Basic operations on DynamoDB" do
    it "works as expected", :aggregate_failures do
      #### Create table

      db.create_table(
        {
          attribute_definitions: [
            {
              attribute_name: "Artist",
              attribute_type: "S",
            },
            {
              attribute_name: "SongTitle",
              attribute_type: "S",
            },
          ],
          key_schema: [
            {
              attribute_name: "Artist",
              key_type: "HASH",
            },
            {
              attribute_name: "SongTitle",
              key_type: "RANGE",
            },
          ],
          provisioned_throughput: {
            read_capacity_units: 5,
            write_capacity_units: 5,
          },
          table_name: "Music",
        }
      )


      ### Create items

      db.put_item({
        item: {
          "AlbumTitle"  => "Somewhat Famous",
          "Artist"      => "No One You Know",
          "SongTitle"   => "Call Me Today",
        },
        return_consumed_capacity: "TOTAL",
        table_name: "Music",
      })

      db.put_item({
        item: {
          "AlbumTitle"  => "Trying Again",
          "Artist"      => "No One You Know",
          "SongTitle"   => "I forgot",
        },
        return_consumed_capacity: "TOTAL",
        table_name: "Music",
      })

      db.put_item({
        item: {
          "AlbumTitle"  => "25",
          "Artist"      => "Adele",
          "SongTitle"   => "Hello",
          "Authors"     => "Adele Adkins, Greg Kurstin"
        },
        return_consumed_capacity: "TOTAL",
        table_name: "Music",
      })


      ### Get item

      item = db.get_item({
        key: {
          "Artist"    => "Adele",
          "SongTitle" => "Hello",
        },
        table_name: "Music",
      })

      expect(item.to_h).to eq({
        item: {
          "Artist"      =>"Adele",
          "AlbumTitle"  =>"25",
          "SongTitle"   =>"Hello",
          "Authors"     =>"Adele Adkins, Greg Kurstin"
        },
      })


      ### Querying items

      queried_items = db.query({
        expression_attribute_values: {
          ":v1" => "No One You Know",
        },
        key_condition_expression: "Artist = :v1",
        projection_expression: "SongTitle",
        table_name: "Music",
      })

      expect(queried_items.to_h).to eq({
        count: 2,
        items: [
          { "SongTitle" => "Call Me Today" },
          { "SongTitle" => "I forgot" }
        ],
        scanned_count: 2,
      })


      ### Scanning items

      scanned_items = db.scan({
        expression_attribute_names: {
          "#AT" => "AlbumTitle",
          "#ST" => "SongTitle",
        },
        expression_attribute_values: {
          ":a" => "No One You Know",
        },
        filter_expression: "Artist = :a",
        projection_expression: "#ST, #AT",
        table_name: "Music",
      })

      expect(scanned_items.to_h).to eq({
        count: 2,
        items: [
          {
            "AlbumTitle" => "Somewhat Famous",
            "SongTitle"  => "Call Me Today",
          },
          {
            "AlbumTitle" => "Trying Again",
            "SongTitle"  => "I forgot",
          }
        ],
        scanned_count: 3,
      })


      ### Updating item

      updated_item = db.update_item({
        expression_attribute_names: {
          "#AT" => "AlbumTitle",
          "#Y" => "Year",
        },
        expression_attribute_values: {
          ":t" => "Louder Than Ever",
          ":y" => "2015",
        },
        key: {
          "Artist" => "No One You Know",
          "SongTitle" => "Call Me Today",
        },
        return_values: "ALL_NEW",
        table_name: "Music",
        update_expression: "SET #Y = :y, #AT = :t",
      })

      expect(updated_item.to_h).to eq({
        attributes: {
          "AlbumTitle"  => "Louder Than Ever",
          "Artist"      => "No One You Know",
          "SongTitle"   => "Call Me Today",
          "Year"        => "2015",
        },
      })

      scanned_item = db.scan({
        expression_attribute_names: {
          "#AT" => "AlbumTitle",
          "#ST" => "SongTitle",
          "#YR" => "Year",
        },
        expression_attribute_values: {
          ":st" => "Call Me Today",
        },
        filter_expression: "SongTitle = :st",
        projection_expression: "#ST, #AT, #YR",
        table_name: "Music",
      })
      expect(scanned_item.to_h).to eq({
        count: 1,
        items: [
          {
            "AlbumTitle" => "Louder Than Ever",
            "SongTitle"  => "Call Me Today",
            "Year"       => "2015"
          },
        ],
        scanned_count: 3,
      })


      ### Deleting item

      db.delete_item({
        key: {
          "Artist"    => "No One You Know",
          "SongTitle" => "Call Me Today",
        },
        table_name: "Music",
      })

      deleted_item = db.get_item({
        key: {
          "Artist"    => "No One You Know",
          "SongTitle" => "Call Me Today",
        },
        table_name: "Music",
      })
      expect(deleted_item.to_h).to eq({})
    end
  end
end
