const express = require('express');
const path = require('path');
const exphbs = require('express-handlebars');

const app = express();
const PORT = 50012;

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));


// Handlebars' definitions

const hbs = exphbs.create({
  extname: '.hbs',
  helpers: {
    eq: (a, b) => a === b
  }
});
app.engine('hbs', hbs.engine);
app.set('view engine', 'hbs');
app.set('views', path.join(__dirname, 'views'));



// In-memory data for all entities
const data = {
  trains: [
    { trainID: 501, trainName: 'Thunderbolt', engineType: 'diesel', manufacturer: 'GE' }
  ],
  shipments: [
    { shipmentID: 1, description: 'Lumber', weightTons: 20.5, originYardID: 'Yard 1', destinationYardID: 'Yard 2' }
  ],
  containers: [
    { containerID: 101, capacityTons: 25.0, currentRailID: 'Yard 1', shipmentID: 1 }
  ],
  railyards: [
    { yardID: 1, trainCapacity: 5 }
  ]
};

// CRUD route generator
function setupCrudRoutes(entity, idField, fields) {
  // List page
  app.get(`/${entity}`, (req, res) => {
    res.render(entity, { [entity]: data[entity] });
  });
  // Add
  app.post(`/${entity}/add`, (req, res) => {
    const newObj = {};
    fields.forEach(f => {
      if (f.type === 'number') {
        newObj[f.name] = f.float ? parseFloat(req.body[f.name]) : parseInt(req.body[f.name]);
      } else {
        newObj[f.name] = req.body[f.name];
      }
    });
    newObj[idField] = data[entity].length > 0 ? Math.max(...data[entity].map(e => e[idField])) + 1 : 1;
    data[entity].push(newObj);
    res.redirect(`/${entity}`);
  });
  // Delete
  app.post(`/${entity}/delete/:id`, (req, res) => {
    const id = parseInt(req.params.id);
    data[entity] = data[entity].filter(e => e[idField] !== id);
    res.redirect(`/${entity}`);
  });
  // Edit
  app.post(`/${entity}/edit/:id`, (req, res) => {
    const id = parseInt(req.params.id);
    const obj = data[entity].find(e => e[idField] === id);
    if (obj) {
      fields.forEach(f => {
        if (f.type === 'number') {
          obj[f.name] = f.float ? parseFloat(req.body[f.name]) : parseInt(req.body[f.name]);
        } else {
          obj[f.name] = req.body[f.name];
        }
      });
    }
    res.redirect(`/${entity}`);
  });
}


// Routes
app.get('/', (req, res) => {
  res.render('index');
});

setupCrudRoutes('shipments', 'shipmentID', [
  { name: 'description', type: 'string' },
  { name: 'weightTons', type: 'number', float: true },
  { name: 'originYardID', type: 'string' },
  { name: 'destinationYardID', type: 'string' }
]);

setupCrudRoutes('containers', 'containerID', [
  { name: 'capacityTons', type: 'number', float: true },
  { name: 'currentRailID', type: 'string' },
  { name: 'shipmentID', type: 'number' }
]);

setupCrudRoutes('railyards', 'yardID', [
  { name: 'trainCapacity', type: 'number' }
]);

setupCrudRoutes('trains', 'trainID', [
  { name: 'trainName', type: 'string' },
  { name: 'engineType', type: 'string' },
  { name: 'manufacturer', type: 'string' }
]);

app.listen(PORT, () => {
  console.log(`Server running on http://classwork.engr.oregonstate.edu:${PORT}`);
});
