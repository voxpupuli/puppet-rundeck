# Rundeck authentication config type.
type Rundeck::Auth_config = Struct[{
    Optional['file'] => Hash[String, Any],
    Optional['ldap'] => Hash[String, Any],
    Optional['pam']  => Hash[String, Any],
}]
