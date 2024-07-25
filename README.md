# Getting started

Things you may want to cover:

Ruby version -> '2.7.1'
Rails version -> '~> 6.0.6'

### System dependencies
Install ruby and rails on you local machine, if already installed skip this step
  - [Install Rails](https://mac.install.guide/rubyonrails/)

Install PostgreSQL on your local machine, follow below link
  - [Install postgresql](https://www.postgresql.org/download/)

### Configuration
Clone the repository or Download zip folder
```shell
git clone git@github.com:shashank76/test_demo.git
```
and then follow below instructions to setup this project on local machine
```shell
cd test_demo
bundle install
```
### Database creation & migration
```shell
rails db:create db:migrate db:seed
```

### How to run the test suite
```shell
bundle exec rspec
```
### How to run the rails server on local machine

```shell
rails server
```
If you wanted to run this server for specific port and production environment on your machine IP
```shell
rails server -p 3000 -e production
```

and after running server, you can check response as below
- [Local Machine server link](http://localhost:3000/apis/v1/buildings.json?page=1&per_page=10)


