// Get an instance of mysql we can use in the app
let mysql = require('mysql2')

// Create a 'connection pool' using the provided credentials
const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit   : 10,
    host              : 'classmysql.engr.oregonstate.edu',
    user              : 'cs340_guhaa',        // Replace with your actual ONID
    password          : '7040',        // Replace with your DB password (last 4 digits of OSU ID)
    database          : 'cs340_guhaa'          // Replace with your actual ONID
}).promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool;
