/*
    SETUP
*/
const express = require('express');
const path = require('path');
const exphbs = require('express-handlebars');

// Database connection
const db = require('./db-connector');

const app = express();
const PORT = 50013; // Choose a port between 1024-65535


app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

const hbs = exphbs.create({
  extname: '.hbs',
  helpers: {
    eq: (a, b) => a === b
  }
});
app.engine('hbs', hbs.engine);
app.set('view engine', 'hbs');
app.set('views', path.join(__dirname, 'views'));



/*
    ROUTES
*/

// Home page
app.get('/', (req, res) => {
  res.render('index');
});

// Test database connection
app.get('/test-db', async (req, res) => {
  try {
    console.log('Testing database connection...');
    const query = 'SELECT 1 as test';
    const [result] = await db.query(query);
    console.log('Database connection successful:', result);
    res.send(`Database connection successful! Test result: ${JSON.stringify(result)}`);
  } catch (error) {
    console.error("Database connection error:", error);
    res.status(500).send(`Database connection failed: ${error.message}`);
  }
});

// RESET Database route
app.get('/reset-database', async (req, res) => {
  try {
    console.log('Attempting to reset database...');
    const resetQuery = 'CALL ResetRailwayDatabase();';
    await db.query(resetQuery);
    console.log('Database reset successful');
    res.redirect('/?message=Database reset successfully');
  } catch (error) {
    console.error("Error executing database reset:", error);
    res.status(500).send(`An error occurred while resetting the database: ${error.message}`);
  }
});

// Trains page
app.get('/trains', async (req, res) => {
  try {
    const query = 'SELECT train_id, train_name, engine_type FROM Trains ORDER BY train_id;';
    const [trains] = await db.query(query);
    res.render('trains', { trains: trains });
  } catch (error) {
    console.error("Error fetching trains:", error);
    res.status(500).send("An error occurred while fetching trains data.");
  }
});

// Shipments page
app.get('/shipments', async (req, res) => {
  try {
    const query = `
      SELECT 
        s.shipment_id, 
        s.description, 
        s.weight_tons,
        s.origin_railyard_id,
        s.destination_railyard_id,
        CONCAT('Yard ', s.origin_railyard_id) as origin_yard,
        CONCAT('Yard ', s.destination_railyard_id) as destination_yard
      FROM Shipments s
      ORDER BY s.shipment_id;
    `;
    const [shipments] = await db.query(query);
    res.render('shipments', { shipments: shipments });
  } catch (error) {
    console.error("Error fetching shipments:", error);
    res.status(500).send("An error occurred while fetching shipments data.");
  }
});

// Containers page
app.get('/containers', async (req, res) => {
  try {
    const query = `
      SELECT 
        c.container_id,
        c.capacity_tons,
        c.current_rail_id,
        c.shipment_id,
        CONCAT('Yard ', c.current_rail_id) as current_location,
        s.description as shipment_description
      FROM Containers c
      LEFT JOIN Shipments s ON c.shipment_id = s.shipment_id
      ORDER BY c.container_id;
    `;
    const [containers] = await db.query(query);
    res.render('containers', { containers: containers });
  } catch (error) {
    console.error("Error fetching containers:", error);
    res.status(500).send("An error occurred while fetching containers data.");
  }
});

// Railyards page
app.get('/railyards', async (req, res) => {
  try {
    const query = 'SELECT railyard_id, train_capacity FROM RailYards ORDER BY railyard_id;';
    const [railyards] = await db.query(query);
    res.render('railyards', { railyards: railyards });
  } catch (error) {
    console.error("Error fetching railyards:", error);
    res.status(500).send("An error occurred while fetching railyards data.");
  }
});


// --- Helper Functions ---
function handleDbAction(action, errorMsg) {
  return async (req, res) => {
    try {
      await action(req, res);
    } catch (error) {
      console.error(errorMsg, error);
      res.status(500).send(errorMsg);
    }
  };
}

// Trains
app.post('/trains/add', handleDbAction(async (req, res) => {
  const { train_name, engine_type } = req.body;
  await db.query('INSERT INTO Trains (train_name, engine_type) VALUES (?, ?)', [train_name, engine_type]);
  res.redirect('/trains');
}, "Error adding train:"));

app.post('/trains/edit/:id', handleDbAction(async (req, res) => {
  const { train_name, engine_type } = req.body;
  const train_id = req.params.id;
  await db.query('UPDATE Trains SET train_name = ?, engine_type = ? WHERE train_id = ?', [train_name, engine_type, train_id]);
  res.redirect('/trains');
}, "Error updating train:"));

