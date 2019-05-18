import UIKit
import SlowContainer
import SlowMVVM

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	private let container = Container(log: ConsoleLog())
	public var window: UIWindow? = UIWindow()

	override init() {
		super.init()

		self.container.register(IUserSettings.self)
			.withInit(UserSettings.init)
		
		self.container.register(IFreezersHttpClient.self)
			.withInit(FreezersHttpClient.init)
			.singleInstance()

		self.container.register(IFreezersService.self)
			.withFactory { FreezersService(httpClient: $0.resolve(IFreezersHttpClient.self)!) }
			.singleInstance()

		self.container.register(INotificationService.self)
			.withInit(NotificationService.init)
			.singleInstance()

		self.container.register(FreezersListVM.self)
			.withInit(FreezersListVM.init)

		self.container.register(FreezerCarouselVM.self)
			.withInit(FreezerCarouselVM.init)

		self.container.register(HomeVM.self)
			.withInit(HomeVM.init)

		self.container.register(HomeVC.self)
			.withFactory { HomeVC(notificationService: $0.resolve(INotificationService.self)!) }
			.onDidCreate { (c, vc) in
				vc.viewModel = c.resolve(HomeVM.self)
		}
	}

	public func application(
		_ application: UIApplication,
		willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		let root = self.container.resolve(HomeVC.self)
		self.window?.rootViewController = root
		self.window?.makeKeyAndVisible()
		return true
	}

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Override point for customization after application launch.
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

