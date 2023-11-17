# Rundeck log level type.
type Rundeck::Authconfig = Struct[{
    Optional['file']             => Hash[String, Data],
    Optional['ldap']             => Hash[String, Data],
    Optional['active_directory'] => Hash[String, Data],
}]
