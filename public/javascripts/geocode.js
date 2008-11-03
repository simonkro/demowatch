
var status=[];
status[G_GEO_SUCCESS]            = "Success";
status[G_GEO_MISSING_ADDRESS]    = "Missing Address";
status[G_GEO_UNKNOWN_ADDRESS]    = "Adresse nicht gefunden";
status[G_GEO_UNAVAILABLE_ADDRESS]= "Unavailable Address";
status[G_GEO_BAD_KEY]            = "Bad Key";
status[G_GEO_TOO_MANY_QUERIES]   = "Too Many Queries in 24h period";
status[G_GEO_SERVER_ERROR]       = "Server Error"

var addressInputId;

	function getLocationsCallback( result) {
		if (result.Status.code != G_GEO_SUCCESS)  {
			$('addressDialogue').innerHTML = '<h2>' + status[result.Status.code]+'</h2>';
			$('addressDialogue').style.display = 'block';	
			$('addressDialogue').className = 'errorExplanation';
			$('addressContainer').className = 'fieldWithErrors';				
			document.location.hash = 'addressAnchor';			
			return;
		}
		/* genau 1 ergebnis gefunden */
		if( result.Placemark.length == 1) {
			go( result.Placemark[0].Point.coordinates[1], result.Placemark[0].Point.coordinates[0], result.Placemark[0].address);
			return;
		}
		document.getElementById('addressDialogue').innerHTML = "<h2>Ihre Eingabe war nicht eindeutig. Bitte w&auml;hlen sie:</h2>";			
		/* Loop through the results */
		for (var i=0; i<result.Placemark.length; i++)  {
			var lat=result.Placemark[i].Point.coordinates[1];
			var lng=result.Placemark[i].Point.coordinates[0];
			var address=result.Placemark[i].address;
			if( result.Placemark[i].AddressDetails ){
				var iso=result.Placemark[i].AddressDetails.Country.CountryNameCode;
			}			
			html="<small>"+(i+1)+": </small> "+ address + ' (' + iso + ')' ;
			$( "addressDialogue").innerHTML +='<a href="javascript:go(' + lat + ',' + lng + ',' + '\'' + address + '\')">'+ html+'</a><br>';
		}
		$('addressDialogue').style.display = 'block';	
		$('addressDialogue').className = 'errorExplanation';
		$('addressContainer').className = 'fieldWithErrors';	
		document.location.hash = 'addressAnchor';		
	}

	function go( lat, lon, address) {
		$( addressInputId ).value = address;
//		$( 'lat').value = lat;
//		$( 'lon').value = lon;
		$( addressInputId ).up('form').submit();
		$( 'addressDialogue').style.display="none";
	}



	   function geocodeAddress( inputId ) {
			if (!GBrowserIsCompatible()) {
				return true; // submit w/o geocoordinates	         
			}
			var address = $( inputId ).value;
			// make it global			
			addressInputId = inputId;

			var geo = new GClientGeocoder();
			geo.setBaseCountryCode( 'DE');
//			document.getElementById("message").innerHTML = 'suche Adresse...<br />';	   
//			document.getElementById("message").style.display = 'inline';
			geo.getLocations( address, getLocationsCallback);
			return false;
		};
