const router = require('express').Router();
const Query = require('./queries');


// Get all recurring tasks
router.route('/tasks/recurring').get(async (req, res) => {

        await Query.getAllNotCompletedTasks(res).then((data)=>{
            return res.status(200).send(data[0]);
        })
})

// Get all recurring tasks
router.route('/tasks/completed').get(async (req, res) => {

        await Query.getAllCompletedTasks(res).then((data)=>{
            return res.status(200).send(data[0]);
        })
})

// Post a new task
router.route('/tasks').post(async (req, res) => {

        let task = {...req.body}
        await Query.addTask(task, res).then(data =>{
            return res.status(201).json(data);
        });
        
});


// Modify or update a task
router.route('/tasks/:id/:done').put(async (req ,res) => {

        await Query.updateTask(req.params.id, req.params.done, res).then((isupdated)=>{
        if(isupdated == true){
            return res.status(200).json({message: "Task updated successfully!", Updated: isupdated});
        } else{
            return res.status(404).json({message: "Task not found or not updated"});
        }
        });
});


// Delete a task
router.route('/tasks/:id').delete(async (req, res) => {

       await Query.deleteTask(req.params.id, res).then((isdeleted) => {
        if(isdeleted == true){
            return res.status(200).json({message: "Task deleted successfully!", Deleted: isdeleted});
        } else{
            return res.status(404).json({message: "Task not found"});
        }
       });
});

module.exports = router;

