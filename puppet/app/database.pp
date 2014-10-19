class app::database {
    if $mysql_is_defined == 'true' {
        include app::database::mysql
    }

    if $postgresql_is_defined == 'true' {
        include app::database::postgresql
    }
}

import "database/*.pp"
