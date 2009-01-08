	def avg( zahl) 
		zips = Zip.find( :all, :conditions => [ "zip LIKE ?",  zahl.to_s + '%'] )
		count = 0
		sum_lat  = 0
		sum_lon  = 0
		zips.each do |zip|
			sum_lat += zip.latitude
			sum_lon += zip.longitude
			count +=1;
		end
		
		if( count > 0) 
			lat = sum_lat / count;
			lng = sum_lon / count;
			puts "#{zahl}, #{lat}, #{lng}" 
			
			newzip = Zip.new
			newzip.latitude, newzip.longitude, newzip.zip = lat, lng, zahl
			newzip.save
			
		end
		return lat, lng
	end

###################################
###################################
###################################

	(0..9).each do |zahl|
		avg( zahl)
	end

	(0..99).each do |zahl|
		avg( sprintf( '%02d', zahl))
	end
	
	(0..999).each do |zahl|
		avg( sprintf( '%03d', zahl))
	end
	
	(0..9999).each do |zahl|
		avg( sprintf( '%04d', zahl))
	end
