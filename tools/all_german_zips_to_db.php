<?php
#
# 60308 wird nicht gefunden (-->haendisch eintragen)
# 09636 =>  49777218,12244665
# 82475 	Schneefernerhaus 	47.4948 	11.0924
# 83489


mysql_connect( 'localhost', 'root', '11111');
mysql_select_db( 'demowatch');
mysql_query("SET NAMES 'utf8'");mysql_query("SET CHARACTER SET 'utf8'");		

	// ALLE PLZ in db
	if( 0) {
		//  Ort;Zusatz;Plz;Vorwahl;Bundesland
		$url = 'http://www.access-paradies.de/download/pool/plz_deutschland.txt';
		$data = file( $url);
#		var_dump( $data);
		foreach( $data as $l) {
			$a = explode( ';', $l);
			if( $plz = (int)@$a[2]) {
#				$name = utf8_encode( trim( @$a[0].', '.@$a[4]));
				$name = utf8_encode( trim( @$a[0]));
				$aZIP[$plz][] = $name;
			}
		}
		
		foreach( $aZIP as &$aNames){
			$aNames = implode( ', ', $aNames);
#			echo strlen( $aNames)."\n";
			if( strlen( $aNames) > 255) {
				$aNames  = substr( $aNames, 0, 252).'...';
				echo "$aNames\n";
			}
		}
		foreach( $aZIP as $plz=>$name) {
			$query = sprintf( "INSERT INTO `zips` (`zip`, `name`) VALUES('%05d', '%s')", 
				$plz, mysql_real_escape_string( $name));
#			echo "$query;\n";
			mysql_query( $query);
			echo mysql_error();
		}
		
		exit();
	}
	
	$res = mysql_query( 'SELECT * FROM zips WHERE latitude IS NULL');
	echo mysql_error();
	while( $l = mysql_fetch_assoc( $res)) {
		$key = '12x3';
		$url = sprintf( 'http://maps.google.com/maps/geo?q=%05d&output=xml&key=%s&oe=utf-8&gl=de&hl=de', $l['zip']. " Deutschland", $key);
		$xml = simplexml_load_file($url) or die("$url not loaded");
		$status = $xml->Response->Status->code;
		if( strcmp( $status,  "200") != 0) {
			die( "$l[zip] - status code: $status");
		}
		
		// Successful geocode
		$coordinates = $xml->Response->Placemark->Point->coordinates;
		$coordinatesSplit = split(",", $coordinates);
		// Format: Longitude, Latitude, Altitude
		$lat = $coordinatesSplit[1];
		$lng = $coordinatesSplit[0];
		
#			echo "$lat, $lng\n";
		
		$query = sprintf( "UPDATE `zips` SET  `latitude`='%f', `longitude`='%f' WHERE id=%d", 
			$lat, $lng, $l['id'] );
		echo "$query;\n";
		mysql_query( $query);
		echo mysql_error();
		sleep( 1);
	}
	
?>