class scamall::brain {
  include '::rabbitmq'
  include '::redis::install'
  include '::mongodb'

  include 'scamall::python'
}
