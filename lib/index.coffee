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
    if count is 0
      await initAuthor()
#      await initPoems()
.catch (err)->
    console.log("db connected fail with err :"+err)



initAuthor = ()->
  fs.readdir path.join(__dirname,'../resource/'),(err,files)->
    for filename in files when filename.startsWith('authors')
      file = require("../resource/#{filename}")
      console.log(filename)
      for k,index in file
        if k.name and k.desc
          await db.model('author').create({
            year:if filename.startsWith('authors.song') then '宋' else '唐',
            name:k.name,
            desc:k.desc
          })

initPoems = ()->
  fs.readdir path.join(__dirname,'../resource/'),(err,files)->
    for filename in files when filename.startsWith('poet')
      file = require("../resource/#{filename}")
      for k,index in file
        author = await db.model('author').findOne({
          where:{
            year:if filename.startsWith('poet.song') then '宋' else '唐',
            name:k.author}
        })
        console.log('找不到作者') if not author
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




exports.db = db = sequelize
