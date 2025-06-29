# データパイプライン インフラ構成図

## 全体アーキテクチャ

```mermaid
graph TB
    %% 外部インターネット
    Internet[🌐 インターネット]
    
    %% ネットワーク層
    subgraph "VPC (10.0.0.0/16)"
        subgraph "Public Subnets"
            AZ1_PUB[🟢 Public Subnet AZ1<br/>10.0.1.0/24]
            AZ2_PUB[🟢 Public Subnet AZ2<br/>10.0.2.0/24]
        end
        
        %% セキュリティグループ
        SG_Bastion[🛡️ Bastion SG]
        SG_RDS[🛡️ RDS SG]
        SG_Lambda[🛡️ Lambda SG]
        SG_Glue[🛡️ Glue SG]
    end
    
    %% コンピューティング層
    subgraph "コンピューティング"
        Bastion[🖥️ Bastion Host<br/>EC2 t3.micro]
        Lambda[⚡ Shop API Lambda<br/>Container Image]
    end
    
    %% データベース層
    subgraph "データベース"
        RDS[🗄️ Aurora MySQL 8.0<br/>Serverless v2<br/>stg_core]
        RDS_Proxy[🔄 RDS Proxy]
    end
    
    %% データレイク層
    subgraph "S3 データレイク"
        S3_ETL[📦 ETL Output Bucket<br/>Parquet/CSV データ]
        S3_Athena[📊 Athena Results<br/>クエリ結果]
        S3_Scripts[📝 Glue Scripts<br/>Python スクリプト]
    end
    
    %% データ処理層
    subgraph "データ処理"
        Glue_Crawler[🕷️ Glue Crawler<br/>スキーマ検出]
        Glue_Catalog[📋 Glue Data Catalog<br/>メタデータ管理]
        Glue_Jobs[⚙️ Glue Jobs<br/>ETL 処理]
        Athena[🔍 Athena<br/>SQL クエリ]
    end
    
    %% API層
    subgraph "API層"
        API_GW[🌐 API Gateway<br/>HTTP API]
        Route53[📍 Route53<br/>DNS管理]
        ACM[🔒 ACM<br/>SSL証明書]
    end
    
    %% 認証・認可層
    subgraph "認証・認可"
        Secrets[🔐 Secrets Manager<br/>DB認証情報]
        IAM[👤 IAM<br/>ロール・ポリシー]
    end
    
    %% 監視・ログ
    subgraph "監視・ログ"
        CloudWatch[📊 CloudWatch<br/>ログ・メトリクス]
        ECR[🐳 ECR<br/>コンテナイメージ]
    end
    
    %% 接続関係
    Internet --> Route53
    Route53 --> API_GW
    API_GW --> Lambda
    Lambda --> RDS_Proxy
    RDS_Proxy --> RDS
    
    Internet --> Bastion
    Bastion --> RDS
    
    %% データフロー
    RDS --> Glue_Crawler
    Glue_Crawler --> Glue_Catalog
    Glue_Catalog --> Glue_Jobs
    Glue_Jobs --> S3_ETL
    S3_ETL --> Athena
    Athena --> S3_Athena
    
    %% 認証・認可フロー
    Secrets --> RDS
    IAM --> Lambda
    IAM --> Glue_Jobs
    IAM --> Bastion
    
    %% 監視フロー
    Lambda --> CloudWatch
    Glue_Jobs --> CloudWatch
    RDS --> CloudWatch
    
    %% コンテナ管理
    ECR --> Lambda
    
    %% セキュリティグループ
    Bastion -.-> SG_Bastion
    Lambda -.-> SG_Lambda
    RDS -.-> SG_RDS
    Glue_Jobs -.-> SG_Glue
    
    %% サブネット配置
    Bastion -.-> AZ1_PUB
    Lambda -.-> AZ1_PUB
    RDS -.-> AZ1_PUB
    RDS -.-> AZ2_PUB
```

