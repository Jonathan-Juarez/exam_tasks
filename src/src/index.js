
const sql = require('mssql')
const express = require('express')
const app = express();
const router = require('./routes')

// http://localhost:3010/api/tasks/


app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/api", router)

// Start the server on port 3000
app.listen(3010, () => {
    console.log('Connected to SQL Server!')
    console.log("API listening in http://localhost:3010");
});
