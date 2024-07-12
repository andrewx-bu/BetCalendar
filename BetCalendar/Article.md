# BetCalendar

Allows Users to "bet" on completing their daily tasks.

## Overview

My first Swift project! Right now, acts as a simple task manager. This is a Heavy WIP

### Future Plans

General/Global Expansions:
- Bottom bar for navigating between Main Views
    - 3 Main Views
        - TaskManager (Handle tasks, see task completion history, add new tasks, etc.)
        - Home Screen (Place and wager bets (half-sheet), refer to Fanduel app)
        - Account Screen (Profile, bet history, active bets, etc.)

Expansions on Task Control:
- Add a TaskListingView
    - Allow TaskManager to pass in sorting and filtering options using #Predicate and @Query.
    - Allow users to search up tasks.
- Add a TaskDetailView and a AddTaskView
    - NavLink will enter TaskDetailView, which will have an edit button entering EditTaskView.
    - AddTaskView will draw from EditTaskView 
- Add a CompletedTasksView
    - Shows last 50 completed tasks
- Add a CalendarView
    - Allows users to select tasks with deadline on date selected.
    - Presented as a sheet/half-sheet (refer to Action app)
- TaskManagerView UI cleanup
    - Allow users to move tasks from TaskManager to CompletedTasks directly from List.
    - Add colors indicating task priority and general task completion (Red, Orange, Yellow, Green, Gray).

Adding Bet Functionality:
- Modify Task model to have an array of bets (e.g. complete this task 0.5 times OVER/UNDER, > 1.5 repetitions completed, etc.)
