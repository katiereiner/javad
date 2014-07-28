class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    # storyboard = UIStoryboard.storyboardWithName("main", bundle: nil)
    # @window.rootViewController = storyboard.instantiateInitialViewController
    views_controller = MapViewController.alloc.init 
    @window.rootViewController = views_controller
    true
  end
end
