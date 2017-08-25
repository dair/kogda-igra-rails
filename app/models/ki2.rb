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

    def self.games(region_id, year)
        rows = connection.select_all("select g.id, g.status, g.name, g.uri, g.vk_club, g.lj_comm, g.fb_comm, g.players_count, g.mg, g.email,
                sr.sub_region_name, sr.sub_region_disp_name,
                d.begin as date_start, d.time as date_duration, adddate(d.begin, d.time) as date_finish,
                s.status_name, s.status_style, s.show_date_flag,
                t.game_type_name, t.show_all_regions,
                p.polygon_name
            from ki_games g, ki_sub_regions sr, ki_status s, ki_game_date d, ki_game_types t, ki_polygons p
            where g.deleted_flag = 0 and
                  g.status = s.status_id and
                  g.sub_region_id = sr.sub_region_id and
                  g.id = d.game_id and
                  g.type = t.game_type_id and
                  g.polygon = p.polygon_id and
                  (#{region_id} = 1 or t.show_all_regions = 1 or sr.region_id = #{region_id}) and
                  (year(adddate(d.begin, d.time)) = #{year} or year(d.begin) = #{year})
                  
                  order by date_start asc
                  ")
            return rows.to_hash
    end
end

