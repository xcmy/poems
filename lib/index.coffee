fs = require "fs"
path = require 'path'
Sequelize = require "sequelize"
sequelize = new Sequelize("postgres://:@localhost:5432/tang",{logging:false})


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

    count = await db.model('author').count()
    await init() if count is 0

  .catch (err)->
    console.log("db connected fail with err :"+err)



init = ()->
  fs.readdir path.join(__dirname,'../resource/'),(err,files)->
    for filename in files when filename.startsWith('authors')
      file = require("../resource/#{filename}")
      console.log(filename)
      if filename.startsWith('authors.tang')
        for k,index in file
          if k.name and k.desc
            await db.model('author').create({year:'唐',name:k.name,desc:k.desc})
      else if filename.startsWith('authors.song')
        for k,index in file
          if k.name and k.desc
            await db.model('author').create({year:'宋',name:k.name,desc:k.desc})

    for filename in files when filename.startsWith('poet')
      if filename.startsWith('poet.song')
        for k,index in file
          author = await db.model('author').findOne({where:{year:'宋',name:k.author}})
          if author
            await db.model('poem').create({
              author_id:author.id
              author_name:author.name
              paragraphs:k.paragraphs
              title:k.title
              strains:k.strains
            })
          else
            console.log("找不到作者==>题目"+k.title)
      else if filename.startsWith('poet.tang')
        for k,index in file
          author = await db.model('author').findOne({where:{year:'唐',name:k.author}})
          throw new Error('找不到作者') if not author
          if author
            await db.model('poem').create({
              author_id:author.id
              author_name:author.name
              paragraphs:k.paragraphs
              title:k.title
              strains:k.strains
            })
          else
            console.log("找不到作者==>题目"+k.title)


exports.db = db = sequelize
