class app::env {
    if $symfony == 'true' {
        include app::env::symfony
    }

    if $nodejs_version != 'false' {
        include app::env::node
    }

    if $golang_version != 'false' {
        include app::env::go
    }

    include app::env::ruby
}

import "env/*.pp"
