class AdvancedReport::TopReport::AllProductsSold < AdvancedReport::TopReport
  def name
    "All products sold by revenue"
  end

  def description
    "Top selling products, calculated by revenue"
  end

  def initialize(params)
    super(params)
    adjustments=0
    total=0
    units=0
    orders.each do |order|
      adjustments+=order.adjustment_total.to_f
      total+=order.total.to_f
      order.line_items.each do |li|
        if !li.product.nil?
          data[li.product.id] ||= {
            :name => li.product.name.to_s,
            :revenue => 0,
            :units => 0
          }
          data[li.product.id][:revenue] += li.quantity*li.price 
          data[li.product.id][:units] += li.quantity
          units+=li.quantity
        end
      end
    end

    self.ruportdata = Table(%w[name Units Revenue])
    data.inject({}) { |h, (k, v) | h[k] = v[:revenue]; h }.sort { |a, b| a[1] <=> b [1] }.reverse.each do |k, v|
      ruportdata << { "name" => data[k][:name], "Units" => data[k][:units], "Revenue" => data[k][:revenue] } 
    end
    ruportdata << { "name" => "Total", "Units" => units, "Revenue" => total}
    ruportdata << { "name" => "Adjustments (Shipping etc.)", "Units" => orders.count, "Revenue" => adjustments}
    ruportdata.replace_column("Revenue") { |r| "£%0.2f" % r.Revenue }
    ruportdata.rename_column("name", "Product Name")
  end
end
