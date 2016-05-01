module V1
  class FestivalsController < ApplicationController
    before_action :log_search, only: [:show]
    before_action :set_festival, only: [:show]
    before_action :log_result, only: [:show]
    BASE_URL = "https://www.musicfestivalwizard.com/festivals/"
  
    # GET /festivals/slug
    def show
      if @festival.instance_of?(Festival) and @festival.valid?
        render json: @festival
      else
        raise ActionController::RoutingError.new('Festival not Found')
      end
    end
  
    private
    
      def log_search
        return 'toto'
      end
      
      def set_festival
        puts "params: #{params[:festival_name]}" 
        # 1 - rewrite
        list_festival_name_rewrited = to_slug params[:festival_name]
        
        puts "after: #{list_festival_name_rewrited}" 
        
        # 2 - search
        search_festival list_festival_name_rewrited
      end
      
      def log_result 
        # todo
      end

      # Rewrite the name of the festival provided
      #
      # @param festival_name [String]
      # @return [Array] the list of rewrited names
      # * festival_name + 2016
      # * festival_name + festival + 2016
      # * festival_name
      # * the + festival_name + 2016
      # * the + festival_name + festival + 2016
      def to_slug festival_name
        list_festival_name = Array.new
        
        # strip and downcase the string
        rewrited_name = festival_name.strip.downcase
        
        # parameterize 
        
        # optionnal
        # blow away apostrophes
        rewrited_name.gsub!(/['`’]/, "")
        
        # optionnal
        # & --> and
        rewrited_name.gsub!(/\s*&\s*/, " and ")
        
        # replace all non alphanumeric, underscore or periods with dash
        rewrited_name.gsub!(/\s*[^A-Za-z0-9]\s*/, '-' ) 
        puts rewrited_name
        
        # remove word "the" if starting by it
        rewrited_name.gsub!(/^the/, '-' ) 
        
        # remove word "festival"
        rewrited_name.sub!("festival", "")
        
        # remove current year, last one and next
        current_year = Date.today.strftime("%Y")
        last_year = current_year.to_i - 1
        next_year = current_year.to_i + 1
        
        rewrited_name.sub!(current_year, "")
        rewrited_name.sub!(last_year.to_s, "")
        rewrited_name.sub!(next_year.to_s, "")
        
        # convert multiple dashes to single
        rewrited_name.gsub!(/-+/, "-")
        
        # strip off leading/trailing dash
        rewrited_name.gsub!(/\A[-\.]+|[-\.]+\z/, "")
        
        # then the possibilities names are added
        # * festival_name + 2016
        list_festival_name << rewrited_name + "-" + current_year
        
        # * festival_name + festival + 2016
        list_festival_name << rewrited_name + "-" + "festival" + "-" + current_year
        
        # * festival_name
        list_festival_name << rewrited_name
        
        # * the + festival_name + 2016
        list_festival_name << "the-" + rewrited_name
        
        # * the festival_name + festival + 2016
        list_festival_name << "the-" + rewrited_name + "-" + "festival" + "-" + current_year
        
        return list_festival_name
      end
      
      # Search festival's data
      #
      # @param list_festival_name [Array]
      # @return [Festival, nil] if found, return festival's data
      def search_festival list_festival_name
        
        # default value
        @festival = nil
        # try to find festival's data for each name
        list_festival_name.each do |festival_name|
          url = BASE_URL + festival_name + "/"
          resp = Net::HTTP.get_response(URI.parse(url))
          if resp.code.match(/20\d/)
            puts url
            page = Nokogiri::HTML(open(url))
            artists = Array.new
            
            # headliners
            headliner_liste = page.css('.placeholder2 .f_headliner .f_artist')
            # lineup
            liste = page.css('.lineupguide ul li')
            if !headliner_liste.empty?
              liste += headliner_liste
            end
            
            if liste.empty?
              return @festival = nil
            else
              liste.each do |name| 
                artist_params = ActionController::Parameters.new({ :name => name.text })
                new_artist = Artist.new(artist_params.permit(:name))
                if new_artist.valid?
                  artists <<  new_artist
                end
              end
              
              # hydrate Festival
              params = ActionController::Parameters.new({
                festival: {
                  name: page.css('header.entry-header.wrapper h1 span').text,
                  url:  url,
                  artists: artists
                }
              })
              
              festival = Festival.new(params.require(:festival).permit!)
              if festival.instance_of?(Festival) and festival.valid?
                @festival = festival
                return 
              end
            end
          end
        end

        return
      end
  end
end