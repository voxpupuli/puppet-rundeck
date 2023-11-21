# Rundeck database config type.
type Rundeck::Db_config = Struct[{
    ['url']                                => String,
    Optional['driverClassName']            => String,
    Optional['username']                   => String,
    Optional['password']                   => String,
    Optional['dialect']                    => String,
    Optional['properties.validationQuery'] => String,
}]
