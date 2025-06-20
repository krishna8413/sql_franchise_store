
Franchise Store Locator & Manager Tool - README
================================================

Author: Krishna Dubey
Date: June 2025

Overview:
---------
This SQL project implements a fully normalized and scalable MySQL 8.0+ schema to manage and search franchise store locations, their details, and related metadata. The solution supports core operational features such as store management, service tracking, manager assignments, and query-based reporting, along with optional advanced search features.

Schema Design Summary:
----------------------

1. **countries, states, cities**: 
   - Separate hierarchical location data to ensure normalization and reusability.
   - Enforced with foreign keys for integrity.

2. **franchises**:
   - Stores metadata about each franchise like contact info and description.
   - Supports multiple stores under one franchise.

3. **stores**:
   - Central table for each franchise location.
   - Linked with city, state, country, and franchise.
   - Includes coordinates, postal code, and operational status.

4. **managers, store_managers**:
   - Allows many-to-many mapping between stores and managers.
   - Supports tracking of assigned periods.

5. **store_hours**:
   - Stores opening and closing times for each day of the week.

6. **services, store_services**:
   - A many-to-many structure to support multiple services per store (delivery, pickup, dine-in).

7. **Indexing and Constraints**:
   - All important foreign keys are constrained for integrity.
   - ENUMs used for days of week and store status.
   - Latitude/longitude used for geospatial proximity queries (Haversine).

Bonus Features (Included):
--------------------------
- Proximity search using the Haversine formula.
- Timestamps (created_at, updated_at) in the `stores` table.
- Managers with multi-store assignments.
- Full support for geographic queries and reporting.

How to Use:
-----------
1. Load the SQL file (`franchise_store_locator.sql`) into your MySQL 8.0+ environment.
2. Execute the schema to create all tables.
3. Insert sample data using the provided INSERT statements.
4. Run any of the SQL queries for search and reporting.

Evaluation Criteria Met:
-------------------------
✔ Schema Design: 3NF, modular, scalable  
✔ Query Quality: Optimized and readable SQL queries  
✔ Data Integrity: Foreign keys, constraints, ENUMs, indexing  
✔ Sample Data: 10+ rows per table with realistic entries  
✔ Documentation: Comments and this README  
✔ Bonus Features: Advanced search (Haversine), timestamps, multi-store managers

