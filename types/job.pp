# @summary Rundeck job type.
type Rundeck::Job = Struct[{
    'path'             => Stdlib::Absolutepath,
    'format'           => Enum['yaml', 'xml', 'json'],
    Optional['ensure'] => Enum['absent', 'present'],
}]
