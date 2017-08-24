class Ki2Controller < ApplicationController
    protect_from_forgery

    helper_method :dateRangeToText

    def monthText(mon)
        if mon == 1
            return "января"
        elsif mon == 2
            return "февраля"
        elsif mon == 3
            return "марта"
        elsif mon == 4
            return "апреля"
        elsif mon == 5
            return "мая"
        elsif mon == 6
            return "июня"
        elsif mon == 7
            return "июля"
        elsif mon == 8
            return "августа"
        elsif mon == 9
            return "сентября"
        elsif mon == 10
            return "октября"
        elsif mon == 11
            return "ноября"
        elsif mon == 12
            return "декабря"
        end
    end

    def dateRangeToText(start, finish)
        ds = start.day
        ms = start.month
        ys = start.year

        df = finish.day
        mf = finish.month
        yf = finish.year

        if ys != yf
            return ds.to_s + " " + monthText(ms) + " " + ys.to_s + "–" + df.to_s + " " + monthText(mf) + " " + yf.to_s
        elsif ms != mf
            return ds.to_s + " " + monthText(ms)  + "–" + df.to_s + " " + monthText(mf)
        elsif ds != df
            return ds.to_s + "–" + df.to_s + " " + monthText(mf)
        else
            return df.to_s + " " + monthText(mf)
        end
    end

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

        @games = Ki2.games(@regions[@region_key][:id], @year)

        @title = @region_name + ' ' + @year.to_s
    end

end

