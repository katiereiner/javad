class MapViewWithRoute < MKMapView
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