# @summary Rundeck project type.
type Rundeck::Project = Struct[{
    Optional['ensure']        => Enum['absent', 'present'],
    Optional['config']        => Hash[String, String],
    Optional['update_method'] => Enum['set', 'update'],
    Optional['jobs']          => Hash[String, Rundeck::Job],
}]
