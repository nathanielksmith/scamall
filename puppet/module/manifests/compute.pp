class compute () {
  user {'scamall':
    ensure => present,
    managehome => true,
  }

  ssh_authorized_key { 'scamallkey':
    user => 'scamall',
    type => 'ssh-rsa',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Qcos5+Ypjd0yitfMToo6N/XRvSVFxFxqSXw2knWhlDfBUGzx2WUg/qd25s5BxRyUGbr4+PuH9W9rAu7cC+HKL3RzV+inBNUOSjaz2lCFAmz4C0ypP6dcBNk63r6g2Yhg1R4tFSUJzROFQRPrJuRv58qXbvEkwwxcc+Awmu8T3FbV1e+HSw0D1ZcbrUJP9t4p2uMwIPlaYji/6JuwrcHJLNHojclV7AA0QSewAX3Z742OmU35HtnqyYFPDSOWRDqisnj0JOT8Ltnv9jzKasbXWfhNQ2lPL7UFCuM3Ceq4p6uHQWJ9hxvlyY7+b7Du+xPzmL7Lt7/zvmTOQInN',

}
