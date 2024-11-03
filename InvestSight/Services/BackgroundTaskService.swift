import BackgroundTasks
import Foundation

actor BackgroundTaskService {
    private let portfolioViewModel: PortfolioViewModel
    private let identifier = "com.investsight.portfoliorefresh"
    
    init(portfolioViewModel: PortfolioViewModel) {
        self.portfolioViewModel = portfolioViewModel
    }
    
    func handleBackgroundRefresh(task: BGAppRefreshTask) async {
        // Schedule the next background task
        scheduleNextRefresh()
        
        // Set up a task cancellation handler
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        // Perform the refresh
        await portfolioViewModel.refresh(includeCache: false)
        
        task.setTaskCompleted(success: true)
    }
    
    func scheduleNextRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: identifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }
}
