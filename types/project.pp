# Rundeck project config type.
type Rundeck::Project = Struct[{
    Optional['config']        => Hash[String, String],
    Optional['update_method'] => String,
}]