app.post('/trains/delete/:id', handleDbAction(async (req, res) => {
  const train_id = req.params.id;
  await db.query('DELETE FROM container_train WHERE train_id = ?', [train_id]);
  await db.query('DELETE FROM Trains WHERE train_id = ?', [train_id]);
  res.redirect('/trains');
}, "Error deleting train:"));

// Shipments
app.post('/shipments/add', handleDbAction(async (req, res) => {
  const { description, weight_tons, origin_railyard_id, destination_railyard_id } = req.body;
  await db.query('INSERT INTO Shipments (description, weight_tons, origin_railyard_id, destination_railyard_id) VALUES (?, ?, ?, ?)', [description, weight_tons, origin_railyard_id, destination_railyard_id]);
  res.redirect('/shipments');
}, "Error adding shipment:"));

app.post('/shipments/edit/:id', handleDbAction(async (req, res) => {
  const { description, weight_tons, origin_railyard_id, destination_railyard_id } = req.body;
  const shipment_id = req.params.id;
  await db.query('UPDATE Shipments SET description = ?, weight_tons = ?, origin_railyard_id = ?, destination_railyard_id = ? WHERE shipment_id = ?', [description, weight_tons, origin_railyard_id, destination_railyard_id, shipment_id]);
  res.redirect('/shipments');
}, "Error updating shipment:"));

app.post('/shipments/delete/:id', handleDbAction(async (req, res) => {
  const shipment_id = req.params.id;
  await db.query('DELETE FROM container_train WHERE container_id IN (SELECT container_id FROM Containers WHERE shipment_id = ?)', [shipment_id]);
  await db.query('DELETE FROM Containers WHERE shipment_id = ?', [shipment_id]);
  await db.query('DELETE FROM Shipments WHERE shipment_id = ?', [shipment_id]);
  res.redirect('/shipments');
}, "Error deleting shipment:"));

// Containers
app.post('/containers/add', handleDbAction(async (req, res) => {
  const { capacity_tons, current_rail_id, shipment_id } = req.body;
  await db.query('INSERT INTO Containers (capacity_tons, current_rail_id, shipment_id) VALUES (?, ?, ?)', [capacity_tons, current_rail_id, shipment_id]);
  res.redirect('/containers');
}, "Error adding container:"));

app.post('/containers/edit/:id', handleDbAction(async (req, res) => {
  const { capacity_tons, current_rail_id, shipment_id } = req.body;
  const container_id = req.params.id;
  await db.query('UPDATE Containers SET capacity_tons = ?, current_rail_id = ?, shipment_id = ? WHERE container_id = ?', [capacity_tons, current_rail_id, shipment_id, container_id]);
  res.redirect('/containers');
}, "Error updating container:"));

app.post('/containers/delete/:id', handleDbAction(async (req, res) => {
  const container_id = req.params.id;
  await db.query('DELETE FROM container_train WHERE container_id = ?', [container_id]);
  await db.query('DELETE FROM Containers WHERE container_id = ?', [container_id]);
  res.redirect('/containers');
}, "Error deleting container:"));

// Railyards
app.post('/railyards/add', handleDbAction(async (req, res) => {
  const { train_capacity } = req.body;
  await db.query('INSERT INTO RailYards (train_capacity) VALUES (?)', [train_capacity]);
  res.redirect('/railyards');
}, "Error adding railyard:"));

app.post('/railyards/edit/:id', handleDbAction(async (req, res) => {
  const { train_capacity } = req.body;
  const railyard_id = req.params.id;
  await db.query('UPDATE RailYards SET train_capacity = ? WHERE railyard_id = ?', [train_capacity, railyard_id]);
  res.redirect('/railyards');
}, "Error updating railyard:"));

app.post('/railyards/delete/:id', handleDbAction(async (req, res) => {
  const railyard_id = req.params.id;
  await db.query('DELETE FROM RailYards WHERE railyard_id = ?', [railyard_id]);
  res.redirect('/railyards');
}, "An error occurred while deleting the railyard. Make sure no shipments or containers reference this railyard."));

/*
    LISTENER
*/
app.listen(PORT, () => {

  console.log(`Server running on http://localhost:${PORT}`);
  console.log(`Access from ENGR server: http://classwork.engr.oregonstate.edu:${PORT}`);

});
