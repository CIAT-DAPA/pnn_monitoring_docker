# PNN Monitoring

The main goal of this project is to design and develop a system for monitoring the activities and resources coming from different actors to finance the implementation of the Sustainability Action Plans (PAS) of the Regional Systems of Protected Areas (SIRAP). The fundamental purpose of this system is to provide authorities and stakeholders with a tool to evaluate and track the level of investment and financial support for the conservation of Colombia's protected areas.

# PNN Database and ETL Integration

This repository combines the PNN Database with an Extract, Transform, Load (ETL) process. The ETL process is orchestrated using Docker Compose, providing seamless integration between the database and the ETL workflow.

## Project Structure

The project is organized into two main components:

1. **PNN Database - pnn_monitoring_database**

   - The database component includes SQL scripts and table structures for a PostgreSQL database related to the PNN project.
   - Tables such as Objective, Sirap, Guideline, and others store essential project information.

2. **ETL Process - pnn_monitoring_etl**
   - The ETL component contains scripts and configurations for extracting, transforming, and loading data into the PNN Database.
   - Docker Compose is utilized to orchestrate the ETL workflow seamlessly.

## Docker Compose Setup

To integrate the ETL process with the PNN Database, Docker Compose is used. The `docker-compose.yml` file defines the services, networks required for both components.

### Prerequisites

Make sure you have Docker and Docker Compose installed on your system.

### Usage

1. **Start the Database and ETL Services:**

   Windows
   ```bash
   set WORKSPACE_PATH=/ruta_local
   set DB_USER=mi_usuario
   set DB_PASSWORD=mi_contraseña
   set DB_NAME=mi_base_de_datos
   ```

   Ubuntu
   ```bash
   export WORKSPACE_PATH=/ruta_local
   export DB_USER=mi_usuario
   export DB_PASSWORD=mi_contraseña
   export DB_NAME=mi_base_de_datos
   ```

   ```bash
   docker-compose up -d
   ```

   ```bash
   docker exec -it  pnn_monitoring_docker-python_app-1 sh
   ```

This command starts the PNN Database and initiates the ETL process.

Additional Information
For detailed information about the PNN Database and ETL process, refer to the respective README files within their directories.

Repositories:

- https://github.com/CIAT-DAPA/pnn_monitoring_database
- https://github.com/CIAT-DAPA/pnn_monitoring_etl/tree/develop
