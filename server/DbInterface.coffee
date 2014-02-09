# makes a connection to MongoDB and saves/reads to the database
MongoClient = require('mongodb').MongoClient
Server = require('mongodb').Server
conf = require '../config/settings.coffee'

module.exports = class DbInterface

  dbConnection = null
  db = null
  collection = null

  constructor: (dbName = conf.dbName, cb) ->
    MongoClient.connect conf.dbPath + conf.dbName, (error, connection) ->
      throw error if error
      db = connection
      cb()

  close: (cb) ->
    db.close() if db?
    console.log 'Nothing to close' unless db?
    cb()

  setCollection: (name) ->
    collection = db.collection(name)
    return collection

  getCollection: (cb) ->
    cb collection

  ################
  #  Default db/collection methods
  ################

  insert: (obj, cb) ->
    collection.insert obj, (error, result) ->
      cb error, result

  remove: (obj, cb) ->
    if not(obj?) or not(Object.keys(obj).length)
      return cb new Error 'Please specify what you would like to remove from the databse.', obj
    collection.remove obj, (error, numberRemoved) ->
      cb error, numberRemoved

  ###
    search the collection based on the criteria (use `null` to return all)
  ###
  find: (criteria, cb) ->
    collection.find(criteria).toArray cb

  count: (criteria, cb) ->
    collection.count criteria, cb


  ################
  #  difdom specific methods
  ################

  # addPage: (name, url, html, cb) ->
  #   page = setCollection('page')

