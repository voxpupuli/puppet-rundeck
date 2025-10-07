# @summary Rundeck scm type.
type Rundeck::Scm = Variant[
  Struct[{
    'import' => Struct[{
      'type'   => String[1],
      'config' => Hash[String[1], String],
    }],
    Optional['export'] => Struct[{
      'type'   => String[1],
      'config' => Hash[String[1], String],
    }],
  }],
  Struct[{
    'export' => Struct[{
      'type'   => String[1],
      'config' => Hash[String[1], String],
    }],
    Optional['import'] => Struct[{
      'type'   => String[1],
      'config' => Hash[String[1], String],
    }],
  }],
]
