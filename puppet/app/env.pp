class app::env {
    if $symfony == true {
        include app::env::symfony
    }

    include app::env::ruby
}

import "env/*.pp"
