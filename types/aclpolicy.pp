type Rundeck::Aclpolicy = Variant[
  Struct[{
    description => String,
    context     => Struct[{application => String}],
    for         => Struct[{
      project  => Optional[Array[Hash, 1]],
      resource => Optional[Array[Hash, 1]],
      storage  => Optional[Array[Hash, 1]],
    }],
    by          => Array[Struct[{
      username => Variant[String, Array],
      group    => Variant[String, Array],
    }], 1],
  }],
  Struct[{
    description => String,
    context     => Struct[{project => String}],
    for         => Struct[{
      adhoc    => Optional[Array[Any, 1]],
      job      => Optional[Array[Hash, 1]],
      node     => Optional[Array[Hash, 1]],
      project  => Optional[Array[Hash, 1]],
      resource => Optional[Array[Hash, 1]],
    }],
    by          => Array[Struct[{
      username => Variant[String, Array],
      group    => Variant[String, Array],
    }], 1],
  }],
]
