db = require('../index').db
module.exports = (sequelize, DataTypes)->
  model = sequelize.define \
    'poem',
    {
      title:
        type: DataTypes.STRING
        comment: "名字"
      author_id:
        type: DataTypes.INTEGER
        comment: "作者"
      author_name:
        type: DataTypes.STRING
        comment: "名字"
      strains:
        type: DataTypes.ARRAY(DataTypes.STRING)
        comment: "平仄"
      paragraphs:
        type: DataTypes.ARRAY(DataTypes.STRING)
        comment:"诗词"
    },
    {
      timestamps: true
      paranoid: true
      underscored: true
      freezeTableName:true
      tableName:"poem"
      comment:"诗词"

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


