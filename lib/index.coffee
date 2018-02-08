fs = require "fs"
path = require 'path'
Sequelize = require "sequelize"

sequelize = new Sequelize(Config.db,{logging:false})


loadModels = ->
  new Promise (resolve)->
    Author = await sequelize.import './models/author'
    Poem = await sequelize.import './models/poem'

    Poem.belongsTo Author, {foreignKey: 'author_id', as: 'author',constraints:false}

    resolve()


sequelize.authenticate()
  .then ()->
    await loadModels()
    console.log("db Connected success")

    await sequelize.sync({force:true})

#    for k in [0..100]
#      await db.model('author').create({year:"2",name:"#{k}"})
#    for k in [101..200]
#      await db.model('author').create({year:"2",name:"#{k}"})

    count = await db.model('author').count()
    if count is 0
      await initAuthor()
      console.log("hello 1")
      await initPoems()
.catch (err)->
    console.log("db connected fail with err :"+err)



initAuthor = ()->
  return new Promise (resolve)->
    await fs.readdir path.join(__dirname,'../resource/author'),(err,files)->
      for filename in files
        file = require("../resource/author/#{filename}")
        console.log(filename)
        for k,index in file
          if k.name and k.desc
            await db.model('author').create({
              year:if filename.startsWith('authors.song') then '宋' else '唐',
              name:k.name,
              desc:k.desc
            })
      resolve('00')


initPoems = ()->
  return new Promise (resolve)->
    count = 0
    fs.readdir path.join(__dirname,'../resource/poems'),(err,files)->
      for filename in files when filename.startsWith('poet')
        file = require("../resource/poems/#{filename}")
        console.log(filename)
        for k,index in file
          author = await db.model('author').findOne({
            where:{
              year:if filename.startsWith('poet.song') then '宋' else '唐',
              name:k.author}
          })
          count++ if not author
          params = {
            author_name:k.author or undefined
            paragraphs:k.paragraphs
            title:k.title
            strains:k.strains
          }
          if author
            params.author_id = author.id
            params.author_name = author.name
          await db.model('poem').create(params)
      resolve('')
      console.log("total==>"+count)




exports.db = db = sequelize
