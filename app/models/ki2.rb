class Ki2 < ActiveRecord::Base
    def self.regions()
        rows = connection.select_all("select region_code, region_name from ki_regions order by region_id asc")
        
        ret = {}

        rows.to_hash.each do |row|
            ret[row["region_code"]] = row["region_name"]
        end

        return ret
    end
end
