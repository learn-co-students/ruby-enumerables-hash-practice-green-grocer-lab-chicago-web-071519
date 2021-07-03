def consolidate_cart(cart)
  cart_hash = {}
  cart.each { |item| 
    item.each { |key, value| 
      if cart_hash[key]
        cart_hash[key][:count] += 1
      else
        cart_hash[key] = value
        cart_hash[key][:count] = 1
      end
    }
  } 
  cart_hash
end



def apply_coupons(cart, coupons)
  cart = cart

  valid_coupons = []
  coupons.each { |coupon|
    if cart.key?(coupon[:item])
      valid_coupons.push(coupon)
    end  
  }

  valid_coupons.each do |coupon|
    if cart[coupon[:item]][:count] >= coupon[:num]
      if !cart["#{coupon[:item]}" + " W/COUPON"]
        cart["#{coupon[:item]}" + " W/COUPON"] = {
         :price => (coupon[:cost] / coupon[:num]).round(2),
         :clearance => cart[coupon[:item]][:clearance],
         :count => coupon[:num]
       }
      else
        cart["#{coupon[:item]}" + " W/COUPON"][:count] += coupon[:num]
      end     
    cart[coupon[:item]][:count] -= coupon[:num]
    end
  end  
  cart
end



def apply_clearance(cart)
  cart.each {|key, value| 
    if cart[key][:clearance]
     cart[key][:price] = (cart[key][:price] * 0.8).round(2)
    else
      cart[key][:price]
    end  
  }
end



def checkout(cart, coupons)
  total = 0
  
  consolidated_cart = consolidate_cart(cart)
  
  cart_with_coupons_applied = apply_coupons(consolidated_cart, coupons)
  
  cart_with_clearance_applied = apply_clearance(cart_with_coupons_applied)
  
  cart_with_clearance_applied.each do |item, value|
     total += value[:price] * value[:count]
  end   
  
  total > 100 ? total * 0.9 : total
end



