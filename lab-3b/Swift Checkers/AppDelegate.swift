//
//  AppDelegate.swift
//  Swift Checkers
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Надсилається, коли програма збирається перейти з активного стану в неактивний. Це може статися для певних типів тимчасових перерв  або коли користувач виходить із програми, і вона починає перехід у фоновий стан.
                 // Використовується цей метод, щоб призупинити поточні завдання, вимкнути таймери та зробити зворотні виклики відтворення графіки недійсними.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Використовуєтся цей метод, щоб звільнити спільні ресурси, зберегти дані користувача, зробити таймери недійсними та зберегти достатньо інформації про стан програми, щоб відновити  програму до її поточного стану на випадок її завершення пізніше.
                 
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Викликається як частина переходу з фонового стану в активний; тут ви можете скасувати багато змін, зроблених під час входу у фоновий режим.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Перезапускає усі завдання, які були призупинені (або ще не запущені), коли програма була неактивною.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Викликається, коли програма збирається завершити роботу.
    }


}

