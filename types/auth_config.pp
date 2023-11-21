# Rundeck authentication config type.
type Rundeck::Auth_config = Struct[{
    Optional['file'] => Hash[String, Data],
    Optional['ldap'] => Hash[String, Data],
    Optional['pam']  => Hash[String, Data],
}]
