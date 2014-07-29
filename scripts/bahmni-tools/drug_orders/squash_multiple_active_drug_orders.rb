#!/usr/bin/ruby
require 'mysql2'
require 'micro-optparse'

# Required Gems : mysql2, micro-optparse
parser = Parser.new do |p|
   p.banner = "Usage: ruby #{__FILE__} [options]"
   p.option :host, "Host name or IP", :default => "192.168.33.10", :short => 'H'
   p.option :username, "Mysql user", :default => "openmrs-user"
   p.option :password, "Mysql password", :default => "password"
   p.option :database, "Mysql db", :default => "openmrs"
   p.option :date, "Date to consider active orders (yyyy-mm-dd)", :default => "2014-07-28"
   p.option :dry_run, "Dry run mode", :default => true
end
options = parser.process!

@openmrs_conn = Mysql2::Client.new(options)
@dry_run = options[:dry_run]

@multiple_active_drug_orders_sql = "Select patient_id, drug_inventory_id, COUNT(*) as count, group_concat(orders.order_id) as order_ids_string from drug_order
join orders on drug_order.order_id = orders.order_id
where voided = 0 and orders.auto_expire_date > '#{options[:date]}'
group by patient_id, drug_inventory_id
HAVING COUNT(drug_inventory_id) > 1;"

def query(sql)
  @openmrs_conn.query(sql, :symbolize_keys => true)
end

def update_query(sql)
  @dry_run ? puts(sql) : query(sql)
end

def squash_multiple_active_drug_orders
  query(@multiple_active_drug_orders_sql).each do |row|
      active_orders = query("Select order_id, start_date, auto_expire_date, datediff(auto_expire_date, start_date) as number_of_days 
                             FROM orders 
                             WHERE order_id IN (#{row[:order_ids_string]}) 
                             ORDER BY start_date ASC").to_a
      total_number_of_days = active_orders.inject(0) {|total, order| total + order[:number_of_days] }
      first_order = active_orders.shift
      remaining_orders = active_orders
      remaining_orders_ids_string = remaining_orders.map {|order| order[:order_id] }.join(',')

      if (@dry_run)
        puts "*" * 100
        puts first_order
        puts remaining_orders
        puts total_number_of_days
      end
      update_query("UPDATE orders 
            SET auto_expire_date = date_add(start_date, INTERVAL #{total_number_of_days} DAY)
            WHERE order_id = #{first_order[:order_id]};")
      update_query("UPDATE orders 
            SET voided = true, void_reason = 'To Merge Active Orders', voided_by = 1
            WHERE order_id IN (#{remaining_orders_ids_string});")
  end
end

squash_multiple_active_drug_orders