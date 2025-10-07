# @summary Rundeck mail config type.
type Rundeck::Mail_config = Struct[{
  Optional['host']         => String,
  Optional['port']         => Integer,
  Optional['username']     => String,
  Optional['password']     => Variant[String[8], Sensitive[String[8]]],
  Optional['props']        => Array[Hash],
  Optional['default.from'] => String,
  Optional['default.to']   => String,
  Optional['disabled']     => Boolean,
}]
