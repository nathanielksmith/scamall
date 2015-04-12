node 'beren' {
    notify { 'hi':
        message => "FOOBARBRAZ",
    }

    include brain
}
