// This are the queries made to the SQL Server database 

var dbconfig = require('./config');
const sql = require('mssql');

async function IDSearcher(ID) {
    let pool = await sql.connect(dbconfig);
    let foundTask = await pool.request()
    .input('input_id', sql.Int, parseInt(ID))
    .query("SELECT id FROM Tasks WHERE id = @input_id")
    foundID = foundTask.recordsets[0];
    return foundID[0];
}


// Get all recurring tasks
async function getAllNotCompletedTasks(res){
    try {
        let pool = await sql.connect(dbconfig);
        let tasks = await pool.request().query("SELECT * FROM Tasks WHERE recurringTask = 0 ORDER BY createdAt");
        return tasks.recordsets;

    } catch (error) {
        console.log(error);
        res.status(400).json({message: error});
    }
}

// Get all completed or not recurring tasks
async function getAllCompletedTasks(res){
    try {
        let pool = await sql.connect(dbconfig);
        let tasks = await pool.request().query("SELECT * FROM Tasks WHERE recurringTask = 1 ORDER BY createdAt");
        return tasks.recordsets;

    } catch (error) {
        console.log(error);
        res.status(400).json({message: error});
    }
}

// Add task
async function addTask(task, res) {
    try {
        let pool = await sql.connect(dbconfig);
        let newTask = await pool.request()
        // .input('id', sql.Int, task.id)
        .input('title', sql.NVarChar, task.title)
        .input('description', sql.NVarChar, task.description)
        .input('dueDate', sql.Date, task.dueDate)
        .input('priority', sql.NVarChar, task.priority)
        .input('status', sql.NVarChar, task.status)
        .input('recurringTask', sql.Bit, task.recurringTask)
        // .input('createdAt', sql.DateTime, task.createdAt)
        .query('INSERT INTO Tasks VALUES (@title, @description, @dueDate, @priority, @status, @recurringTask, GETDATE())');
        return newTask.recordsets;

    } catch (error) {
        console.log(error);
        res.status(400).json({message: error});
    }
}

// Update task
async function updateTask(taskID, recurringTask, res) {
    try {
        foundID = await IDSearcher(taskID);

        if(foundID == null || foundID == "undefined"){
            return false;
        } else {
            let pool = await sql.connect(dbconfig);
            await pool.request()
            .input('input_id', sql.Int, parseInt(taskID))
            .input('input_Rtask', sql.Bit, parseInt(recurringTask))
            .query('UPDATE Tasks SET recurringTask = @input_Rtask WHERE id = @input_id');
            return true;
        }
        
    } catch (error) {
        console.log(error);
        // res.status(400).json({message: error});
    }
}

// Delete task
async function deleteTask(taskID, res) {
    try {
        foundID = await IDSearcher(taskID);

        if(foundID == null || foundID == "undefined"){
            return false;
        } else {
            let pool = await sql.connect(dbconfig);    
            await pool.request()
            .input('input_id', sql.Int, parseInt(taskID))
            .query('DELETE FROM Tasks WHERE id = @input_id')
            return true;
        }

    } catch (error) {
        console.log(error);
        // res.status(400).json({message: error});
    }
}

module.exports = {getAllNotCompletedTasks, getAllCompletedTasks, addTask, updateTask, deleteTask}