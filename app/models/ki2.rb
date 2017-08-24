class Ki2 < ActiveRecord::Base
    def self.regions()
        rows = connection.select_all("select region_id, region_code, region_name from ki_regions order by region_id asc")
        
        ret = {}

        rows.to_hash.each do |row|
            ret[row["region_code"]] = {:name => row["region_name"], :id => row["region_id"]}
        end

        return ret
    end

    def self.yearsCache()
        rows = connection.select_all("select year, region_id from ki_years_cache")

        ret = {}

        ret[1] = []
        rows.to_hash.each do |row|
            #unless ret.key?(row["year"])
            #    ret[row["year"]] = []
            #end
            #ret[row["year"]].push(row["region_id"])


            unless ret.key?(row["region_id"])
                ret[row["region_id"]] = []
            end
            ret[row["region_id"]].push(row["year"])
            ret[1].push(row["year"])
        end

        puts ret

        ret.each do |key, value|
            value.sort!
            value.uniq!
        end
        puts ret

        return ret
    end
end
