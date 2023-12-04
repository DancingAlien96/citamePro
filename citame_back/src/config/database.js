const mongoose = require('mongoose');

async function connect() {

    await mongoose.connect('mongodb://0.0.0.0:27017/citamedb');

    console.log('DB is Connected.')

};

module.exports = { connect };

