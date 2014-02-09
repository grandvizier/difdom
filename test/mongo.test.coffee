should = require 'should'
async = require 'async'

DbInterface = require '../server/DbInterface.coffee'
db = null
testResults = null
randomString = 'TEST_' + new Date().getTime()

describe 'save and read from mongo: ', ->

  before (done) ->
    db = new DbInterface "test", done

  before (done) ->
    testResults = db.setCollection "test_results"
    done()

  after (done) ->
    db.close ->
      done()

  it 'should match collections', (done) ->
    db.getCollection (collection) ->
      collection.should.equal testResults
      done()

  it 'should save value to db', (done) ->
    db.insert rand: randomString , (error, result) ->
      throw error if error
      result[0].should.have.property('rand', randomString)
      done()

  it 'should get value from db', (done) ->
    db.find rand: randomString, (error, result) ->
      throw error if error
      result[0].should.have.property('rand', randomString)
      done()

  it 'should not allow delete all from db', (done) ->
    async.series
      removeNull: (next) ->
        db.remove null, (error, result) ->
          throw new Error 'NULL may actually have deleted everything' unless error
          should.exist error, 'no error on NULL'
          next()
      removeEmptyObj: (next) ->
        db.remove {}, (error, result) ->
          throw new Error '{} may actually have deleted everything' unless error
          should.exist error, 'no error on {}'
          next()
    , (error) -> done error

  it 'should delete from db', (done) ->
    db.remove rand: randomString, (error, result) ->
      throw error if error
      result.should.equal 1, 'too many items removed'
      done()

  it 'should increase the count when saving', (done) ->
    initialCount = null
    async.series
      firstCount: (next) ->
        db.count null, (error, count) ->
          throw error if error
          initialCount = count
          next()
      save: (next) ->
        db.insert count: randomString , (error, result) ->
          throw error if error
          result[0].should.have.property('count', randomString)
          next()
      finalCount: (next) ->
        db.count null, (error, count) ->
          throw error if error
          count.should.equal (initialCount + 1), "#{initialCount} has not increased"
          next()
    , (error) -> done error






