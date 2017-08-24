class Ki2Controller < ApplicationController
    protect_from_forgery

    def fillRegions
        unless @regions
            @regions = Ki2.regions()
        end
    end
    
    def fillYearsCache
        unless @years_cache
            @years_cache = Ki2.yearsCache()
        end
    end

    def yearFromParam(p)
        if /^\d\d\d\d$/.match(p) then
            return p.to_i
        else
            return Time.now.year
        end
    end

    def games
        fillRegions()
        fillYearsCache()

        @region_key = ''
        @region_name = 'Все'
        @year = nil
        if params[:key] then
            if @regions.key?(params[:key]) then
                @region_key = params[:key]
            else
                @year = yearFromParam(params[:key])
            end
        elsif params[:loc] != nil and params[:year] != nil then
            @region_key = params[:loc]
            @year = yearFromParam(params[:year])
        end
        
        @year = Time.now.year unless @year

        @region_name = @regions[@region_key][:name]

        @title = @region_name + ' ' + @year.to_s
    end

end

