# Rundeck authentication config type.
type Rundeck::Authconfig = Struct[{
    Optional['active_directory'] => Hash[String, Data],
    Optional['file']             => Hash[String, Data],
    Optional['ldap']             => Hash[String, Data],
    Optional['pam']              => Hash[String, Data],
}]
