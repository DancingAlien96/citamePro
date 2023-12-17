const express = require('express');
//Importación de funciones
const { getUser, postUser,  getAllUser } = require('./users.controller.js');
//Crear enrutador
const usersRouter = express.Router();
//Asignación de direcciones
usersRouter.get('/api/user/get',getUser);
usersRouter.post('/api/user/create',postUser);
usersRouter.get('/api/user/get/all',getAllUser);
//Exportar enrutador
module.exports = usersRouter;