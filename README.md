# Data Pipeline Sample

A sample data pipeline project using AWS Glue. This configuration extracts data from RDS, stores it in S3, and enables analysis with Athena.

## 📋 Project Overview

This project consists of the following components:

- **API**: Shop API service (Lambda + API Gateway + Aurora MySQL)
- **Batch**: ETL processing (Glue Jobs + Athena)
- **Infra**: AWS infrastructure configuration (Terraform)
- **Docs**: Design diagrams and documentation
- **Data Lake**: S3-based data lake (Parquet/CSV format)

## 🏗️ System Architecture

### Overall Architecture

![Infrastructure Architecture](docs/architecture/infrastructure.png)

### Data Flow

![Data Flow](docs/flow/data_flow.png)

### API Request Flow

![API Request Flow](docs/flow/api_request_flow.png)
