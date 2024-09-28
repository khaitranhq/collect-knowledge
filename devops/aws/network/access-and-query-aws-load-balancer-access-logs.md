# Access and query AWS Load Balancer access logs

access-and-query-aws-load-balancer-access-logs
Tags: AWS, Elastic Load Balancer
Application: AWS Management

## Enable access logs

### Step 1: Create an S3 bucket

### Step 2: Attach a policy to the S3 bucket

- Region available as of August 2022 and later
  List region:
  - Asia Pacific (Hyderabad)
  - Asia Pacific (Melbourne)
  - Canada West (Calgary)
  - Europe (Spain)
  - Europe (Zurich)
  - Israel (Tel Aviv)
  - Middle East (UAE)
    Policy:
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "logdelivery.elasticloadbalancing.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::bucket-name/prefix/AWSLogs/aws-account-id/*"
      }
    ]
  }
  ```
- Region available before August 2022
  List region with `elb-account-id`
  - US East (N. Virginia) – 127311923021
  - US East (Ohio) – 033677994240
  - US West (N. California) – 027434742980
  - US West (Oregon) – 797873946194
  - Africa (Cape Town) – 098369216593
  - Asia Pacific (Hong Kong) – 754344448648
  - Asia Pacific (Jakarta) – 589379963580
  - Asia Pacific (Mumbai) – 718504428378
  - Asia Pacific (Osaka) – 383597477331
  - Asia Pacific (Seoul) – 600734575887
  - Asia Pacific (Singapore) – 114774131450
  - Asia Pacific (Sydney) – 783225319266
  - Asia Pacific (Tokyo) – 582318560864
  - Canada (Central) – 985666609251
  - Europe (Frankfurt) – 054676820928
  - Europe (Ireland) – 156460612806
  - Europe (London) – 652711504416
  - Europe (Milan) – 635631232127
  - Europe (Paris) – 009996457667
  - Europe (Stockholm) – 897822967062
  - Middle East (Bahrain) – 076674570225
  - South America (São Paulo) – 507241528517
    Policy:
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::elb-account-id:root"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::bucket-name/prefix/AWSLogs/aws-account-id/*"
      }
    ]
  }
  ```

### Step 3: Configure access logs

- Open the load balancer
- On the **Attributes** tab, choose **Edit**.
- For **Monitoring**, turn on **Access logs**.
- For **S3 URI**, enter the S3 URI for your log files. The URI that you specify depends on whether you're using a prefix.
  - URI with a prefix: `s3://*bucket-name*/*prefix*`
  - URI without a prefix: `s3://*bucket-name*`
- Choose **Save changes**.

### Step 4: Verify logs

## Query access logs using Athena

### Create an Athena table

Remember to change `DOC-EXAMPLE-BUCKET/access-log-folder-path`

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS alb_access_logs (
            type string,
            time string,
            elb string,
            client_ip string,
            client_port int,
            target_ip string,
            target_port int,
            request_processing_time double,
            target_processing_time double,
            response_processing_time double,
            elb_status_code int,
            target_status_code string,
            received_bytes bigint,
            sent_bytes bigint,
            request_verb string,
            request_url string,
            request_proto string,
            user_agent string,
            ssl_cipher string,
            ssl_protocol string,
            target_group_arn string,
            trace_id string,
            domain_name string,
            chosen_cert_arn string,
            matched_rule_priority string,
            request_creation_time string,
            actions_executed string,
            redirect_url string,
            lambda_error_reason string,
            target_port_list string,
            target_status_code_list string,
            classification string,
            classification_reason string,
            conn_trace_id string
            )
            ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
            WITH SERDEPROPERTIES (
            'serialization.format' = '1',
            'input.regex' =
        '([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) (.*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-_]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^ ]*)\" \"([^\s]+?)\" \"([^\s]+)\" \"([^ ]*)\" \"([^ ]*)\" ?([^ ]*)?( .*)?')
            LOCATION 's3://DOC-EXAMPLE-BUCKET/access-log-folder-path/'

```

### Example queries

The following query counts the number of HTTP GET requests received by the load balancer grouped by the client IP address:

```sql
SELECT COUNT(request_verb) AS
 count,
 request_verb,
 client_ip
FROM alb_logs
GROUP BY request_verb, client_ip
LIMIT 100;
```

Another query shows the URLs visited by Safari browser users:

```sql
SELECT request_url
FROM alb_logs
WHERE user_agent LIKE '%Safari%'
LIMIT 10;
```

The following query shows records that have ELB status code values greater than or equal to 500.

```sql
SELECT * FROM alb_logs
WHERE elb_status_code >= 500
```

The following example shows how to parse the logs by `datetime`:

```sql
SELECT client_ip, sum(received_bytes)
FROM alb_logs
WHERE parse_datetime(time,'yyyy-MM-dd''T''HH:mm:ss.SSSSSS''Z')
     BETWEEN parse_datetime('2018-05-30-12:00:00','yyyy-MM-dd-HH:mm:ss')
     AND parse_datetime('2018-05-31-00:00:00','yyyy-MM-dd-HH:mm:ss')
GROUP BY client_ip;
```

The following query queries the table that uses partition projection for all ALB logs from the specified day.

```sql
SELECT *
FROM alb_logs
WHERE day = '2022/02/12'
```
