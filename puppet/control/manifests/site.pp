node 'beren' {
    include 'scamall::brain'

    notify { 'hi':
        message => "FOOBARBRAZ",
    }

}
