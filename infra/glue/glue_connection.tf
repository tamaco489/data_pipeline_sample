# =====================================================================================
# Glue Connection for RDS
# =====================================================================================
resource "aws_glue_connection" "core_db" {
  name            = "${local.fqn}-core-db-glue-connection"
  description     = "Glue Connection for Core DB"
  connection_type = "JDBC"

  physical_connection_requirements {
    # 本番は private subnet にしておくのが better
    # NOTE: 利用可能なAZから動的に選択
    availability_zone = data.aws_availability_zones.available.names[0]

    # 本番は private subnet にしておくのが better、Glue の ENI が配置される subnet
    subnet_id = data.terraform_remote_state.network.outputs.vpc.public_subnet_ids[0]

    # Glue から RDS Proxy にアクセスするための SG、つまり、この SG が RDS Proxy の SG から受け入れられるようにする必要がある
    security_group_id_list = [aws_security_group.glue_connection.id]
  }

  connection_properties = {
    # RDS Proxy のエンドポイントと DB 名を指定
    # DOC: https://docs.aws.amazon.com/glue/latest/dg/connection-properties.html
    # e.g. jdbc:mysql://xxx-cluster.cluster-xxx.us-east-1.rds.amazonaws.com:3306/$(database_name)
    JDBC_CONNECTION_URL = "jdbc:mysql://${data.terraform_remote_state.rds_core.outputs.rds_proxy.endpoint}:3306/${var.database_name}"

    # RDS Proxy の認証情報を保持する Secrets Manager を指定
    SECRET_ID = data.terraform_remote_state.credential_core_db.outputs.core_db.name
  }

  tags = { Name = "${local.fqn}-core-db-glue-connection" }
}
