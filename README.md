# [Quelendar](https://quelendar.lockcept.kr)

> ⚠️ **Notice:**  
> The Firebase Auth and Database services for this project have been discontinued. Please be aware that authentication and data storage features are no longer operational.

Quelendar is a task management application built with Flutter, designed to help users organize their quests, missions, and tasks efficiently. By distinguishing between these three concepts, it provides a structured way to manage personal and team-based projects.

## Concepts

### Quest

A **Quest** represents a long-term goal or objective and is designed to periodically generate missions. Each quest has a well-organized tag system, making it easy to search for and categorize related missions and tasks. Quests help break down larger projects and guide the creation of missions to keep users on track.

### Mission

A **Mission** is created from a quest and is tied to a specific time frame, typically a short-term goal such as a week-long objective. Missions serve as checkpoints or milestones within a quest and contain the tasks that need to be completed. They help users focus on incremental progress toward the broader quest.

### Task

A **Task** is a record of the actual work completed as part of a mission. Each task represents an individual action or piece of data that contributes to the mission's overall success. The completion and quality of tasks are used to determine whether the mission has been successful. As tasks accumulate, they provide valuable insights into the progress of the mission and, by extension, the quest.

## Requirements

To run and develop Quelendar, make sure you have the following installed on your system:

- Flutter SDK (version 3.0 or higher)
- Dart SDK
