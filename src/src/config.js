// const dbconfig = {
//     user: 'sa',
//     password: '123456789',
//     server: 'localhost',
//     database: 'Taskexpress',
//     options: {
//         trustedconnection:  true,
//         enableArithAbort:  true,
//         // instancename:  'SQLEXPRESS'  // SQL Server instance name
//     },
//     // port:  1433
// }
const dbconfig = {
    "user": "sa", // Database username
    "password": "123456789", // Database password
    "server": "localhost", // Server IP address
    "database": "Taskexpress", // Database name
    "options": {
        "encrypt": false // Disable encryption
    }
}
module.exports = dbconfig;

