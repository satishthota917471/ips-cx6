# Local Development Setup CX6

To run CX6 you will need at minimum the following hardware

* Java JDK 8
* Maven 3.5
* Intel Core i5 or higher
* 8 GB RAM (16 GB preferred)
* Access to repo.backbase.com
* Maven Settings File Setup with Backbase Repositories

## Setup Infrastructure Requirements

CX6 requires MySQL and ActiveMQ to be running as services. For your convenience, the platform project also comes 
with a docker-compose that starts these services and binds them to localhost. 

Only Docker Compose version 3.2 and up are supported. More information regarding docker-compose versions can be found 
[here](https://docs.docker.com/compose/compose-file/compose-versioning/#compatibility-matrix)

This project template is tested with:

* [Docker for Mac](https://www.docker.com/docker-mac)
* [Docker for Windows](https://www.docker.com/docker-windows)

If your environment does not support Docker for Mac/Windows, then you must use the native MySQL and ActiveMQ instructions.

### Docker Option:

#### Docker Compose for MySQL and ActiveMQ

Open a new terminal, go to your project folder, navigate to the `platform` folder, where the docker-compose.yml file is
located and run `docker-compose up -d` to start MySQL and Active MQ. Schemas are automatically created the first time
it starts.
Don't close this terminal.

### Native Option:

#### Native MySQL

* Install MySQL 5.7.x or higher
* Configure MySQL according to settings stored in `mysql/config/my.cnf`
* Execute script on: `mysql/scripts/drop_create_cx_schemas.sql`

#### Native ActiveMQ

Install [Active MQ 5.14.x](http://activemq.apache.org/activemq-5145-release.html)

## Start Blade

Make sure that you have access to repo.backbase.com


## Create databases

To create the needed databases and tables, go to `cx6/` folder and execute:

```bash
mvn clean install -Pclean-database
```

## Start Platform Services

To start the Edge Router, Service Registry and Authentication Services go to the `platform` folder and execute:

```bash
mvn blade:run
```

When all platform services are started, you can start the Customer Experience Services. 

## Start Customer Experience Services 

Open a new terminal, go to your project folder, navigate to the cx6 folder and run:

```bash
mvn blade:run
```

Wait until all services in Infra, Portal and Editorial are started on http://localhost:8080 and continue to the next step:
Once Portal and Editorial Services are started continue to the next step:

NOTE: Mobile services are not stared by default as they are marked as optional.

## Provision Statics 

Inside the statics object navigate to `statics`

```bash
mvn bb:provision
```

This will provision all widget collections referenced Maven pom files.


## Import Experience Packages

To import all experience packages configured in the pom files execute in `statics`

```bash
mvn bb:import-experiences
```

To import an experience one by one, navigate to the subdirectory and run `mvn bb:import-experiences` to only import experience packaged configured in the 'bb-maven-plugin'

### Import Experience Manager

Navigate to `statics/collection-experience-manager` and execute:

```bash
mvn bb:import-experiences
```

## Import Packages

Importing page (link) artifacts.
Pages need a destination which is the portal to import into. Before running this command, make sure the portal is already provisioned.

Navigate to `statics/` and execute:

```bash
mvn bb:import-packages
```

## Demo Data

The built in LDAP Server is initiated using an LDIF file. This file is located in:

`platform/config/backbase/authentication-ldap/users.ldif`

This file contains all users and groups available for you to test your local development environment with

- Admin Users
-- admin / admin
-- admin2 / admin
-- new-admin / admin

To enable mock data on the demo portals append `?enable-mocks` to the demo pages. 

For instance: `http://localhost:8080/gateway/retail-banking-demo/index?enable-mocks`



## Reset Database
If you like to reset the database when using docker-compose, you need to shutdown MySQL and ActiveMQ and remove the volume. 

Do do this make sure blade is not running and execute in CX 6

```bash
docker-compose down -v
```

The `-v` option removes the attached MySQL storage volume allowing you to restart



    