## データフロー詳細

### 1. データ抽出・変換フロー (ETL)

```mermaid
sequenceDiagram
    participant Scheduler as EventBridge Scheduler
    participant GlueJob as Glue Job
    participant RDS as Aurora MySQL
    participant S3 as S3 ETL Output
    participant Catalog as Glue Data Catalog
    
    Note over Scheduler: 毎日午前2時実行
    Scheduler->>GlueJob: ジョブ開始
    GlueJob->>RDS: JDBC接続
    RDS-->>GlueJob: データ抽出
    GlueJob->>GlueJob: データ変換・加工
    GlueJob->>S3: Parquet形式で保存
    GlueJob->>Catalog: メタデータ更新
    GlueJob-->>Scheduler: ジョブ完了
```

### 2. データ分析フロー

```mermaid
sequenceDiagram
    participant User as 分析ユーザー
    participant Athena as Athena
    participant Catalog as Glue Data Catalog
    participant S3_ETL as S3 ETL Output
    participant S3_Result as S3 Athena Results
    
    User->>Athena: SQLクエリ実行
    Athena->>Catalog: テーブルスキーマ取得
    Athena->>S3_ETL: データ読み取り
    S3_ETL-->>Athena: データ返却
    Athena->>Athena: クエリ処理
    Athena->>S3_Result: 結果保存
    Athena-->>User: 結果返却
```

### 3. API リクエストフロー

```mermaid
sequenceDiagram
    participant Client as クライアント
    participant Route53 as Route53
    participant API_GW as API Gateway
    participant Lambda as Shop API Lambda
    participant RDS_Proxy as RDS Proxy
    participant RDS as Aurora MySQL
    
    Client->>Route53: DNS解決
    Route53-->>Client: IPアドレス
    Client->>API_GW: HTTPリクエスト
    API_GW->>Lambda: イベント
    Lambda->>RDS_Proxy: データベース接続
    RDS_Proxy->>RDS: クエリ実行
    RDS-->>RDS_Proxy: 結果
    RDS_Proxy-->>Lambda: データ
    Lambda-->>API_GW: レスポンス
    API_GW-->>Client: HTTPレスポンス
```

## 主要コンポーネント詳細

### ネットワーク構成
- **VPC**: `10.0.0.0/16`
- **Public Subnets**: 
  - AZ1: `10.0.1.0/24`
  - AZ2: `10.0.2.0/24`
- **Private Subnets**: 現在コメントアウト（検証用）

### データベース構成
- **Aurora MySQL 8.0**: Serverless v2
- **スケーリング**: 0.5-2 ACU
- **バックアップ**: 1日保持
- **ログ**: audit, error, general, slowquery

### S3バケット構成
1. **ETL Output Bucket**: Glue Jobの出力先
2. **Athena Results Bucket**: クエリ結果保存
3. **Glue Scripts Bucket**: Pythonスクリプト保存

### Glue構成
- **Crawler**: 1時間毎にスキーマ検出
- **Data Catalog**: メタデータ管理
- **Jobs**: ETL処理（現在コメントアウト）

### セキュリティ
- **IAM**: 最小権限の原則
- **Secrets Manager**: データベース認証情報
- **Security Groups**: 必要最小限の通信許可
- **VPC Endpoints**: AWSサービスへのプライベート接続

## 環境情報
- **環境**: staging
- **リージョン**: ap-northeast-1
- **プロジェクト**: data-pipeline-sample
- **命名規則**: `{env}-{project}-{resource}`

## 今後の拡張予定
1. **Glue Jobs**: ETL処理の本格運用
2. **EventBridge Scheduler**: 定期実行の自動化
3. **Private Subnets**: 本番環境でのプライベートサブネット活用
4. **CloudWatch Alarms**: 監視・アラートの強化
5. **Backup Strategy**: データバックアップ戦略の確立
