# @summary Rundeck database config type.
type Rundeck::Db_config = Struct[{
    'url'                                  => String,
    Optional['driverClassName']            => String,
    Optional['username']                   => String,
    Optional['password']                   => Variant[String[8], Sensitive[String[8]]],
    Optional['dialect']                    => String,
    Optional['properties.validationQuery'] => String,
}]
