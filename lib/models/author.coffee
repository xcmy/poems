db = require('../index').db
module.exports = (sequelize, DataTypes)->
  model = sequelize.define \
    'author',
    {
      year:
        type: DataTypes.STRING
        comment: "年代"
      name:
        type: DataTypes.STRING
        comment: "名字"
      desc:
        type: DataTypes.TEXT
        comment:"简介"
    },
    {
      timestamps: true
      paranoid: true
      underscored: true
      freezeTableName:true
      tableName:"author"
      comment:"作者"
      hooks:
        beforeCreate: (role)->
          cs = await db.model(model.tableName).count({where:{name:role.name,year:role.year}})
          throw  new Error('作者重复') if cs > 0

#      validate:
#        checkParams:()->
#          throw new Error("名称不能为空")  if not this.name

    }

#  model['getAll'] = (params)->
#    params.include = [
#    ]
#    @.findAndCountAll(params)
#
#  model['getOne'] = (params)->
#    params.include = [
#    ]
#    @.findOne(params)
#
#  model['create'] = (data)->
#    org = await @.create(data)
#    return org
#
#  model['update'] = (id, data)->
#    instance = await @.findById(id)
#    instance.update(data)
#
#  model['remove'] = (id)->
#    instance = await @.findById(id)
#    instance.destroy()

  return model


