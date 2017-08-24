class Ki2Controller < ApplicationController
    protect_from_forgery

    def fillRegions
        unless @regions
            @regions = Ki2.regions()
        end
    end

    def games
        fillRegions()

        @region_key = ''
        @region_name = 'Все'
        @year = nil
        if params[:key] then
            if @regions.key?(params[:key]) then
                @region_key = params[:key]
            elsif /^\d\d\d\d$/.match(params['key']) then
                @year = params[:key].to_i
            end
        elsif params[:loc] != nil and params[:year] != nil then
            @region_key = params[:loc]
            @year = params[:year]
        end
        
        @year = Time.now.year unless @year

        @region_name = @regions[@region_key]
    end

end

