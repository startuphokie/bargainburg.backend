namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    [Merchant, Coupon, PointOfContact, User].each(&:delete_all)

    Category.all.each do |category|
      Merchant.populate 1..10 do |merchant|
        merchant.category_id = category.id
        merchant.name = Faker::Company.name
        merchant.email = Faker::Internet.email
        merchant.description = Populator.sentences(2..10)
        merchant.price_range = [1,2,3,4]
        merchant.created_at = 2.years.ago..Time.now
        merchant.approved = [true, false]
        merchant.phone   = Faker::PhoneNumber.phone_number
        merchant.hours = "M-F 9-5"
        merchant.link = Faker::Internet.url
        merchant.address = Faker::Address.street_address
        merchant.user_id = -1

        Coupon.populate 5 do |coupon|
          coupon.name    = Faker::Name.name
          coupon.begin_date = 2.month.ago..1.month.ago
          coupon.end_date = 1.month.ago..1.month.from_now
          coupon.description = Populator.sentences(2..10)
          coupon.hidden = [true,false]
          coupon.category_id = category.id
          coupon.merchant_id = merchant.id
        end

        PointOfContact.populate 2 do |poc|
          poc.name	= Faker::Name.name
          poc.phone	= Faker::PhoneNumber.phone_number
          poc.email	= Faker::Internet.email
          poc.merchant_id = merchant.id
        end
      end
    end
    u = User.create(:email => 'test', :password => 'test123', :password_confirmation => 'test123')
    m = Merchant.take
    m.approved = true
    m.user = u
    m.save

    u.merchant = m
    u.save
  end
end
