# @summary Rundeck key storage config type.
type Rundeck::Key_storage_config = Array[
  Struct[{
    'type'                       => String,
    'path'                       => String,
    Optional['removePathPrefix'] => Boolean,
    Optional['config']           => Hash,
  }]
]
