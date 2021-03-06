<map-cmp>
    <input id="pac-input" class="controls" type="text" placeholder="Search Box">
    <div id="map"></div>
    <script>
        var self = this;
        self.getSharedObservable().on('data-updated', function (params) {
            self.drawNewMarkers()
        });
        self.on('route', function (params) {
            self.data = {}
            self.data.lat_lng = self.route.query()
            if (Object.keys(self.data).length) {
                self.data.lat_lng = {
                    lat: 37.61496,
                    lng: -122.39005380000003
                }
                self.setDataGlobal('businesses', [])
            }
            self.drawNewMarkers();
        })

        self.on('mount', function (params) {
            $.getScript(
                "https://maps.googleapis.com/maps/api/js?key=AIzaSyDAQOhuvUriLPgDzVblnSSH7BUj-s2EMSw&libraries=places",
                function (data, textStatus, jqxhr) {
                    // this is your callback.
                    self.initAutocomplete()

                });

        })


        // This example adds a search box to a map, using the Google Place Autocomplete
        // feature. People can enter geographical searches. The search box will return a
        // pick list containing a mix of places and predicted search terms.

        // This example requires the Places library. Include the libraries=places
        // parameter when you first load the API. For example:
        // <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">

        self.initAutocomplete = function () {
            var map = new google.maps.Map(document.getElementById('map'), {
                center: {
                    lat: Number(self.data.lat_lng.lat),
                    lng: Number(self.data.lat_lng.lng)
                },
                zoom: 13,
                mapTypeId: 'roadmap'
            });
            self.map = map;
            // Create the search box and link it to the UI element.
            var input = document.getElementById('pac-input');
            var searchBox = new google.maps.places.SearchBox(input);
            map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

            // Bias the SearchBox results towards current map's viewport.
            map.addListener('bounds_changed', function () {
                searchBox.setBounds(map.getBounds());
            });

            var markers = [];
            // Listen for the event fired when the user selects a prediction and retrieve
            // more details for that place.
            searchBox.addListener('places_changed', function () {
                var places = searchBox.getPlaces();
                if (places.length == 0) {
                    return;
                } else {
                    let map_location = places[0];
                    let lat = map_location.geometry.location.lat()
                    let lng = map_location.geometry.location.lng()
                    let formatted_address = map_location.formatted_address

                    self.route("/search?lat=" + lat + "&lng=" + lng + "&formatted_address=" +
                        formatted_address)

                }

                // Clear out the old markers.
                markers.forEach(function (marker) {
                    marker.setMap(null);
                });
                markers = [];

                // For each place, get the icon, name and location.
                var bounds = new google.maps.LatLngBounds();
                places.forEach(function (place) {
                    if (!place.geometry) {
                        console.log("Returned place contains no geometry");
                        return;
                    }
                    var icon = {
                        url: place.icon,
                        size: new google.maps.Size(71, 71),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(17, 34),
                        scaledSize: new google.maps.Size(25, 25)
                    };

                    // Create a marker for each place.
                    markers.push(new google.maps.Marker({
                        map: map,
                        icon: icon,
                        title: place.name,
                        position: place.geometry.location
                    }));

                    if (place.geometry.viewport) {
                        // Only geocodes have viewport.
                        bounds.union(place.geometry.viewport);
                    } else {
                        bounds.extend(place.geometry.location);
                    }
                });
                map.fitBounds(bounds);
            });

            self.drawNewMarkers();
            self.map.addListener('click', function (e) {
                self.placeMarkerAndPanTo(e.latLng, map);
            });

        }
        self.placeMarkerAndPanTo = function (lat_lng, map) {
            var lat = lat_lng.lat()
            var lng = lat_lng.lng()
            var formatted_address = null
            self.route("/search?lat=" + lat + "&lng=" + lng + "&formatted_address=" + formatted_address)

        }
        self.drawNewMarkers = function () {
            if ((typeof google == 'undefined') || !self.isMounted) {
                return
            }
            setTimeout(() => {
                self.getDataGlobal('businesses').forEach(element => {
                    var coordinates = element['coordinates']
                    var uluru = {
                        lat: coordinates['latitude'],
                        lng: coordinates['longitude']
                    };

                    new google.maps.Marker({
                        position: uluru,
                        map: self.map
                    });
                });
                self.setDataGlobal('businesses', [])

            }, 100);


        }
    </script>
    <style>
        /* Always set the map height explicitly to define the size of the div
               * element that contains the map. */
        #map {
            height: 100%;
        }

        /* Optional: Makes the sample page fill the window. */
        html,
        body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        #description {
            font-family: Roboto;
            font-size: 15px;
            font-weight: 300;
        }

        #infowindow-content .title {
            font-weight: bold;
        }

        #infowindow-content {
            display: none;
        }

        #map #infowindow-content {
            display: inline;
        }

        .pac-card {
            margin: 10px 10px 0 0;
            border-radius: 2px 0 0 2px;
            box-sizing: border-box;
            -moz-box-sizing: border-box;
            outline: none;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
            background-color: #fff;
            font-family: Roboto;
        }

        #pac-container {
            padding-bottom: 12px;
            margin-right: 12px;
        }

        .pac-controls {
            display: inline-block;
            padding: 5px 11px;
        }

        .pac-controls label {
            font-family: Roboto;
            font-size: 13px;
            font-weight: 300;
        }

        #pac-input {
            background-color: #fff;
            font-family: Roboto;
            font-size: 15px;
            font-weight: 300;
            margin-left: 12px;
            padding: 0 11px 0 13px;
            text-overflow: ellipsis;
            width: 400px;
        }

        #pac-input:focus {
            border-color: #4d90fe;
        }

        #title {
            color: #fff;
            background-color: #4d90fe;
            font-size: 25px;
            font-weight: 500;
            padding: 6px 12px;
        }

        #target {
            width: 345px;
        }
    </style>

</map-cmp>