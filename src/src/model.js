// Main task body
class Task {
    constructor(id, title, description, dueDate, priority, status, recurringTask, createdAt){
        this.id = id;
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.priority = priority;
        this.status = status;
        this.recurringTask = recurringTask;
        this.createdAt = createdAt;
    }
}
module.exports = Task;