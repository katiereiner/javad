class MapViewController < UIViewController

  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.view.backgroundColor = UIColor.whiteColor

    @mapView = mapView
    @locationField = locationField
    @locationField.delegate = self

    self.view.addSubview @mapView
    #self.view.removefromsuperview @mapView
    self.view.addSubview segmentedControl
    self.view.addSubview @locationField
    @userLocation = userLocation
    @currentlocation = @userLocation.location.coordinate
    #coordinates = CLLocationCoordinate2DMake(@coordinates.latitude, @coordinates.longitude)
    #synbioz = MKAnnotation.alloc.initWithCoordinate(coordinates, title: "Synbioz", subtitle: "2, rue Hegel, 59000, Lille, France")
    region = MKCoordinateRegion.new
	region.center = @currentlocation
	@mapView.region = region
    @placemarker = MKPointAnnotation.new
	@placemarker.coordinate = @currentlocation
    @mapView.addAnnotation @placemarker
    p @mapView
  end

  def locationManager(manager, didUpdateToLocation:newLocation, fromLocation:oldLocation)
    # if newLocation != oldLocation
    #   region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.05, 0.05))
    #   @mapView.setRegion region
    # end
  end

  def locationManager(manager, didFailWithError:error)
    puts "error location user"
  end

  private

  def mapView
    topMargin = 100
    width     = UIScreen.mainScreen.bounds.size.width
    height    = UIScreen.mainScreen.bounds.size.height - topMargin

    view = MKMapView.alloc.initWithFrame([[0, topMargin], [width, height]])
    view.mapType = ::MKMapTypeStandard
    # region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.05, 0.05))
    # view.setRegion region

    # synbioz = Annotation.alloc.initWithCoordinate(coordinates, title: "Synbioz", subtitle: "2, rue Hegel, 59000, Lille, France")
    # view.addAnnotation synbioz

    view
  end

  def segmentedControl
    segmentedControl = UISegmentedControl.alloc.initWithItems(['Standard', 'Satellite', 'Hybride'])
    segmentedControl.frame = [[20, UIScreen.mainScreen.bounds.size.height - 60], [280,40]]
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.addTarget(self,
      action:"switchMapType:",
      forControlEvents:UIControlEventValueChanged)
    segmentedControl
  end

  def switchMapType(segmentedControl)
    @mapView.mapType = case segmentedControl.selectedSegmentIndex
    when 0 then MKMapTypeStandard
    when 1 then MKMapTypeSatellite
    when 2 then MKMapTypeHybrid
    end
  end

  def locationField
    field = UITextField.alloc.initWithFrame([[10,30],[UIScreen.mainScreen.bounds.size.width-20,30]])
    field.borderStyle = UITextBorderStyleRoundedRect

    field
  end

 def getDirections(source, destination)
 	placemark_source = MKPlacemark.alloc.initWithCoordinate(source, addressDictionary: nil)
 	placemark_destination = MKPlacemark.alloc.initWithCoordinate(destination, addressDictionary: nil)
 	source_item = MKMapItem.alloc.initWithPlacemark(placemark_source)
 	placemark_item = MKMapItem.alloc.initWithPlacemark(placemark_destination)
 	request = MKDirectionsRequest.alloc.init
 	request.setSource source_item
 	request.setDestination placemark_item
 	request.setTransportType MKDirectionsTransportTypeAutomobile
 	request.requestsAlternateRoutes = false #could be NO
 	directions = MKDirections.alloc.initWithRequest request
 	directions.calculateDirectionsWithCompletionHandler(lambda { |response, error|
		@mapView.removeOverlays @mapView.overlays
		route = response.routes.first
		source_coords = MKMapPointForCoordinate.alloc.init
		source_coords.x = source.latitude
		source_coords.y = source.longitude
		dest_coords = MKMapPointForCoordinate.alloc.init
		dest_coords.x = destination.latitude
		dest_coords.y = destination.longitude
		points_array = [source_coords, dest_coords]

		route_line = MKPolyline.polylineWithPoints(points_array, count:2)
		@mapView.addOverlay(route_line)
		#@mapView.insertOverlay(route.polyline, atIndex:0, level:MKOverlayLevelAboveRoads)
 	})
 end




 def textFieldShouldReturn (textField)
    @locationField.resignFirstResponder

    geocoder = CLGeocoder.alloc.init
    geocoder.geocodeAddressString @locationField.text,
    completionHandler: lambda { |places, error|
      if places.any?
        @destination = places.first.location.coordinate
        getDirections(@currentlocation, @destination)
  #       center = CLLocationCoordinate2DMake((@currentlocation.latitude.abs + @destination.latitude.abs)/2, (@currentlocation.longitude.abs + @destination.longitude.abs)/2)
		# largest_lat = @currentlocation.latitude.abs > @destination.latitude.abs ? @currentlocation.latitude.abs : @destination.latitude.abs
		# smallest_long = @currentlocation.longitude.abs < @destination.longitude.abs ? @currentlocation.longitude.abs : @destination.longitude.abs

		# span = MKCoordinateSpanMake(largest_lat, smallest_long)

        @dest_placemarker = MKPointAnnotation.new
        @dest_placemarker.coordinate = @destination
        @dest_placemarker.title = "Destination"


        # region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.05, 0.05))
        # region = MKCoordinateRegionMake()

  		# region = MKCoordinateRegion.new
		# region.center = @destination
		# @mapView.region = region

        #@mapView.region.center = center
        #@mapView.region = region
        @mapView.addAnnotation(@dest_placemarker)


    region = MKCoordinateRegion.new
	region.center = @currentlocation
	@mapView.region = region
    placemarker = MKPointAnnotation.new
	placemarker.coordinate = @currentlocation
    @mapView.addAnnotation placemarker

      end
    }
  end

  def userLocation
    if (CLLocationManager.locationServicesEnabled)
      @location_manager = CLLocationManager.alloc.init
      @location_manager.desiredAccuracy = KCLLocationAccuracyKilometer
      @location_manager.delegate = self
      @location_manager.purpose = "Please Access Us Your Location"
      @location_manager.startUpdatingLocation
    end
  end

def mapView(mapView, viewForOverlay:overlay)

		overlayView = nil;

		@routeLineView = MKPolylineView.alloc.initWithPolyline(self.routeLine)
		@routeLineView.fillColor = self.PathColor
		@routeLineView.strokeColor = self.PathColor
		@routeLineView.lineWidth = 15
		@routeLineView.lineCap = kCGLineCapSquare
		overlayView = @routeLineView

		return overlayView

	end


end