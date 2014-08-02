class Company < ActiveRecord::Base


    def self.add(name)
        unless Company.all.map do |company| company.company_name.downcase end.include?(name.downcase)
            Company.create(company_name: name.titleize)
        end
    end
end
